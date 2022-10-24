package main

agentServiceAccount: {...}

vectorControllerAgent: {
	name: "vector"
	type: "daemon"
	properties: {
		image:           parameter.vectorImage
		imagePullPolicy: parameter.imagePullPolicy
		labels: {
			"vector.oam.dev/agent": "true"
		}
		env: [{
			name: "VECTOR_SELF_NODE_NAME"
			valueFrom: fieldRef: fieldPath: "spec.nodeName"
		}, {
			name: "VECTOR_SELF_POD_NAME"
			valueFrom: fieldRef: fieldPath: "metadata.name"
		}, {
			name: "VECTOR_SELF_POD_NAMESPACE"
			valueFrom: fieldRef: fieldPath: "metadata.namespace"
		}, {
			name:  "PROCFS_ROOT"
			value: "/host/proc"
		}, {
			name:  "SYSFS_ROOT"
			value: "/host/sys"
		}]
		volumeMounts: {
			configMap: [{
				name:      "config"
				mountPath: "/etc/config"
				cmName:    "vector"
			}]
			hostPath: [{
				name:      "data"
				path:      "/var/lib/vector"
				mountPath: "/vector-data-dir"
			}, {
				name:      "var-log"
				path:      "/var/log/"
				mountPath: "/var/log/"
				readOnly:  true
			}, {
				name:      "var-lib"
				path:      "/var/lib/"
				mountPath: "/var/lib/"
				readOnly:  true
			}, {
				name:      "procfs"
				path:      "/proc"
				mountPath: "/host/proc"
				readOnly:  true
			}, {
				name:      "sysfs"
				path:      "/sys"
				mountPath: "/host/sys"
				readOnly:  true
			}]
		}
	}
	traits: [{
		type: "command"
		properties: args: ["--config-dir", "/etc/config/", "-w"]
	}] + [{
		agentServiceAccount
		properties: name: "vector"
	}]
}

vectorControllerAgentConfig: {
	name: "vector-config"
	type: "k8s-objects"
	properties: objects: [{
		apiVersion: "v1"
		kind:       "ConfigMap"
		metadata: name: "vector"
		data: {
			"agent.yaml": #"""
				data_dir: /vector-data-dir
				sources:
				  kubernetes-logs:
				    type: kubernetes_logs
				    extra_label_selector: "kube-event-logger=true"
				sinks:
				  loki:
				    type: loki
				    inputs:
				      - kubernetes-logs
				    endpoint: http://loki:3100
				    compression: none
				    labels:
				      agent: vector
				      stream: "{{ stream }}"
				      forward: daemon
				      filename: "{{ file }}"
				      pod: "{{ kubernetes.pod_name }}"
				      namespace: "{{ kubernetes.pod_namespace }}"
				      container: "{{ kubernetes.container_name }}"
				    request:
				       concurrency: 10
				    encoding:
				      codec: json
				"""#
		}
	}]
}

vectorCRDComponent: {
	name: "vector-crd"
	type: "k8s-objects"
	properties: objects: [
		vectorControllerCRD,
	]
}

vectorControllerServiceAccount: {
	type: "service-account"
	properties: {
		name:   "vector-controller"
		create: true
		privileges: [{
			scope: "cluster"
			apiGroups: ["vector.oam.dev"]
			resources: ["configs"]
			verbs: ["*"]
		}, {
			scope: "cluster"
			apiGroups: [""]
			resources: ["configmaps"]
			verbs: ["*"]
		}]
	}
}

vectorController: {
	name: "vector-controller"
	type: "webservice"
	properties: {
		image:           parameter.vectorControllerImage
		imagePullPolicy: parameter.imagePullPolicy
	}
	traits: [vectorControllerServiceAccount]
}

vectorControllerCRD: {
	apiVersion: "apiextensions.k8s.io/v1"
	kind:       "CustomResourceDefinition"
	metadata: {
		annotations: "controller-gen.kubebuilder.io/version": "v0.8.0"
		creationTimestamp: null
		name:              "configs.vector.oam.dev"
	}
	spec: {
		group: "vector.oam.dev"
		names: {
			kind:     "Config"
			listKind: "ConfigList"
			plural:   "configs"
			singular: "config"
		}
		scope: "Namespaced"
		versions: [{
			name: "v1alpha1"
			schema: openAPIV3Schema: {
				description: "Config is the Schema for the configs API"
				properties: {
					apiVersion: {
						description: "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources"

						type: "string"
					}
					kind: {
						description: "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds"

						type: "string"
					}
					metadata: type: "object"
					spec: {
						description: "ConfigSpec defines the desired state of Config"
						properties: {
							role: type: "string"
							targetConfigMap: {
								properties: {
									name: type:      "string"
									namespace: type: "string"
								}
								required: [
									"name",
								]
								type: "object"
							}
							vectorConfig: {
								type:                                   "object"
								"x-kubernetes-preserve-unknown-fields": true
							}
						}
						required: [
							"role",
							"vectorConfig",
						]
						type: "object"
					}
					status: {
						description: "ConfigStatus defines the observed state of Config"
						properties: message: type: "string"
						type: "object"
					}
				}
				type: "object"
			}
			served:  true
			storage: true
			subresources: status: {}
		}]
	}
	status: {
		acceptedNames: {
			kind:   ""
			plural: ""
		}
		conditions: []
		storedVersions: []
	}
}

eventLogger: {
	name: "event-log"
	type: "webservice"
	properties: {
		image: "maxrocketinternet/k8s-event-logger:1.7"
		labels: "kube-event-logger": "true"
	}
	traits: [eventLogServiceAccount]
}

eventLogServiceAccount: {
	type: "service-account"
	properties: {
		name:   "log-event"
		create: true
		privileges: [{
			scope: "cluster"
			apiGroups: [""]
			resources: ["events"]
			verbs: ["*"]
		}]
	}
}
