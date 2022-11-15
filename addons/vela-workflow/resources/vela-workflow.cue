package main

workflow: {
	name: const.name
	type: "k8s-objects"
	properties: objects: [{
		apiVersion: "apps/v1"
		kind:       "Deployment"
		metadata: {
			labels: {
				"app.kubernetes.io/instance": const.name
				"app.kubernetes.io/name":     const.name
				"app.kubernetes.io/version":  parameter.version
				"controller.oam.dev/name":    const.name
			}
			name:        const.name
			"namespace": const.namespace
		}
		"spec": {
			"replicas": 1
			selector: {
				matchLabels: {
					"app.kubernetes.io/instance": const.name
					"app.kubernetes.io/name":     const.name
				}
			}
			template: {
				metadata: {
					annotations: {
						"prometheus.io/path":   "/metrics"
						"prometheus.io/port":   "8080"
						"prometheus.io/scrape": "true"
					}
					labels: {
						"app.kubernetes.io/instance": const.name
						"app.kubernetes.io/name":     const.name
					}
				}
				spec: {
					containers: [
						{
							"args": [
								"--metrics-bind-address=:8080",
								"--leader-elect",
								"--health-probe-bind-address=:9440",
								"--concurrent-reconciles=\(parameter.concurrentReconciles)",
								"--kube-api-qps=\(parameter.kubeQPS)",
								"--kube-api-burst=\(parameter.kubeBurst)",
								"--max-workflow-wait-backoff-time=\(parameter.maxWorkflowWaitBackoffTime)",
								"--max-workflow-failed-backoff-time=\(parameter.maxWorkflowFailedBackoffTime)",
								"--max-workflow-step-error-retry-times=\(parameter.maxWorkflowStepErrorRetryTimes)",
								"--feature-gates=EnableSuspendOnFailure=false",
								"--feature-gates=EnableBackupWorkflowRecord=false",
							]
							"image":           "\(parameter.image):v\(parameter.version)"
							"imagePullPolicy": parameter.imagePullPolicy
							"name":            const.name
							"resources": {
								"limits": {
									"cpu":    parameter.resources.limits.cpu
									"memory": parameter.resources.limits.memory
								}
								"requests": {
									"cpu":    parameter.resources.requests.cpu
									"memory": parameter.resources.requests.memory
								}
							}
						},
					]
					"securityContext": {}
					"serviceAccount":     const.name
					"serviceAccountName": const.name
				}
			}
		}
	}]
}
