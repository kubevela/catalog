output: {
	type: "helm"
	properties: {
		repoType:        "helm"
		url:             "https://pyroscope-io.github.io/helm-chart"
		chart:           "pyroscope"
		version:         "0.2.79"
		targetNamespace: "vela-system"
		releaseName:     "pyroscope"
		values: {
			image: {
				repository: parameter["image.repository"]
				tag:        parameter["image.tag"]
				pullPolicy: parameter["image.pullPolicy"]
			}
			imagePullSecrets: parameter["imagePullSecrets"]
			ingress: {
				enabled: parameter["ingress.enabled"]
				hosts:   parameter["ingress.hosts"]
				rules:   parameter["ingress.rules"]
				tls:     parameter["ingress.tls"]
			}
			persistence: {
				accessModes: parameter["persistence.accessModes"]
				enabled:     parameter["persistence.enabled"]
				finalizers:  parameter["persistence.finalizers"]
				size:        parameter["persistence.size"]
			}
			pyroscopeConfigs: parameter["pyroscopeConfigs"]
			rbac: {
				create: parameter["rbac.create"]
				clusterRoleBinding: {
					name: parameter["rbac.clusterRoleBinding.name"]
				}
				clusterRole: {
					name:       parameter["rbac.clusterRole.name"]
					extraRules: parameter["rbac.clusterRole.extraRules"]
				}
			}
			service: {
				port: parameter["service.port"]
				type: parameter["serviceType"]
			}
			serviceAccount: {
				create: parameter["serviceAccount.create"]
				name:   parameter["serviceAccount.name"]
			}
			{
				"pyroscopeConfigs": {
					"log-level": "debug"
					"scrape-configs": [
						{
							"job-name": "kubernetes-pods"
							"enabled-profiles": [
								"cpu",
								"mem",
							]
							"kubernetes-sd-configs": [
								{
									"role": "pod"
								},
							]
							"relabel-configs": [
								{
									"source-labels": [
										"__meta_kubernetes_pod_annotation_pyroscope_io_scrape",
									]
									"action": "keep"
									"regex":  true
								},
								{
									"source-labels": [
										"__meta_kubernetes_pod_annotation_pyroscope_io_application_name",
									]
									"action":       "replace"
									"target-label": "__name__"
								},
								{
									"source-labels": [
										"__meta_kubernetes_pod_annotation_pyroscope_io_scheme",
									]
									"action":       "replace"
									"regex":        "(https?)"
									"target-label": "__scheme__"
								},
								{
									"source-labels": [
										"__address__",
										"__meta_kubernetes_pod_annotation_pyroscope_io_port",
									]
									"action":       "replace"
									"regex":        "([^:]+)(?::\\d+)?;(\\d+)"
									"replacement":  "$1:$2"
									"target-label": "__address__"
								},
								{
									"action": "labelmap"
									"regex":  "__meta_kubernetes_pod_label_(.+)"
								},
								{
									"source-labels": [
										"__meta_kubernetes_namespace",
									]
									"action":       "replace"
									"target-label": "kubernetes_namespace"
								},
								{
									"source-labels": [
										"__meta_kubernetes_pod_name",
									]
									"action":       "replace"
									"target-label": "kubernetes_pod_name"
								},
								{
									"source-labels": [
										"__meta_kubernetes_pod_phase",
									]
									"regex":  "Pending|Succeeded|Failed|Completed"
									"action": "drop"
								},
								{
									"action":      "labelmap"
									"regex":       "__meta_kubernetes_pod_annotation_pyroscope_io_profile_(.+)"
									"replacement": "__profile_$1"
								},
							]
						},
					]
				}
			}
		}
	}
}
