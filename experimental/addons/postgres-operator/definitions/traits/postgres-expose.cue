"postgres-expose": {
	alias: ""
	annotations: {}
	attributes: {
		workload: type: "autodetects.core.oam.dev"
	}
	description: "postgres expose trait"
	labels: {}
	type: "trait"
}

template: {
	outputs: service: {
		apiVersion: "v1"
		kind:       "Service"
		metadata: annotations: parameter.annotations
		spec: {
			selector: {
				"application":  "spilo"
				"cluster-name": "postgres"
				"spilo-role":   "master"
				"team":         "acid"
			}
			// compatible with the old way
			if parameter["port"] != _|_ if parameter["ports"] == _|_ {
				ports: [
					for p in parameter.port {
						name:       "port"
						port:       p
						targetPort: p
					},
				]
			}
			if parameter["ports"] != _|_ {
				ports: [ for v in parameter.ports {
					port:       v.port
					targetPort: v.port
					if v.name != _|_ {
						name: v.name
					}
					if v.name == _|_ {
						_name: "port"
						name:  *_name | string
						if v.protocol != "TCP" {
							name: _name
						}
					}
					if v.nodePort != _|_ if parameter.type == "NodePort" {
						nodePort: v.nodePort
					}
					if v.protocol != _|_ {
						protocol: v.protocol
					}
				},
				]
			}
			type: parameter.type
		}
	}
	parameter: {
		// +usage=Deprecated, the old way to specify the exposion ports
		port?: [...int]
		// +usage=Specify portsyou want customer traffic sent to
		ports?: [...{
			// +usage=Number of port to expose on the pod's IP address
			port: int
			// +usage=Name of the port
			name?: string
			// +usage=Protocol for port. Must be UDP, TCP, or SCTP
			protocol: *"TCP" | "UDP" | "SCTP"
			// +usage=exposed node port. Only Valid when exposeType is NodePort
			nodePort?: int
		}]
		// +usage=Specify the annotaions of the exposed service
		annotations: [string]:  string
		matchLabels?: [string]: string
		// +usage=Specify what kind of Service you want. options: "ClusterIP","NodePort","LoadBalancer","ExternalName"
		type: *"ClusterIP" | "NodePort" | "LoadBalancer" | "ExternalName"
	}
}
