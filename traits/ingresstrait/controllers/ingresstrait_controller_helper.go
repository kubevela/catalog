package controllers

import (
	"context"
	"encoding/json"
	"fmt"
	"github.com/crossplane/oam-controllers/pkg/oam/util"
	"github.com/crossplane/oam-kubernetes-runtime/pkg/oam"
	corev1alpha2 "github.com/oam-dev/catalog/traits/ingresstrait/api/v1alpha2"
	"github.com/pkg/errors"
	corev1 "k8s.io/api/core/v1"
	"k8s.io/api/networking/v1beta1"
	apierrors "k8s.io/apimachinery/pkg/api/errors"
	"k8s.io/apimachinery/pkg/apis/meta/v1/unstructured"
	"k8s.io/apimachinery/pkg/types"
	"k8s.io/apimachinery/pkg/util/intstr"
	ctrl "sigs.k8s.io/controller-runtime"
	"sigs.k8s.io/controller-runtime/pkg/client"
)

const (
	KindIngress = "Ingress"
	KindService = "Service"
)

// create a ingress for the workload
func (r *IngressTraitReconciler) renderIngress(ctx context.Context, trait *corev1alpha2.IngressTrait,
	obj oam.Object, svcInfo *corev1alpha2.InternalBackend) (*corev1.Service, *v1beta1.Ingress, error) {
	// create a ingress
	resources, err := r.IngressInjector(ctx, trait, []oam.Object{obj}, svcInfo)
	if err != nil {
		return nil, nil, err
	}

	var ingress *v1beta1.Ingress
	var service *corev1.Service
	var ok bool
	// If the length is 2, the service is not created
	if len(resources) == 2 {
		ingress, ok = resources[1].(*v1beta1.Ingress)
		if !ok {
			return nil, nil, fmt.Errorf("internal error, ingress is not rendered correctly")
		}
	} else {
		service, ok = resources[1].(*corev1.Service)
		if !ok {
			return nil, nil, fmt.Errorf("internal error, service is not rendered correctly")
		}
		if err := ctrl.SetControllerReference(trait, service, r.Scheme); err != nil {
			return nil, nil, err
		}

		ingress, ok = resources[2].(*v1beta1.Ingress)
		if !ok {
			return nil, nil, fmt.Errorf("internal error, ingress is not rendered correctly")
		}
	}
	if err := ctrl.SetControllerReference(trait, ingress, r.Scheme); err != nil {
		return nil, nil, err
	}
	return service, ingress, nil
}

// delete ingress that are not the same as the existing
func (r *IngressTraitReconciler) cleanupResources(ctx context.Context,
	ingressTr *corev1alpha2.IngressTrait, ingressUID, serviceUID *types.UID) error {
	log := r.Log.WithValues("gc ingress", ingressTr.Name)
	var ingress v1beta1.Ingress
	var service corev1.Service
	for _, res := range ingressTr.Status.Resources {
		uid := res.UID
		if res.Kind == KindIngress && res.APIVersion == v1beta1.SchemeGroupVersion.String() {
			if uid != *ingressUID {
				log.Info("Found an orphaned ingress", "orphaned UID", uid)
				in := client.ObjectKey{Name: res.Name, Namespace: ingressTr.Namespace}
				if err := r.Get(ctx, in, &ingress); err != nil {
					if apierrors.IsNotFound(err) {
						continue
					}
					return err
				}
				if err := r.Delete(ctx, &ingress); err != nil {
					return err
				}
				log.Info("Removed an orphaned ingress", "orphaned UID", uid)
			}
		} else if res.Kind == util.KindService && res.APIVersion == corev1.SchemeGroupVersion.String() && *serviceUID != types.UID(0) {
			if uid != *serviceUID {
				log.Info("Found an orphaned service", "orphaned  UID", uid)
				sn := client.ObjectKey{Name: res.Name, Namespace: ingressTr.Namespace}
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
		}
	}
	return nil
}

// get the service information to create the ingress
func (r *IngressTraitReconciler) getServiceInfo(ctx context.Context, resources []*unstructured.Unstructured) (*corev1alpha2.InternalBackend, error) {
	var serviceInfo corev1alpha2.InternalBackend
	// Determine whether the workload has a service or not
	if len(resources) == 1 {
		// It turns out to be a K8S native resource
		// TODO: If the resource already has a service, we might be able to get its information by the selector
	} else {
		for _, res := range resources {
			if res.GetAPIVersion() == corev1.SchemeGroupVersion.String() && res.GetKind() == KindService {
				r.Log.Info("Get the Service chiled resource of the workload",
					"Service name", res.GetName(), "UID", res.GetUID())
				var svc corev1.Service
				bts, _ := json.Marshal(res)
				if err := json.Unmarshal(bts, &svc); err != nil {
					return nil, errors.Wrap(err, "Failed to convert an unstructured obj to a service")
				}
				serviceInfo.ServiceName = svc.Name
				for _, p := range svc.Spec.Ports {
					serviceInfo.ServicePort = append(serviceInfo.ServicePort, intstr.FromInt(int(p.Port)))
				}
			}
		}
	}

	return &serviceInfo, nil
}
