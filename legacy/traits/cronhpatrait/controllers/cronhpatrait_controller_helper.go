package controllers

import (
	"context"
	"reflect"

	apierrors "k8s.io/apimachinery/pkg/api/errors"
	"k8s.io/apimachinery/pkg/types"
	"sigs.k8s.io/controller-runtime/pkg/client"

	"github.com/crossplane/oam-kubernetes-runtime/pkg/oam"
	ctrl "sigs.k8s.io/controller-runtime"

	"github.com/AliyunContainerService/kubernetes-cronhpa-controller/pkg/apis/autoscaling/v1beta1"
	corev1alpha2 "github.com/oam-dev/catalog/traits/cronhpatrait/api/v1alpha2"
)

var (
	kindCronHPA = reflect.TypeOf(v1beta1.CronHorizontalPodAutoscaler{}).Name()
)

// create a cronHPA for the workload
func (r *CronHPATraitReconciler) renderCronHPA(ctx context.Context, trait *corev1alpha2.CronHPATrait,
	obj oam.Object) (*v1beta1.CronHorizontalPodAutoscaler, error) {
	// create a cronHPA
	cronHPA, err := r.CronHPAInjector(ctx, trait, obj)
	if err != nil {
		return nil, err
	}

	if err := ctrl.SetControllerReference(trait, cronHPA, r.Scheme); err != nil {
		return nil, err
	}

	return cronHPA, nil
}

// delete cronHPA that are not the same as the existing
func (r *CronHPATraitReconciler) cleanupResources(ctx context.Context,
	trait *corev1alpha2.CronHPATrait, cronHPAUID *types.UID) error {
	log := r.Log.WithValues("gc cronHPA", trait.Name)
	var cronHPA v1beta1.CronHorizontalPodAutoscaler
	for _, res := range trait.Status.Resources {
		uid := res.UID
		if res.Kind != kindCronHPA || res.APIVersion != v1beta1.SchemeGroupVersion.String() || uid == *cronHPAUID {
			continue
		}

		log.Info("Found an orphaned cronHPA", "orphaned UID", uid)
		in := client.ObjectKey{Name: res.Name, Namespace: trait.Namespace}
		if err := r.Get(ctx, in, &cronHPA); err != nil {
			if apierrors.IsNotFound(err) {
				continue
			}
			return err
		}
		if err := r.Delete(ctx, &cronHPA); err != nil {
			return err
		}
		log.Info("Removed an orphaned cronHPA", "orphaned UID", uid)
	}
	return nil
}
