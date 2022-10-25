package main

kubeStateMetrics: {
	name: "kube-state-metrics"
	type: "webservice"
	dependsOn: [o11yNamespace.name]
	properties: {
		image:           parameter["image"]
		imagePullPolicy: parameter["imagePullPolicy"]
		livenessProbe: {
			httpGet: {
				path: "/healthz"
				port: 8080
			}
			initialDelaySeconds: 5
			timeoutSeconds:      5
		}
		readinessProbe: {
			httpGet: {
				path: "/"
				port: 8080
			}
			initialDelaySeconds: 5
			timeoutSeconds:      5
		}
	}
	traits: [{
		type: "command"
		properties: args: [
			"--metric-labels-allowlist=deployments=[app.oam.dev/name,app.oam.dev/namespace]",
		]
	}, {
		type: "service-account"
		properties: {
			name:   "kube-state-metrics"
			create: true
			privileges: [ for p in _clusterPrivileges {
				scope: "cluster"
				{p}
			}]
		}
	}, {
		type: "expose"
		properties: {
			port: [8080]
			annotations: {
				"prometheus.io/port":   "8080"
				"prometheus.io/scrape": "true"
				"prometheus.io/path":   "/metrics"
			}
		}
	}, {
		type: "resource"
		properties: {
			cpu:    parameter["cpu"]
			memory: parameter["memory"]
		}
	}]
}

_clusterPrivileges: [{
	apiGroups: ["certificates.k8s.io"]
	resources: ["certificatesigningrequests"]
	verbs: ["list", "watch"]
}, {
	apiGroups: [""]
	resources: ["configmaps", "endpoints", "limitranges", "namespaces", "nodes", "persistentvolumeclaims", "persistentvolumes", "pods", "replicationcontrollers", "resourcequotas", "secrets", "services"]
	verbs: ["list", "watch"]
}, {
	apiGroups: ["batch"]
	resources: ["cronjobs", "jobs"]
	verbs: ["list", "watch"]
}, {
	apiGroups: ["extensions", "apps"]
	resources: ["daemonsets", "deployments", "replicasets"]
	verbs: ["list", "watch"]
}, {
	apiGroups: ["autoscaling"]
	resources: ["horizontalpodautoscalers"]
	verbs: ["list", "watch"]
}, {
	apiGroups: ["extensions", "networking.k8s.io"]
	resources: ["ingresses"]
	verbs: ["list", "watch"]
}, {
	apiGroups: ["admissionregistration.k8s.io"]
	resources: ["mutatingwebhookconfigurations", "validatingwebhookconfigurations"]
	verbs: ["list", "watch"]
}, {
	apiGroups: ["networking.k8s.io"]
	resources: ["networkpolicies"]
	verbs: ["list", "watch"]
}, {
	apiGroups: ["policy"]
	resources: ["poddisruptionbudgets"]
	verbs: ["list", "watch"]
}, {
	apiGroups: ["apps"]
	resources: ["statefulsets"]
	verbs: ["list", "watch"]
}, {
	apiGroups: ["storage.k8s.io"]
	resources: ["storageclasses", "volumeattachments"]
	verbs: ["list", "watch"]
}, {
	apiGroups: ["coordination.k8s.io"]
	resources: ["leases"]
	verbs: ["list", "watch"]
}]
