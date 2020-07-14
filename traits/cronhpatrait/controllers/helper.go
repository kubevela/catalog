package controllers

import (
	"context"
	"fmt"

	"github.com/crossplane/oam-kubernetes-runtime/apis/core/v1alpha2"
	"github.com/crossplane/oam-kubernetes-runtime/pkg/oam/util"

	"github.com/go-logr/logr"
	"github.com/pkg/errors"
	appsv1 "k8s.io/api/apps/v1"
	"k8s.io/apimachinery/pkg/apis/meta/v1/unstructured"
	"sigs.k8s.io/controller-runtime/pkg/client"
)

var (
	workloadAPIVersion = v1alpha2.SchemeGroupVersion.String()
	appsAPIVersion     = appsv1.SchemeGroupVersion.String()
)

// Determine whether the workload is K8S native resources or oam WorkloadDefinition
func DetermineWorkloadType(ctx context.Context, log logr.Logger, r client.Reader,
	workload *unstructured.Unstructured) ([]*unstructured.Unstructured, error) {
	apiVersion := workload.GetAPIVersion()
	switch apiVersion {
	case workloadAPIVersion:
		return util.FetchWorkloadChildResources(ctx, log, r, workload)
	case appsAPIVersion:
		log.Info("workload is K8S native resources", "APIVersion", apiVersion)
		return []*unstructured.Unstructured{workload}, nil
	case "":
		return nil, errors.Errorf(fmt.Sprint("failed to get the workload apiVersion"))
	default:
		return nil, errors.Errorf(fmt.Sprint("This trait doesn't support the type", apiVersion))
	}
}
