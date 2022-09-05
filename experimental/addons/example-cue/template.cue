package main

import "strings"

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	spec: {
		components: [
			{
				type: "k8s-objects"
				name: "fluxcd-rbac"
				properties: objects: [
					// auto-generated from original yaml files
					bindingClusterAdmin,
				]
			},
			{
				type: "k8s-objects"
				name: "fluxcd-CRD"
				properties: objects: [
							// auto-generated from original yaml files
							bucketCRD,
							gitRepoCRD,
							helmChartCRD,
							helmReleaseCRD,
							helmRepoCRD,
				]
			},
			helmController,
			sourceController,
		]
	}
}
