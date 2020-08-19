package controllers

import (
	"encoding/json"
	"github.com/crossplane/oam-kubernetes-runtime/apis/core/v1alpha2"
	"github.com/crossplane/oam-kubernetes-runtime/pkg/oam/util"
	"github.com/go-logr/logr"
	appsv1 "k8s.io/api/apps/v1"
	corev1 "k8s.io/api/core/v1"
	"k8s.io/apimachinery/pkg/apis/meta/v1/unstructured"
	"k8s.io/apimachinery/pkg/runtime/schema"
	"k8s.io/client-go/scale/scheme/autoscalingv1"
	"k8s.io/kube-openapi/pkg/util/proto"
	"k8s.io/kubectl/pkg/explain"
	"k8s.io/kubectl/pkg/util/openapi"
)

var (
	oamAPIVersion   = v1alpha2.SchemeGroupVersion.String()
	appsAPIVersion  = appsv1.SchemeGroupVersion.String()
	GroupVersionHPA = autoscalingv1.SchemeGroupVersion.String()
)

// Combine sidecar container and target container,if the sidecar name is repeated, it will be overwritten
func combineContainers(resContainers []interface{}, container corev1.Container, log logr.Logger) []interface{} {
	sidecarContainer, err := struct2Unmarshal(container)
	if err != nil {
		log.Error(err, "Failed to deploy sidecar to resource", "sidecar name", container.Name)
		return resContainers
	}

	repeatNo := 0
	repeat := false
	for i, resContainer := range resContainers {
		if container.Name == resContainer.(map[string]interface{})["name"] {
			repeat = true
			repeatNo = i
			break
		}
	}
	if repeat {
		resContainers[repeatNo] = sidecarContainer.Object
	} else {
		resContainers = append(resContainers, sidecarContainer.Object)
	}
	return resContainers
}

// Combine volume and target volume,if the volume name is repeated, it will be overwritten
func combineVolumes(resVolumes []interface{}, volumes []corev1.Volume, log logr.Logger) []interface{} {
	if len(volumes) == 0 {
		return resVolumes
	}

	for _, volume := range volumes {
		sidecarVolume, err := struct2Unmarshal(volume)
		if err != nil {
			log.Error(err, "Failed to add volume to resource", "volume name", volume.Name)
			continue
		}

		repeatNo := 0
		repeat := false
		for i, resVolume := range resVolumes {
			if volume.Name == resVolume.(map[string]interface{})["name"] {
				log.Info("Volume was discarded because of duplicate names", "volume name", volume.Name)
				repeat = true
				repeatNo = i
				break
			}
		}
		if repeat {
			resVolumes[repeatNo] = sidecarVolume.Object
		} else {
			resVolumes = append(resVolumes, sidecarVolume.Object)
		}
	}
	return resVolumes
}

//Convert struct to unstructured
func struct2Unmarshal(obj interface{}) (unstructured.Unstructured, error) {
	marshal, err := json.Marshal(obj)
	var c unstructured.Unstructured
	c.UnmarshalJSON(marshal)
	return c, err
}

//locateField call openapi RESTFUL end point to fetch the schema of a given resource and try to see if it has  fileds that is of type array.
func locateField(document openapi.Resources, res *unstructured.Unstructured, fieldPaths [][]string) (bool, []string) {
	g, v := util.APIVersion2GroupVersion(res.GetAPIVersion())
	// we look up the resource schema definition by its GVK
	schema := document.LookupResource(schema.GroupVersionKind{
		Group:   g,
		Version: v,
		Kind:    res.GetKind(),
	})

	for _, containerFieldPath := range fieldPaths {
		// we try to see if there is a containers fields in its definition
		field, err := explain.LookupSchemaForField(schema, containerFieldPath)
		if err == nil && field != nil {
			// we also verify that it is of type array to further narrow down the candidates
			_, ok := field.(*proto.Array)
			return ok, containerFieldPath
		}
	}
	return false, nil
}

//try to see if it has a containers filed
func locateContainersField(document openapi.Resources, res *unstructured.Unstructured) (bool, []string) {
	//This is the most common path to the container field
	containersFieldPaths := [][]string{
		//This is the path to the containers field of the Pod resource
		{"spec", "containers"},
		//This is the path to the containers field of the Deployments,StatefulSet,ReplicaSet resource
		{"spec", "template", "spec", "containers"},
	}
	return locateField(document, res, containersFieldPaths)
}

//try to see if it has a volumes filed
func locateVolumesField(document openapi.Resources, res *unstructured.Unstructured) (bool, []string) {
	//This is the most common path to the container field
	containersFieldPaths := [][]string{
		//This is the path to the volumes field of the Pod resource
		{"spec", "volumes"},
		//This is the path to the volumes field of the Deployments,StatefulSet,ReplicaSet resource
		{"spec", "template", "spec", "volumes"},
	}
	return locateField(document, res, containersFieldPaths)
}
