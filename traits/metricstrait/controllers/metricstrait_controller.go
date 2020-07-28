/*


Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package controllers

import (
	"context"
	"fmt"
	"reflect"

	monitoring "github.com/coreos/prometheus-operator/pkg/apis/monitoring/v1"
	cpv1alpha1 "github.com/crossplane/crossplane-runtime/apis/core/v1alpha1"
	"github.com/crossplane/crossplane-runtime/pkg/event"
	"github.com/crossplane/oam-kubernetes-runtime/pkg/oam"
	oamutil "github.com/crossplane/oam-kubernetes-runtime/pkg/oam/util"
	"github.com/go-logr/logr"
	"github.com/pkg/errors"
	corev1 "k8s.io/api/core/v1"
	apierrors "k8s.io/apimachinery/pkg/api/errors"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/apis/meta/v1/unstructured"
	"k8s.io/apimachinery/pkg/runtime"
	ctrl "sigs.k8s.io/controller-runtime"
	"sigs.k8s.io/controller-runtime/pkg/client"

	"metricstrait/api/v1alpha1"
)

var (
	// OamServiceMonitorLabel is the pre-defined labels for any service monitor
	// created by the MetricsTrait
	OamServiceMonitorLabel = map[string]string{
		"k8s-app":    "oam",
		"controller": "metricsTrait",
	}
	// the name of the namespace in which the servicemonitor resides
	// it must be the same that the prometheus operator is listening to
	serviceMonitorNSName = "oam-monitoring"
)

var (
	serviceMonitorKind       = reflect.TypeOf(monitoring.ServiceMonitor{}).Name()
	serviceMonitorAPIVersion = monitoring.SchemeGroupVersion.String()
)

const (
	errApplyServiceMonitor = "failed to apply the service monitor"
	errLocatingService     = "failed to locate any the services"

	// TODO: use the common one when it's merged in upstream
	errFetchChildResources = "failed to fetch workload child resources"
)

// MetricsTraitReconciler reconciles a MetricsTrait object
type MetricsTraitReconciler struct {
	client.Client
	Log    logr.Logger
	Scheme *runtime.Scheme
	record event.Recorder
}

// +kubebuilder:rbac:groups=standard.oam.dev,resources=metricstraits,verbs=get;list;watch;create;update;patch;delete
// +kubebuilder:rbac:groups=standard.oam.dev,resources=metricstraits/status,verbs=get;update;patch
// +kubebuilder:rbac:groups=monitoring.coreos.com,resources=*,verbs=get;list;watch;create;update;patch;delete
// +kubebuilder:rbac:groups=monitoring.coreos.com,resources=*/status,verbs=get;update;patch

func (r *MetricsTraitReconciler) Reconcile(req ctrl.Request) (ctrl.Result, error) {
	ctx := context.Background()
	mLog := r.Log.WithValues("metricstrait", req.NamespacedName)
	mLog.Info("Reconcile manualscalar trait")
	// fetch the trait
	var metricsTrait v1alpha1.MetricsTrait
	if err := r.Get(ctx, req.NamespacedName, &metricsTrait); err != nil {
		return ctrl.Result{}, client.IgnoreNotFound(err)
	}
	mLog.Info("Get the metricsTrait trait",
		"metrics end point", metricsTrait.Spec.MetricsEndPoint,
		"workload reference", metricsTrait.Spec.WorkloadReference,
		"labels", metricsTrait.GetLabels())

	// find the resource object to record the event to, default is the parent appConfig.
	eventObj, err := oamutil.LocateParentAppConfig(ctx, r.Client, &metricsTrait)
	if eventObj == nil {
		// fallback to workload itself
		mLog.Error(err, "add events to metricsTrait itself", "name", metricsTrait.Name)
		eventObj = &metricsTrait
	}

	var serviceLabel map[string]string

	if len(metricsTrait.Spec.MetricsEndPoint.PortName) != 0 {
		// this means the
		serviceLabel, err = r.fetchServicesLabel(ctx, mLog, &metricsTrait, eventObj, metricsTrait.Spec.MetricsEndPoint.PortName)
		if err != nil {
			return oamutil.ReconcileWaitResult,
				oamutil.PatchCondition(ctx, r, &metricsTrait,
					cpv1alpha1.ReconcileError(errors.Wrap(err, errLocatingService)))
		}
	}

	// server side apply, only the fields we set are touched
	serviceMonitor := constructServiceMonitor(&metricsTrait, serviceLabel)
	applyOpts := []client.PatchOption{client.ForceOwnership, client.FieldOwner(metricsTrait.GetUID())}
	if err := r.Patch(ctx, serviceMonitor, client.Apply, applyOpts...); err != nil {
		mLog.Error(err, "Failed to apply to serviceMonitor")
		r.record.Event(eventObj, event.Warning(event.Reason(errApplyServiceMonitor), err))
		return oamutil.ReconcileWaitResult,
			oamutil.PatchCondition(ctx, r, &metricsTrait,
				cpv1alpha1.ReconcileError(errors.Wrap(err, errApplyServiceMonitor)))
	}
	r.record.Event(eventObj, event.Normal("ServiceMonitor created",
		fmt.Sprintf("successfully server side patched a serviceMonitor `%s`", serviceMonitor.Name)))

	r.gcOrphanServiceMonitor(ctx, mLog, &metricsTrait)

	return ctrl.Result{}, oamutil.PatchCondition(ctx, r, &metricsTrait, cpv1alpha1.ReconcileSuccess())
}

