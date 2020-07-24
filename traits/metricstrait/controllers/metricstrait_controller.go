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
	oamutil "github.com/crossplane/oam-kubernetes-runtime/pkg/oam/util"
	"github.com/go-logr/logr"
	"github.com/pkg/errors"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
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

var (
	errApplyServiceMonitor = "failed to apply the service monitor"
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
		"metrics label selector", metricsTrait.Spec.Selector,
		"labels", metricsTrait.GetLabels())

	// find the resource object to record the event to, default is the parent appConfig.
	eventObj, err := oamutil.LocateParentAppConfig(ctx, r.Client, &metricsTrait)
	if eventObj == nil {
		// fallback to workload itself
		mLog.Error(err, "metricsTrait", "name", metricsTrait.Name)
		eventObj = &metricsTrait
	}

	// server side apply, only the fields we set are touched
	serviceMonitor := convertToServiceMonitor(&metricsTrait)
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

// convert from metrics traits to service monitor
func convertToServiceMonitor(metricsTrait *v1alpha1.MetricsTrait) *monitoring.ServiceMonitor {
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
				MatchLabels: metricsTrait.Spec.Selector.MatchLabels,
			},
			// we assumed that the service is in the same namespace as the trait
			NamespaceSelector: monitoring.NamespaceSelector{
				MatchNames: []string{metricsTrait.Namespace},
			},
			Endpoints: []monitoring.Endpoint{
				{
					Port:       metricsTrait.Spec.MetricsEndPoint.Port,
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
