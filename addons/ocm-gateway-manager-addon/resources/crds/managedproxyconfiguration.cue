package main

managedProxyConfigurationCRD: {
	apiVersion: "apiextensions.k8s.io/v1"
	kind:       "CustomResourceDefinition"
	metadata: {
		annotations: "controller-gen.kubebuilder.io/version": "v0.19.0"
		name: "managedproxyconfigurations.proxy.open-cluster-management.io"
	}
	spec: {
		group: "proxy.open-cluster-management.io"
		names: {
			kind:     "ManagedProxyConfiguration"
			listKind: "ManagedProxyConfigurationList"
			plural:   "managedproxyconfigurations"
			singular: "managedproxyconfiguration"
		}
		scope: "Cluster"
		versions: [{
			name: "v1alpha1"
			schema: openAPIV3Schema: {
				description: "ManagedProxyConfiguration is the Schema for the managedproxyconfigurations API"
				properties: {
					apiVersion: {
						description: """
	APIVersion defines the versioned schema of this representation of an object.
	Servers should convert recognized schemas to the latest internal value, and
	may reject unrecognized values.
	More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
	"""
						type: "string"
					}
					kind: {
						description: """
	Kind is a string value representing the REST resource this object represents.
	Servers may infer this from the endpoint the client submits requests to.
	Cannot be updated.
	In CamelCase.
	More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
	"""
						type: "string"
					}
					metadata: type: "object"
					spec: {
						description: "ManagedProxyConfigurationSpec is the prescription of ManagedProxyConfiguration"
						properties: {
							authentication: {
								description: """
	`authentication` defines how the credentials for the authentication
	between proxy servers and proxy agents are signed and mounted.
	"""
								properties: {
									dump: {
										description: "`dump` is where we store the signed certificates from signers."
										properties: secrets: {
											description: "`secrets` is the names of the secrets for saving the signed certificates."
											properties: {
												signingAgentServerSecretName: {
													default: "agent-server"
													description: """
	`signingAgentServerSecretName` is the secret name of the proxy servers to receive
	tunneling handshakes from proxy agents.
	"""
													type: "string"
												}
												signingProxyClientSecretName: {
													default: "proxy-client"
													description: """
	`signingProxyClientSecretName` is the secret name for requesting/streaming over
	the proxy server.
	"""
													type: "string"
												}
												signingProxyServerSecretName: {
													default: "proxy-server"
													description: """
	`signingProxyServerSecretName` the secret name of the proxy server's listening
	certificates for serving proxy requests.
	"""
													type: "string"
												}
											}
											type: "object"
										}
										type: "object"
									}
									signer: {
										description: """
	`signer` defines how we sign server and client certificates for the proxy servers
	and agents.
	"""
										properties: {
											selfSigned: {
												description: "`selfSigned` prescribes the detail of how we self-sign the certificates."
												properties: additionalSANs: {
													description: "`additionalSANs` adds a few custom hostnames or IPs to the signing certificates."
													items: type: "string"
													type: "array"
												}
												type: "object"
											}
											type: {
												default:     "SelfSigned"
												description: "`type` is the supported type of signer. Currently only \"SelfSign\" supported."
												enum: [
													"SelfSigned",
													"Provided",
													"CertManager",
												]
												type: "string"
											}
										}
										type: "object"
									}
								}
								type: "object"
							}
							deploy: {
								description: """
	`deploy` is where we override miscellaneous details for deploying either
	proxy servers or agents.
	"""
								properties: ports: {
									description: "`ports` is the ports for proxying and tunneling."
									properties: {
										adminServer: {
											default:     8095
											description: "`adminServer` is the port for debugging and operating."
											format:      "int32"
											type:        "integer"
										}
										agentServer: {
											default:     8091
											description: "`agentServer` is the listening port of proxy server for serving tunneling handshakes."
											format:      "int32"
											type:        "integer"
										}
										healthServer: {
											default:     8092
											description: "`healthServer` is for probing the healthiness."
											format:      "int32"
											type:        "integer"
										}
										proxyServer: {
											default:     8090
											description: "`proxyServer` is the listening port of proxy server for serving proxy requests."
											format:      "int32"
											type:        "integer"
										}
									}
									type: "object"
								}
								required: ["ports"]
								type: "object"
							}
							proxyAgent: {
								description: "`proxyServer` structurelized the arguments for running proxy agents."
								properties: {
									additionalArgs: {
										description: "`additionalArgs` defines args used in proxy-agent."
										items: type: "string"
										type: "array"
									}
									additionalServiceCAConfigMap: {
										description: """
	`additionalServiceCAConfigMap` is the name of a ConfigMap in the managed cluster
	that contains additional CA certificates for services.
	The ConfigMap should contain a key named "service-ca.crt".
	"""
										type: "string"
									}
									image: {
										description: "`image` is the container image of the proxy agent."
										type:        "string"
									}
									imagePullSecrets: {
										description: "`imagePullSecrets` defines the imagePullSecrets used by proxy-agent"
										items: type: "string"
										type: "array"
									}
									replicas: {
										default:     3
										description: "`replicas` is the replicas of the agents."
										format:      "int32"
										type:        "integer"
									}
								}
								required: ["image"]
								type: "object"
							}
							proxyServer: {
								description: "`proxyServer` structurelized the arguments for running proxy servers."
								properties: {
									additionalArgs: {
										description: "`additionalArgs` adds arbitrary additional command line args to the proxy-server."
										items: type: "string"
										type: "array"
									}
									entrypoint: {
										description: "`entrypoint` defines how will the proxy agents connecting the servers."
										properties: {
											hostname: {
												description: "`hostname` points to a fixed hostname for serving agents' handshakes."
												properties: value: type: "string"
												required: ["value"]
												type: "object"
											}
											loadBalancerService: {
												description: "`loadBalancerService` points to a load-balancer typed service in the hub cluster."
												properties: {
													annotations: {
														description: """
	Annotations is the annoations of the load-balancer service.
	This is for allowing customizing service using vendor-specific extended annotations such as:
	- service.beta.kubernetes.io/alibaba-cloud-loadbalancer-address-type: "intranet"
	- service.beta.kubernetes.io/azure-load-balancer-internal: true
	"""
														items: {
															description: "AnnotationVar list of annotation variables to set in the LB Service."
															properties: {
																key: {
																	description: "Key is the key of annotation"
																	type:        "string"
																}
																value: {
																	description: "Value is the value of annotation"
																	type:        "string"
																}
															}
															required: ["key"]
															type: "object"
														}
														type: "array"
													}
													name: {
														default: "proxy-agent-entrypoint"
														description: """
	`name` is the name of the load-balancer service. And the namespace will align
	to where the proxy-servers are deployed.
	"""
														type: "string"
													}
												}
												type: "object"
											}
											port: {
												default:     8091
												description: "`port` is the target port to access proxy servers"
												format:      "int32"
												minimum:     1
												type:        "integer"
											}
											type: {
												description: """
	`type` is the type of the entrypoint of the proxy servers.
	Currently supports "Hostname", "LoadBalancerService"
	"""
												enum: [
													"Hostname",
													"LoadBalancerService",
													"PortForward",
												]
												type: "string"
											}
										}
										required: ["type"]
										type: "object"
									}
									image: {
										description: "`image` is the container image of the proxy servers."
										type:        "string"
									}
									inClusterServiceName: {
										default: "proxy-entrypoint"
										description: """
	`inClusterServiceName` is the name of the in-cluster service for proxying
	requests inside the hub cluster to the proxy servers.
	"""
										type: "string"
									}
									namespace: {
										default: "open-cluster-management-cluster-proxy"
										description: """
	`namespace` is the namespace where we will deploy the proxy servers and related
	resources.
	"""
										type: "string"
									}
									nodePlacement: {
										description: "NodePlacement defines which Nodes the proxy server are scheduled on. The default is an empty list."
										properties: {
											nodeSelector: {
												additionalProperties: type: "string"
												description: "NodeSelector defines which Nodes the Pods are scheduled on. The default is an empty list."
												type:        "object"
											}
											tolerations: {
												description: """
	Tolerations is attached by pods to tolerate any taint that matches
	the triple <key,value,effect> using the matching operator <operator>.
	The default is an empty list.
	"""
												items: {
													description: """
	The pod this Toleration is attached to tolerates any taint that matches
	the triple <key,value,effect> using the matching operator <operator>.
	"""
													properties: {
														effect: {
															description: """
	Effect indicates the taint effect to match. Empty means match all taint effects.
	When specified, allowed values are NoSchedule, PreferNoSchedule and NoExecute.
	"""
															type: "string"
														}
														key: {
															description: """
	Key is the taint key that the toleration applies to. Empty means match all taint keys.
	If the key is empty, operator must be Exists; this combination means to match all values and all keys.
	"""
															type: "string"
														}
														operator: {
															description: """
	Operator represents a key's relationship to the value.
	Valid operators are Exists and Equal. Defaults to Equal.
	Exists is equivalent to wildcard for value, so that a pod can
	tolerate all taints of a particular category.
	"""
															type: "string"
														}
														tolerationSeconds: {
															description: """
	TolerationSeconds represents the period of time the toleration (which must be
	of effect NoExecute, otherwise this field is ignored) tolerates the taint. By default,
	it is not set, which means tolerate the taint forever (do not evict). Zero and
	negative values will be treated as 0 (evict immediately) by the system.
	"""
															format: "int64"
															type:   "integer"
														}
														value: {
															description: """
	Value is the taint value the toleration matches to.
	If the operator is Exists, the value should be empty, otherwise just a regular string.
	"""
															type: "string"
														}
													}
													type: "object"
												}
												type: "array"
											}
										}
										type: "object"
									}
									replicas: {
										default: 3
										description: """
	`replicas` is the expected replicas of the proxy servers.
	Note that the replicas will also be reflected in the flag `--server-count`
	so that agents can discover all the server instances.
	"""
										format: "int32"
										type:   "integer"
									}
								}
								required: ["image"]
								type: "object"
							}
							userServer: {
								description: """
	`userServer` configures certificate rotation for the user server.
	When configured, certificates will be automatically generated and rotated.
	"""
								properties: additionalSANs: {
									description: """
	`additionalSANs` adds additional hostnames or IPs to the user server certificate.
	Use this to add external hostnames when the user server is exposed outside the cluster.
	The certificate always includes internal service DNS names automatically:
	- cluster-proxy-addon-user
	- cluster-proxy-addon-user.{namespace}
	- cluster-proxy-addon-user.{namespace}.svc
	- cluster-proxy-addon-user.{namespace}.svc.cluster.local
	"""
									items: type: "string"
									type: "array"
								}
								type: "object"
							}
						}
						required: [
							"authentication",
							"proxyAgent",
							"proxyServer",
						]
						type: "object"
					}
					status: {
						description: "ManagedProxyConfigurationStatus defines the observed state of ManagedProxyConfiguration"
						properties: {
							conditions: {
								items: {
									description: "Condition contains details for one aspect of the current state of this API Resource."
									properties: {
										lastTransitionTime: {
											description: """
	lastTransitionTime is the last time the condition transitioned from one status to another.
	This should be when the underlying condition changed.  If that is not known, then using the time when the API field changed is acceptable.
	"""
											format: "date-time"
											type:   "string"
										}
										message: {
											description: """
	message is a human readable message indicating details about the transition.
	This may be an empty string.
	"""
											maxLength: 32768
											type:      "string"
										}
										observedGeneration: {
											description: """
	observedGeneration represents the .metadata.generation that the condition was set based upon.
	For instance, if .metadata.generation is currently 12, but the .status.conditions[x].observedGeneration is 9, the condition is out of date
	with respect to the current state of the instance.
	"""
											format:  "int64"
											minimum: 0
											type:    "integer"
										}
										reason: {
											description: """
	reason contains a programmatic identifier indicating the reason for the condition's last transition.
	Producers of specific condition types may define expected values and meanings for this field,
	and whether the values are considered a guaranteed API.
	The value should be a CamelCase string.
	This field may not be empty.
	"""
											maxLength: 1024
											minLength: 1
											pattern:   "^[A-Za-z]([A-Za-z0-9_,:]*[A-Za-z0-9_])?$"
											type:      "string"
										}
										status: {
											description: "status of the condition, one of True, False, Unknown."
											enum: [
												"True",
												"False",
												"Unknown",
											]
											type: "string"
										}
										type: {
											description: "type of condition in CamelCase or in foo.example.com/CamelCase."
											maxLength:   316
											pattern:     "^([a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*/)?(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])$"
											type:        "string"
										}
									}
									required: [
										"lastTransitionTime",
										"message",
										"reason",
										"status",
										"type",
									]
									type: "object"
								}
								type: "array"
							}
							lastObservedGeneration: {
								format: "int64"
								type:   "integer"
							}
						}
						type: "object"
					}
				}
				type: "object"
			}
			served:  true
			storage: true
			subresources: status: {}
		}]
		status: {
			acceptedNames: {
				kind:   ""
				plural: ""
			}
			conditions: []
			storedVersions: []
		}
	}
}