// fetch the label of the service
func (r *MetricsTraitReconciler) fetchServicesLabel(ctx context.Context, mLog logr.Logger, metricsTrait oam.Trait,
	eventObj oam.Object, portName string) (map[string]string, error) {
	// Fetch the workload instance to which we want to expose metrics
	workload, err := oamutil.FetchWorkload(ctx, r, mLog, metricsTrait)
	if err != nil {
		if !apierrors.IsNotFound(err) {
			mLog.Error(err, "Error while fetching the workload", "workload reference",
				metricsTrait.GetWorkloadReference())
			r.record.Event(eventObj, event.Warning(oamutil.ErrLocateWorkload, err))
			return nil, err
		}
	}
	// Fetch the child resources list from the corresponding workload
	resources, err := oamutil.FetchWorkloadChildResources(ctx, mLog, r, workload)
	if err != nil {
		if !apierrors.IsNotFound(err) {
			mLog.Error(err, "Error while fetching the workload child resources", "workload", workload.UnstructuredContent())
			r.record.Event(eventObj, event.Warning(errFetchChildResources, err))
			return nil, err
		} else {
			mLog.Error(err, "Cannot locate workload definition", "workload", workload.UnstructuredContent())
			return nil, nil
		}
	}
	// find the service that has the port
	for _, childRes := range resources {
		if childRes.GetAPIVersion() == corev1.SchemeGroupVersion.String() &&
			childRes.GetKind() == reflect.TypeOf(corev1.Service{}).Name() {
			ports, exist, err := unstructured.NestedSlice(childRes.Object, "spec", "ports")
			if !exist || err != nil {
				panic(fmt.Errorf("unexpected service format: +v%", childRes.Object))
			}
			for _, port := range ports {
				servicePort, ok := port.(corev1.ServicePort)
				if !ok {
					panic(fmt.Errorf("unexpected service format: +v%", childRes.Object))
				}
				if servicePort.Name == portName {
					return childRes.GetLabels(), nil
				}
			}
		}
	}
	return nil, nil
}

// remove all service monitors that are no longer used
func (r *MetricsTraitReconciler) gcOrphanServiceMonitor(ctx context.Context, mLog logr.Logger,
	metricsTrait *v1alpha1.MetricsTrait) {
	var gcCandidates []string
	copy(metricsTrait.Status.ServiceMonitorNames, gcCandidates)
	// re-initialize to the current service monitor
	metricsTrait.Status.ServiceMonitorNames = []string{metricsTrait.Name}
	for _, smn := range gcCandidates {
		if smn != metricsTrait.Name {
			if err := r.Delete(ctx, &monitoring.ServiceMonitor{
				TypeMeta: metav1.TypeMeta{
					Kind:       serviceMonitorKind,
					APIVersion: serviceMonitorAPIVersion,
				},
				ObjectMeta: metav1.ObjectMeta{
					Name:      smn,
					Namespace: metricsTrait.GetNamespace(),
				},
			}, client.GracePeriodSeconds(10)); err != nil {
				mLog.Error(err, "Failed to delete serviceMonitor", "name", smn, "error", err)
				// add it back
				metricsTrait.Status.ServiceMonitorNames = append(metricsTrait.Status.ServiceMonitorNames, smn)
			}
		}
	}
}

// construct a serviceMonitor given a metrics trait along with a label selector pointing to the underlying service
func constructServiceMonitor(metricsTrait *v1alpha1.MetricsTrait,
	serviceLabels map[string]string) *monitoring.ServiceMonitor {
	return &monitoring.ServiceMonitor{
		TypeMeta: metav1.TypeMeta{
			Kind:       serviceMonitorKind,
			APIVersion: serviceMonitorAPIVersion,
		},
		ObjectMeta: metav1.ObjectMeta{
			Name:      metricsTrait.Name,
			Namespace: serviceMonitorNSName,
			Labels:    OamServiceMonitorLabel,
		},
		Spec: monitoring.ServiceMonitorSpec{
			Selector: metav1.LabelSelector{
				MatchLabels: serviceLabels,
			},
			// we assumed that the service is in the same namespace as the trait
			NamespaceSelector: monitoring.NamespaceSelector{
				MatchNames: []string{metricsTrait.Namespace},
			},
			Endpoints: []monitoring.Endpoint{
				{
					Port:       metricsTrait.Spec.MetricsEndPoint.PortName,
					TargetPort: metricsTrait.Spec.MetricsEndPoint.TargetPort,
					Path:       metricsTrait.Spec.MetricsEndPoint.Path,
					Interval:   metricsTrait.Spec.MetricsEndPoint.Interval,
				},
			},
		},
	}
}

func (r *MetricsTraitReconciler) SetupWithManager(mgr ctrl.Manager) error {
	r.record = event.NewAPIRecorder(mgr.GetEventRecorderFor("MetricsTrait"))
	return ctrl.NewControllerManagedBy(mgr).
		For(&v1alpha1.MetricsTrait{}).
		Owns(&monitoring.ServiceMonitor{}).
		Complete(r)
}
