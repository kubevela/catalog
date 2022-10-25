package main

postDeploySteps: [{
	type: "collect-service-endpoints"
	name: "get-prometheus-endpoint"
	properties: {
		name:      const.name
		namespace: "vela-system"
		if parameter.thanos {
			components: [thanosQuery.name]
		}
		if !parameter.thanos {
			components: [prometheusServer.name]
		}
		portName: "http"
		outer:    parameter.serviceType != "ClusterIP"
	}
	outputs: [{
		name:      "url"
		valueFrom: "value.url"
	}]
}, {
	type: "create-config"
	name: "prometheus-server-register"
	properties: {
		name:     "prometheus-vela"
		template: "prometheus-server"
		config: {}
	}
	inputs: [{
		from:         "url"
		parameterKey: "config.url"
	}]
}]
