package main

deployment: {
	type: "k8s-objects"
	name: "kube-trigger-deployment"
	properties: objects: [{
		apiVersion: "apps/v1"
		kind:       "Deployment"
		metadata: {
			name:      const.name
			namespace: const.namespace
			labels: {
				"control-plane": const.name
			}
		}
		spec: {
			selector: {
				matchLabels: {
					"control-plane": const.name
				}
			}
			replicas: 1
			template: {
				metadata: {
					annotations: {
						"kubectl.kubernetes.io/default-container": const.name
					}
					labels: {
						"control-plane": const.name
					}
				}
				spec: {
					securityContext: {
						runAsNonRoot: true
						seccompProfile: {
							type: "RuntimeDefault"
						}
					}
					containers: [
						{
							command: [
								"/manager",
							]
							args: [
								"--leader-elect",
							]
							image:           "\(parameter.image):\(parameter.version)"
							imagePullPolicy: parameter.imagePullPolicy
							name:            const.name
							resources: {
								limits: {
									cpu:    parameter.resources.limits.cpu
									memory: parameter.resources.limits.memory
								}
								requests: {
									cpu:    parameter.resources.requests.cpu
									memory: parameter.resources.requests.memory
								}
							}
							securityContext: {
								allowPrivilegeEscalation: false
								capabilities: {
									drop: [
										"ALL",
									]
								}
							}
							livenessProbe: {
								httpGet: {
									path: "/healthz"
									port: 8081
								}
								initialDelaySeconds: 15
								periodSeconds:       20
							}
							readinessProbe: {
								httpGet: {
									path: "/readyz"
									port: 8081
								}
								initialDelaySeconds: 5
								periodSeconds:       10
							}
						},
					]
					serviceAccountName:            const.name
					terminationGracePeriodSeconds: 10
				}
			}
		}
	}]
}
