package controllers

import (
	"context"
	"fmt"
	"github.com/crossplane/oam-kubernetes-runtime/pkg/oam"
	corev1alpha2 "ingresstrait/api/v1alpha2"
	appsv1 "k8s.io/api/apps/v1"
	"k8s.io/api/networking/v1beta1"
	apierrors "k8s.io/apimachinery/pkg/api/errors"
	"k8s.io/apimachinery/pkg/types"
	ctrl "sigs.k8s.io/controller-runtime"
	"sigs.k8s.io/controller-runtime/pkg/client"
)

const (
	KindIngress     = "Ingress"
	KindStatefulSet = "StatefulSet"
)

// TODO:IngressTrait can more than create ingress for the statefulset
// create a ingress for the statefulset
func (r *IngressTraitReconciler) renderIngress(ctx context.Context,
	trait *corev1alpha2.IngressTrait, set *appsv1.StatefulSet) (*v1beta1.Ingress, error) {
	// create a ingress for the ingresstrait
	resources, err := IngressInjector(ctx, trait, []oam.Object{set})
	if err != nil {
		return nil, err
	}
	ingress, ok := resources[1].(*v1beta1.Ingress)
	if !ok {
		return nil, fmt.Errorf("internal error, ingress is not rendered correctly")
	}
	// if you don't set the annotations to specify IngressClassName, it will be the default.
	ingress.ObjectMeta.Annotations = make(map[string]string)
	if trait.ObjectMeta.Annotations != nil {
		for k, v := range trait.ObjectMeta.Annotations {
			ingress.ObjectMeta.Annotations[k] = v
		}
	} else {
		ingress.ObjectMeta.Annotations["kubernetes.io/ingress.class"] = "nginx"
	}
	// always set the controller reference so that we can watch this ingress.
	if err := ctrl.SetControllerReference(trait, ingress, r.Scheme); err != nil {
		return nil, err
	}
	return ingress, nil
}

// delete ingress that are not the same as the existing
func (r *IngressTraitReconciler) cleanupResources(ctx context.Context,
	ingressTr *corev1alpha2.IngressTrait, ingressUID *types.UID) error {
	log := r.Log.WithValues("gc ingress", ingressTr.Name)
	var ingress v1beta1.Ingress
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
		}
	}
	return nil
}
