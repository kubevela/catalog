package main

grafana: {
	name: "grafana"
	type: "webservice"
	dependsOn: [o11yNamespace.name, grafanaAccess.name]
	properties: {
		image:           parameter["image"]
		imagePullPolicy: parameter["imagePullPolicy"]
		livenessProbe: {
			failureThreshold: 10
			httpGet: {
				path: "/api/health"
				port: 3000
			}
			initialDelaySeconds: 60
			timeoutSeconds:      30
		}
		readinessProbe: httpGet: {
			path: "/api/health"
			port: 3000
		}
		 
		if parameter.storage == _|_ {
			volumeMounts: emptyDir: [{
				name:      "storage-volume"
		    	mountPath: "/var/lib/grafana"
			}]
		}
		if parameter.storage != _|_ {
			volumeMounts: pvc: [{
               name:      "storage-volume"
			   mountPath: "/var/lib/grafana"
				claimName: "grafana-storage"
			}]
		}
		env: [{
			name: "GF_SECURITY_ADMIN_USER"
			valueFrom: secretKeyRef: {
				name: "grafana.\(parameter.grafanaName)"
				key:  "username"
			}
		}, {
			name: "GF_SECURITY_ADMIN_PASSWORD"
			valueFrom: secretKeyRef: {
				name: "grafana.\(parameter.grafanaName)"
				key:  "password"
			}
		}]
		ports: [{
			expose: true
			port:   3000
		}]
		exposeType: parameter.serviceType
	}
	traits: [{
		type: "service-account"
		properties: {
			name:   "grafana"
			create: true
			privileges: [ for p in _clusterPrivileges {
				scope: "cluster"
				{p}
			}]
		}
	}, {
		type: "resource"
		properties: {
			cpu:    parameter["cpu"]
			memory: parameter["memory"]
		}
	}, {
		type: "env"
		properties: env: {
			GF_PATHS_DATA:         "/var/lib/grafana/"
			GF_PATHS_LOGS:         "/var/log/grafana"
			GF_PATHS_PLUGINS:      "/var/lib/grafana/plugins"
			GF_PATHS_PROVISIONING: "/etc/grafana/provisioning"
			GF_INSTALL_PLUGINS:    "marcusolsson-json-datasource"
		}
	}]
}

_clusterPrivileges: [{
	apiGroups: ["cluster.core.oam.dev"]
	resources: ["clustergateways", "clustergateways/proxy"]
	verbs: ["get", "list"]
}, {
	apiGroups: [""]
	resources: ["services"]
	verbs: ["get", "list"]
}, {
	apiGroups: ["*"]
	resources: ["*"]
	verbs: ["get", "list"]
}, {
	nonResourceURLs: ["/"]
	verbs: ["get"]
}]
