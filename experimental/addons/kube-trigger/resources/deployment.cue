package main

_targetNamespace: string

deployment: {
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata: {
		name:      "kube-trigger-manager"
		namespace: _targetNamespace
		labels: "control-plane": "kube-trigger-manager"
	}
	spec: {
		selector: matchLabels: "control-plane": "kube-trigger-manager"
		replicas: 1
		template: {
			metadata: {
				annotations: "kubectl.kubernetes.io/default-container": "manager"
				labels: "control-plane":                                "kube-trigger-manager"
			}
			spec: {
				securityContext: {
					runAsNonRoot: true
					seccompProfile: type: "RuntimeDefault"
				}
				containers: [{
					command: [
						"/manager",
					]
					args: [
						"--leader-elect",
						if parameter.createDefaultInstance {
							"--create-default-instance"
						},
						if parameter.createDefaultInstance {
							"--service-use-default-instance"
						},
					]
					// Use latest because kube-trigger is now experimental, just to keep up changes.
					// Pin down a certain version once a stable version is released.
					image:           "oamdev/kube-trigger-manager:latest"
					imagePullPolicy: "Always"
					name:            "manager"
					securityContext: {
						allowPrivilegeEscalation: false
						capabilities: drop: [
							"ALL",
						]
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
					resources: {
						limits: {
							cpu:    "500m"
							memory: "128Mi"
						}
						requests: {
							cpu:    "10m"
							memory: "64Mi"
						}
					}
				}]
				serviceAccountName:            "kube-trigger-manager"
				terminationGracePeriodSeconds: 10
			}
		}
	}
}
