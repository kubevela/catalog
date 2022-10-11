package main

ns: {
	type: "k8s-objects"
	name: const.name + "-ns"
	properties: objects: [{
		apiVersion: "v1"
		kind:       "Namespace"
		metadata: name: parameter.namespace
	}]
}

dashboardComponents: [
	grafanaDashboardKubernetesAPIServer,
	grafanaDashboardKubevelaSystem,
	grafanaDashboardApplicationOverview,
	grafanaDashboardDeploymentOverview,
	grafanaDashboardStatefulSetOverview,
	grafanaDashboardDaemonSetOverview,
	grafanaDashboardKubernetesPod,
]

dashboardComponentNames: [ for comp in dashboardComponents {comp.name}]

comps: [ns, grafanaAccess, grafana, {
	if parameter.storage != _|_ {grafanaStorage}
}]

output: {
	spec: {
		components: [ for comp in comps if comp.name != _|_ {comp}] + dashboardComponents
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
			name: "deploy-topology"
			properties: {
				if parameter.clusters != _|_ {
					clusters: parameter.clusters
				}
				if parameter.clusters == _|_ {
					clusters: ["local"]
				}
				namespace: parameter.namespace
			}
		}, {
			type: "override"
			name: "grafana-core"
			properties: selector: [ns.name, grafanaAccess.name, grafana.name]
		}, {
			type: "override"
			name: "grafana-dashboards"
			properties: selector: dashboardComponentNames
		}]
		workflow: steps: [{
			type: "deploy"
			name: "deploy-ns"
			properties: policies: ["deploy-topology", "grafana-core"]
		}, {
			type: "step-group"
			name: "install-datasources"
			subSteps: [{
				type: "install-kubernetes-api-datasource"
				name: "install-kubernetes-api-datasource"
			}, {
				type: "install-datasource-from-addon"
				name: "install-prometheus-datasource-from-addon"
			}, {
				type: "install-datasource-from-addon"
				name: "install-loki-datasource-from-addon"
				properties: {
					type:      "loki"
					addonName: "addon-loki"
					port:      3100
				}
			}, {
				type: "deploy"
				name: "deploy-dashboards"
				properties: policies: ["deploy-topology", "grafana-dashboards"]
			}]
		}]
	}
}
