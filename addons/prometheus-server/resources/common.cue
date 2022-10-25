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
	name: "ignore-recycle-pvc"
	properties: rules: [{
		selector: resourceTypes: ["PersistentVolumeClaim"]
		strategy: "never"
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
}]
