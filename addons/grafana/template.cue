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
	if !parameter.install != _|_ {grafanaReaderRoleAndBinding}
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
			type: "topology"
			name: "deploy-hub"
			properties: {
				clusters: ["local"]
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
		}, {
			type: "override"
			name: "grafana-kubernetes-role"
			properties: selector: ["grafana-cluster-role"]
		}]
		workflow: steps: [
			if (parameter.install) {
				{
					type: "deploy"
					name: "Deploy Grafana"
					properties: policies: ["deploy-topology", "grafana-core"]
				}
			},
			if (parameter.install) {
				{
					type: "collect-service-endpoints"
					name: "Get Grafana Endpoint"
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
					name: "Register Grafana Config"
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
			if (!parameter.install) {
				{
					type: "deploy"
					name: "Deploy RoleAndBinding"
					properties: policies: ["grafana-kubernetes-role", "deploy-hub"]
				}
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
			}]
	}
}
