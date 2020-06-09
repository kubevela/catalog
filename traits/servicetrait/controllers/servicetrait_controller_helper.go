package controllers

import (
	"context"
	"fmt"
	"github.com/crossplane/oam-kubernetes-runtime/pkg/oam"
	corev1alpha2 "github.com/oam-dev/catalog/traits/servicetrait/api/v1alpha2"
	corev1 "k8s.io/api/core/v1"
	apierrors "k8s.io/apimachinery/pkg/api/errors"
	"k8s.io/apimachinery/pkg/types"
	ctrl "sigs.k8s.io/controller-runtime"
	"sigs.k8s.io/controller-runtime/pkg/client"
)

const (
	KindService = "Service"
)

// TODO:ServiceTrait can more than create services for the statefulset
// create a service for the statefulset
func (r *ServiceTraitReconciler) renderService(ctx context.Context,
	trait *corev1alpha2.ServiceTrait, obj oam.Object) (*corev1.Service, error) {

	// create a service for the servicetrait
	resources, err := ServiceInjector(ctx, trait, []oam.Object{obj})
	if err != nil {
		return nil, err
	}
	service, ok := resources[1].(*corev1.Service)
	if !ok {
		return nil, fmt.Errorf("internal error, service is not rendered correctly")
	}
	// k8s server-side patch complains if the protocol is not set
	for i := 0; i < len(service.Spec.Ports); i++ {
		service.Spec.Ports[i].Protocol = corev1.ProtocolTCP
	}
	// always set the controller reference so that we can watch this service
	if err := ctrl.SetControllerReference(trait, service, r.Scheme); err != nil {
		return nil, err
	}
	return service, nil
}

// delete services that are not the same as the existing
func (r *ServiceTraitReconciler) cleanupResources(ctx context.Context,
	service *corev1alpha2.ServiceTrait, svcUID *types.UID) error {
	log := r.Log.WithValues("gc service", service.Name)
	var svc corev1.Service
	for _, res := range service.Status.Resources {
		uid := res.UID
		if res.Kind == KindService && res.APIVersion == corev1.SchemeGroupVersion.String() {
			if uid != *svcUID {
				log.Info("Found an orphaned service", "orphaned UID", uid)
				sn := client.ObjectKey{Name: res.Name, Namespace: service.Namespace}
				if err := r.Get(ctx, sn, &svc); err != nil {
					if apierrors.IsNotFound(err) {
						continue
					}
					return err
				}
				if err := r.Delete(ctx, &svc); err != nil {
					return err
				}
				log.Info("Removed an orphaned service", "orphaned UID", uid)
			}
		}
	}
	return nil
}
