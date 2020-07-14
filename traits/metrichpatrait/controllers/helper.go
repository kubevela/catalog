package controllers

import (
	"context"
	"encoding/json"
	"reflect"

	"github.com/crossplane/oam-kubernetes-runtime/pkg/oam/util"
	kedav1alpha1 "github.com/kedacore/keda/pkg/apis/keda/v1alpha1"

	// "github.com/crossplane/oam-kubernetes-runtime/pkg/oam"
	"github.com/go-logr/logr"
	extendv1alpha2 "github.com/oam-dev/catalog/traits/metrichpatrait/api/v1alpha2"
	appsv1 "k8s.io/api/apps/v1"
	corev1 "k8s.io/api/core/v1"
	apierrors "k8s.io/apimachinery/pkg/api/errors"
	v1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/apis/meta/v1/unstructured"
	"k8s.io/apimachinery/pkg/types"

	ctrl "sigs.k8s.io/controller-runtime"
	"sigs.k8s.io/controller-runtime/pkg/client"
)

const (
	GVKDeployment = "apps/v1, Kind=Deployment"
	GVKService    = "/v1, Kind=Service"
)

var (
	var_1   int32 = 1
	var_420 int32 = 420

	defaultPromeServerPort int32 = 9090
)

func (r *MetricHPATraitReconciler) getReferecedWrokload(ctx context.Context, log logr.Logger, trait *extendv1alpha2.MetricHPATrait) (*unstructured.Unstructured, ctrl.Result, error) {
	wlRef := trait.Spec.WorkloadReference
	var workload unstructured.Unstructured
	workload.SetAPIVersion(wlRef.APIVersion)
	workload.SetKind(wlRef.Kind)

	wn := client.ObjectKey{Name: wlRef.Name, Namespace: trait.GetNamespace()}
	if err := r.Get(ctx, wn, &workload); err != nil {
		log.Error(err, "Cannot find referenced workload", "kind", wlRef.Kind, "workload name", wlRef.Name)
		return nil, util.ReconcileWaitResult, err
	}
	return &workload, ctrl.Result{}, nil
}

func (r *MetricHPATraitReconciler) getCWChildResource(res []*unstructured.Unstructured) (*appsv1.Deployment, *corev1.Service, error) {
	var deployment appsv1.Deployment
	var service corev1.Service
	for _, r := range res {
		resGVK := r.GetObjectKind().GroupVersionKind().String()

		switch resGVK {
		case GVKDeployment:
			bts, _ := json.Marshal(r)
			if err := json.Unmarshal(bts, &deployment); err != nil {
				return nil, nil, err
			}
		case GVKService:
			bts, _ := json.Marshal(r)
			if err := json.Unmarshal(bts, &service); err != nil {
				return nil, nil, err
			}
		}
	}
	return &deployment, &service, nil
}

