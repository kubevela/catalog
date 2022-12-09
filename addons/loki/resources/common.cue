package main

o11yNamespace: {
	type: "k8s-objects"
	name: const.name + "-ns"
	properties: objects: [{
		apiVersion: "v1"
		kind:       "Namespace"
		metadata: name: parameter.namespace
	}]
}

commonPolicies: [{
	type: "shared-resource"
	name: "namespace"
	properties: rules: [{selector: resourceTypes: ["Namespace"]}]
}, {
	type: "garbage-collect"
	name: "ignore-recycle-pvc-and-crd"
	properties: rules: [{
		selector: resourceTypes: ["PersistentVolumeClaim", "CustomResourceDefinition"]
		strategy: "never"
	}]
}, {
	type: "apply-once"
	name: "not-keep-crd"
	properties: rules: [{
		selector: resourceTypes: ["CustomResourceDefinition"]
		strategy: path: ["*"]
	}]
}, {
	type: "topology"
	name: "topology-distributed"
	properties: {
		if parameter.clusters != _|_ {
			clusters: parameter.clusters
		}
		if parameter.clusters == _|_ {
			clusterLabelSelector: {}
		}
		namespace: parameter.namespace
	}
}, {
	type: "topology"
	name: "topology-centralized"
	properties: {
		clusters: ["local"]
		namespace: parameter.namespace
	}
}, {
	type: "topology"
	name: "topology-distributed-exclude-local"
	properties: {
		if parameter.clusters != _|_ {
			clusters: [ for c in parameter.clusters if c != "local" {c}]
		}
		if parameter.clusters == _|_ {
			clusterLabelSelector: {
				"cluster.core.oam.dev/control-plane": "false"
			}
		}
		namespace:  parameter.namespace
		allowEmpty: true
	}
}, {
	type: "override"
	name: "o11y-namespace"
	properties: selector: [o11yNamespace.name]
}]
