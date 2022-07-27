package main

import "strings"

if parameter.registry != "" && !strings.HasSuffix(parameter.registry, "/") {
	_base: parameter.registry + "/"
}
if parameter.registry == "" || strings.HasSuffix(parameter.registry, "/") {
	_base: parameter.registry
}

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	spec: {
		components: [
			{
				type: "k8s-objects"
				name: "fluxcd-ns"
				properties: objects: [{
					apiVersion: "v1"
					kind:       "Namespace"
					metadata: name: parameter.namespace
				}]
			},
			{
				type: "k8s-objects"
				name: "fluxcd-rbac"
				properties: objects: [
					// auto-generated from original yaml files
					binding_cluster_admin,
					binding_crd_controller,
					crd_controller,
					rbac_helm_controller,
					rbac_image_automation_controller,
					rbac_image_reflector_controller,
					rbac_kustomize_controller,
					rbac_source_controller,
				]
			},
			helmController,
			imageAutomationController,
			imageReflectorController,
			kustomizeController,
			sourceController,
		]
		policies: [
			{
				type: "shared-resource"
				name: "namespace"
				properties: rules: [{
					selector: resourceTypes: ["Namespace"]
				}]
			},
			{
				type: "topology"
				name: "deploy-fluxcd-ns"
				properties: {
					namespace: parameter.namespace
					if parameter.clusters != _|_ {
						clusters: parameter.clusters
					}
					if parameter.clusters == _|_ {
						clusterLabelSelector: {}
					}
				}
			},
		]
	}
}