func renderPrometheusResources(trait *extendv1alpha2.MetricHPATrait) (*appsv1.Deployment, *corev1.Service) {
	deploymentName := "prometheus-deployment-" + trait.Spec.WorkloadReference.Name
	serviceName := "prometheus-service-" + trait.Spec.WorkloadReference.Name // use workload name to identify
	labelKey := "app"
	labelValue := "prometheus-server-" + trait.Spec.WorkloadReference.Name

	deployment := &appsv1.Deployment{
		TypeMeta: v1.TypeMeta{
			Kind:       reflect.TypeOf(appsv1.Deployment{}).Name(),
			APIVersion: appsv1.SchemeGroupVersion.String(),
		},
		ObjectMeta: v1.ObjectMeta{
			Name:      deploymentName,
			Namespace: trait.GetNamespace(),
		},
		Spec: appsv1.DeploymentSpec{
			Replicas: &var_1,
			Selector: &v1.LabelSelector{
				MatchLabels: map[string]string{
					labelKey: labelValue,
				},
			},
			Template: corev1.PodTemplateSpec{
				ObjectMeta: v1.ObjectMeta{
					Labels: map[string]string{
						labelKey: labelValue,
					},
				},
				Spec: corev1.PodSpec{
					Volumes: []corev1.Volume{
						{
							Name: "prometheus-config-volume",
							VolumeSource: corev1.VolumeSource{
								ConfigMap: &corev1.ConfigMapVolumeSource{
									LocalObjectReference: corev1.LocalObjectReference{
										Name: "prom-conf-" + trait.Spec.WorkloadReference.Name, // use cw name as configmap name
									},
								},
							},
						},
						{
							Name: "prometheus-storage-volume",
							VolumeSource: corev1.VolumeSource{
								EmptyDir: &corev1.EmptyDirVolumeSource{
									Medium:    "",
									SizeLimit: nil,
								},
							},
						},
					},
					Containers: []corev1.Container{
						{
							Name:  "prometheus",
							Image: "prom/prometheus",
							Args: []string{
								"--config.file=/etc/prometheus/prometheus.yml",
								"--storage.tsdb.path=/prometheus/",
							},
							Ports: []corev1.ContainerPort{
								{
									ContainerPort: defaultPromeServerPort,
									Protocol:      corev1.ProtocolTCP,
								},
							},
							VolumeMounts: []corev1.VolumeMount{
								{
									Name:      "prometheus-config-volume",
									MountPath: "/etc/prometheus/",
								},
								{
									Name:      "prometheus-storage-volume",
									MountPath: "/prometheus/",
								},
							},
						},
					},
				},
			},
		},
	}

	service := &corev1.Service{
		TypeMeta: v1.TypeMeta{
			Kind:       reflect.TypeOf(corev1.Service{}).Name(),
			APIVersion: corev1.SchemeGroupVersion.String(),
		},
		ObjectMeta: v1.ObjectMeta{
			Name:      serviceName,
			Namespace: trait.GetNamespace(),
		},
		Spec: corev1.ServiceSpec{
			Ports: []corev1.ServicePort{
				{
					Name:     "",
					Protocol: "TCP",
					Port:     9090,
				},
			},
			Selector: map[string]string{
				labelKey: labelValue,
			},
		}}
	return deployment, service
}

func (r *MetricHPATraitReconciler) cleanupResources(ctx context.Context,
	trait *extendv1alpha2.MetricHPATrait, deployUID, serviceUID, scaledobjectUID *types.UID) error {
	log := r.Log.WithValues("gc KEDA.scaledobject", trait.Name)
	var deploy appsv1.Deployment
	var service corev1.Service
	var scaledobject kedav1alpha1.ScaledObject
	for _, res := range trait.Status.Resources {
		uid := res.UID
		if res.Kind == util.KindDeployment && res.APIVersion == appsv1.SchemeGroupVersion.String() {
			if uid != *deployUID {
				log.Info("Found an orphaned deployment", "deployment UID", *deployUID, "orphaned  UID", uid)
				dn := client.ObjectKey{Name: res.Name, Namespace: trait.Namespace}
				if err := r.Get(ctx, dn, &deploy); err != nil {
					if apierrors.IsNotFound(err) {
						continue
					}
					return err
				}
				if err := r.Delete(ctx, &deploy); err != nil {
					return err
				}
				log.Info("Removed an orphaned deployment", "deployment UID", *deployUID, "orphaned UID", uid)
			}
		} else if res.Kind == util.KindService && res.APIVersion == corev1.SchemeGroupVersion.String() {
			if uid != *serviceUID {
				log.Info("Found an orphaned service", "orphaned  UID", uid)
				sn := client.ObjectKey{Name: res.Name, Namespace: trait.Namespace}
				if err := r.Get(ctx, sn, &service); err != nil {
					if apierrors.IsNotFound(err) {
						continue
					}
					return err
				}
				if err := r.Delete(ctx, &service); err != nil {
					return err
				}
				log.Info("Removed an orphaned service", "orphaned UID", uid)
			}
		} else if res.Kind == reflect.TypeOf(kedav1alpha1.ScaledObject{}).Name() && res.APIVersion == kedav1alpha1.SchemeGroupVersion.String() {
			if uid != *scaledobjectUID {
				log.Info("Found an orphaned KEDA.scaledobject", "orphaned UID", uid)
				son := client.ObjectKey{Name: res.Name, Namespace: trait.Namespace}
				if err := r.Get(ctx, son, &scaledobject); err != nil {
					if apierrors.IsNotFound(err) {
						continue
					}
					return err
				}
				if err := r.Delete(ctx, &scaledobject); err != nil {
					return err
				}
				log.Info("Removed an orphaned KEDA.scaledobject", "orphaned UID", uid)
			}

		}
	}
	return nil
}
