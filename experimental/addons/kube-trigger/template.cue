package main

import "strings"

// controller images prefix
_base: *"" | string

if parameter.registry != _|_ && parameter.registry != "" && !strings.HasSuffix(parameter.registry, "/") {
	_base: parameter.registry + "/"
}
if parameter.registry == _|_ || parameter.registry == "" || strings.HasSuffix(parameter.registry, "/") {
	_base: parameter.registry
}

_targetNamespace: *"kube-trigger-system" | string

if parameter.namespace != _|_ {
	_targetNamespace: parameter.namespace
}

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	spec: {
		components: [
			{
				type: "k8s-objects"
				name: "kube-trigger-ns"
				properties: objects: [{
					apiVersion: "v1"
					kind:       "Namespace"
					metadata: name: _targetNamespace
				}]
			},
			{
				type: "k8s-objects"
				name: "kube-trigger-objects"
				dependsOn: ["kube-trigger-ns"]
				properties: objects: [
					deployment,
					rbacClusterRuleBinding,
					rbacSA,
					rbacLeaderElection,
					rbacLeaderElectionRoleBinding,
					rbacClusterRole,
				]
			},
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
				name: "deploy-kube-trigger-ns"
				properties: {
					namespace: _targetNamespace
					if parameter.clusters != _|_ {
						clusters: parameter.clusters
					}
					if parameter.clusters == _|_ {
						clusterLabelSelector: {}
					}
				}
			},
			{
				type: "garbage-collect"
				name: "not-gc-CRD"
				properties: {
					rules: [{
						selector: resourceTypes: ["CustomResourceDefinition"]
						strategy: "never"
					},
					]
				}
			},
			{
				type: "apply-once"
				name: "not-keep-CRD"
				properties: {
					rules: [{
						selector: resourceTypes: ["CustomResourceDefinition"]
						strategy: {
							path: ["*"]
						}
					},
					]
				}
			},
		]
	}
}

outputs: topology: resourceTopology
