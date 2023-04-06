package main

loki: {
	name: "loki"
	type: "webservice"
	dependsOn: [o11yNamespace.name]
	properties: {
		image:           parameter.image
		imagePullPolicy: parameter.imagePullPolicy
		volumeMounts: {
			configMap: [{
				name:      "config"
				mountPath: "/etc/loki"
				cmName:    "loki"
			}]
			emptyDir: [{
				name:      "tmp"
				mountPath: "/tmp"
			}] + [ if parameter.storage == _|_ {
				name:      "storage"
				mountPath: "/data"
			}]
			if parameter.storage != _|_ {
				pvc: [{
					name:      "storage"
					mountPath: "/data"
					claimName: "loki-storage"
				}]
			}
		}
		_probe: {
			httpGet: {
				path: "/ready"
				port: 3100
			}
		}
		livenessProbe:  _probe
		readinessProbe: _probe
		ports: [{
			name:   "http"
			port:   3100
			expose: true
		}]
		exposeType: parameter.serviceType
	}
	traits: [{
		type: "command"
		properties: args: ["-config.file=/etc/loki/loki.yaml"]
	}]
}

lokiSteps: *[] | [...{...}]
if !parameter.agentOnly {
	lokiSteps: [{
		type: "deploy"
		name: "deploy-loki"
		properties: policies: ["topology-centralized", "loki-components"]
	}, {
		type: "collect-service-endpoints"
		name: "get-loki-endpoint"
		properties: {
			name:      const.name
			namespace: "vela-system"
			components: [loki.name]
			portName: "http"
			outer:    parameter.serviceType != "ClusterIP"
		}
		outputs: [{
			name:      "host"
			valueFrom: "value.endpoint.host"
		}, {
			name:      "port"
			valueFrom: "value.endpoint.port"
		}, {
			name:      "url"
			valueFrom: "value.url"
		}]
	}, {
		type: "create-config"
		name: "loki-server-register"
		properties: {
			name:     "loki-vela"
			template: "loki"
			config: {}
		}
		inputs: [{
			from:         "url"
			parameterKey: "config.url"
		}]
	}, {
		type: "export-service"
		name: "export-service"
		properties: {
			name:      "loki"
			namespace: parameter.namespace
			topology:  "topology-distributed-exclude-local"
			port:      3100
		}
		inputs: [{
			from:         "host"
			parameterKey: "ip"
		}, {
			from:         "port"
			parameterKey: "targetPort"
		}]
	}]
}

lokiURL: *"http://loki:3100/" | string
if parameter.lokiURL != _|_ {
	lokiURL: parameter.lokiURL
}
