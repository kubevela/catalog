package main

import "list"

grafanaDashboardComponents: [
	grafanaDashboardKubernetesAPIServer,
	grafanaDashboardKubevelaSystem,
	grafanaDashboardApplicationOverview,
	grafanaDashboardDeploymentOverview,
	grafanaDashboardStatefulSetOverview,
	grafanaDashboardDaemonSetOverview,
	grafanaDashboardKubernetesEvents,
	grafanaDashboardKubernetesPod,
]

output: {
	spec: {
		components: list.Concat([[
				o11yNamespace,
				grafanaAccess,
				grafana,
				if parameter.storage != _|_ {grafanaStorage},
				if !parameter.install {grafanaReaderRoleAndBinding},
		], grafanaDashboardComponents])
		policies: list.Concat([commonPolicies, [{
			type: "override"
			name: "grafana-core"
			properties: selector: [o11yNamespace.name, grafanaAccess.name, grafana.name]
		}, {
			type: "override"
			name: "grafana-dashboards"
			properties: selector: [ for comp in grafanaDashboardComponents {comp.name}]
		}, {
			type: "override"
			name: "grafana-kubernetes-role"
			properties: selector: [grafanaReaderRoleAndBinding.name]
		}]])
		workflow: steps: list.Concat([[
					if parameter.install {
				type: "deploy"
				name: "Deploy Grafana"
				properties: policies: ["deploy-topology", "grafana-core"]
			},
			{
				type: "step-group"
				name: "Install Datasources"
				subSteps: [
					{
						type: "install-kubernetes-api-datasource"
						name: "Install Kubernetes API Datasource"
						properties: {
							grafana: parameter.grafanaName
							if parameter.kubeEndpoint != _|_ {
								endpoint: parameter.kubeEndpoint
							}
						}
					}, {
						type: "install-datasource-from-config"
						name: "Install Prometheus Datasources"
						properties: {
							type:    "prometheus-server"
							grafana: parameter.grafanaName
						}
					}, {
						type: "install-datasource-from-config"
						name: "Install Loki Datasources"
						properties: {
							type:    "loki"
							grafana: parameter.grafanaName
						}
					},
				]
			},
			{
				type: "deploy"
				name: "Install Dashboards"
				properties: policies: ["deploy-topology", "grafana-dashboards"]
			},
		], postDeploySteps])
	}
}
