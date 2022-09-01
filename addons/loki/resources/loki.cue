package main

loki: {
    name: "loki"
    type: "webservice"
    properties: {
        image: parameter.image
        imagePullPolicy: parameter.imagePullPolicy
        volumeMounts: {
            configMap: [{
                name: "config"
                mountPath: "/etc/loki"
                cmName: "loki"
            }]
            emptyDir: [{
                name: "tmp"
				mountPath: "/tmp"
            }] + [if parameter.storage == _|_ {
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
        livenessProbe: _probe
        readinessProbe: _probe
    }
    traits: [{
        type: "command"
		properties: args: ["-config.file=/etc/loki/loki.yaml"]
    }, {
		type: "expose"
		properties: {
			port: [3100, 7946]
			type: parameter.serviceType
		}
	}]
}