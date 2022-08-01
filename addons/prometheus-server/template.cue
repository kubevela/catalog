package main

comps: [{
	type: "k8s-objects"
	name: const.name + "-ns"
	properties: objects: [{
		apiVersion: "v1"
		kind:       "Namespace"
		metadata: name: parameter.namespace
	}]
}, prometheusConfig, prometheusServer, {
	if parameter.storage != _|_ {prometheusStorage}
}, {
	if parameter.thanos {thanosQuery}
}]

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	metadata: {
		name:      const.name
		namespace: "vela-system"
	}
	spec: {
		components: [ for comp in comps if comp.name != _|_ {comp}]
		policies: [{
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
		}, {
			type: "override"
			name: "component-ns"
			properties: selector: [const.name + "-ns"]
		}, {
			type: "override"
			name: "component-prometheus"
			properties: selector: ["prometheus-config", "prometheus-storage", "prometheus-server"]
		}, {
			type: "override"
			name: "component-thanos"
			properties: selector: ["thanos-query"]
		}]
		workflow: steps: [{
			type: "deploy"
			name: "deploy-ns"
			properties: policies: ["component-ns", "topology-distributed"]
		}, {
			type: "deploy"
			name: "deploy-prometheus"
			properties: policies: ["component-prometheus", "topology-distributed"]
		}, {
			type: "deploy"
			name: "deploy-thanos"
			properties: policies: ["component-thanos", "topology-centralized"]
		}]
	}
}
