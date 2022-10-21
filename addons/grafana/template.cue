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

comps: [ns, grafanaAccount, grafana, {
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
			properties: selector: [ns.name, grafanaAccount.name, grafana.name]
		}, {
			type: "override"
			name: "grafana-dashboards"
			properties: selector: dashboardComponentNames
		}]
		workflow: steps: [
			if (parameter.install) {
				{
					type: "deploy"
					name: "deploy-grafana"
					properties: policies: ["deploy-topology", "grafana-core"]
				}
			},
			if (parameter.install) {
				{
					type: "collect-service-endpoints"
					name: "get-grafana-endpoint"
					properties: {
						name:      const.name
						namespace: "vela-system"
						components: [grafana.name]
						portName: "port-3000"
						outer:    parameter.serviceType != "ClusterIP"
					}
					outputs: [{
						name:      "url"
						valueFrom: "value.url"
					}]
				}
			},
			if (parameter.install) {
				{
					type: "create-config"
					name: "grafana-server-register"
					properties: {
						name:     parameter.grafanaName
						template: "grafana"
						config: {
							auth: {
								username: parameter.adminUser
								password: parameter.adminPassword
							}
						}
					}
					inputs: [
						{
							from:         "url"
							parameterKey: "config.endpoint"
						},
					]
				}
			},
			{
				type: "step-group"
				name: "install-datasources"
				subSteps: [
					{
						type: "install-kubernetes-api-datasource"
						name: "install-kubernetes-api-datasource"
						properties: {
							grafana: parameter.grafanaName
						}
					}, {
						type: "install-datasource-from-config"
						name: "install-prometheus-datasource-from-config"
						properties: {
							type:    "prometheus-server"
							grafana: parameter.grafanaName
						}
					}, {
						type: "install-datasource-from-config"
						name: "install-loki-datasource-from-config"
						properties: {
							type:    "loki"
							grafana: parameter.grafanaName
						}
					}, {
						type: "deploy"
						name: "deploy-dashboards"
						properties: policies: ["deploy-topology", "grafana-dashboards"]
					},
				]
			}]
	}
}
