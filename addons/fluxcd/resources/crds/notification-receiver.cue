package main

notificationReceiverCRD: {
	apiVersion: "apiextensions.k8s.io/v1"
	kind:       "CustomResourceDefinition"
	metadata: {
		annotations: "controller-gen.kubebuilder.io/version": "v0.16.1"
		labels: {
			"app.kubernetes.io/component": "notification-controller"
			"app.kubernetes.io/instance":  "flux-system"
			"app.kubernetes.io/part-of":   "flux"
			"app.kubernetes.io/version":   "v2.4.0"
		}
		name: "receivers.notification.toolkit.fluxcd.io"
	}
	spec: {
		group: "notification.toolkit.fluxcd.io"
		names: {
			kind:     "Receiver"
			listKind: "ReceiverList"
			plural:   "receivers"
			singular: "receiver"
		}
		scope: "Namespaced"
		versions: [{
			additionalPrinterColumns: [{
				jsonPath: ".metadata.creationTimestamp"
				name:     "Age"
				type:     "date"
			}, {
				jsonPath: ".status.conditions[?(@.type==\"Ready\")].status"
				name:     "Ready"
				type:     "string"
			}, {
				jsonPath: ".status.conditions[?(@.type==\"Ready\")].message"
				name:     "Status"
				type:     "string"
			}]
			name: "v1"
			schema: openAPIV3Schema: {
				description: "Receiver is the Schema for the receivers API."
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
						description: "ReceiverSpec defines the desired state of the Receiver."
						properties: {
							events: {
								description: """
											Events specifies the list of event types to handle,
											e.g. 'push' for GitHub or 'Push Hook' for GitLab.
											"""
								items: type: "string"
								type: "array"
							}
							interval: {
								default:     "10m"
								description: "Interval at which to reconcile the Receiver with its Secret references."
								pattern:     "^([0-9]+(\\.[0-9]+)?(ms|s|m|h))+$"
								type:        "string"
							}
							resources: {
								description: "A list of resources to be notified about changes."
								items: {
									description: """
												CrossNamespaceObjectReference contains enough information to let you locate the
												typed referenced object at cluster level
												"""
									properties: {
										apiVersion: {
											description: "API version of the referent"
											type:        "string"
										}
										kind: {
											description: "Kind of the referent"
											enum: ["Bucket", "GitRepository", "Kustomization", "HelmRelease", "HelmChart", "HelmRepository", "ImageRepository", "ImagePolicy", "ImageUpdateAutomation", "OCIRepository"]
											type: "string"
										}
										matchLabels: {
											additionalProperties: type: "string"
											description: """
														MatchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels
														map is equivalent to an element of matchExpressions, whose key field is "key", the
														operator is "In", and the values array contains only "value". The requirements are ANDed.
														MatchLabels requires the name to be set to `*`.
														"""
											type: "object"
										}
										name: {
											description: """
														Name of the referent
														If multiple resources are targeted `*` may be set.
														"""
											maxLength: 53
											minLength: 1
											type:      "string"
										}
										namespace: {
											description: "Namespace of the referent"
											maxLength:   53
											minLength:   1
											type:        "string"
										}
									}
									required: ["kind", "name"]
									type: "object"
								}
								type: "array"
							}
							secretRef: {
								description: """
											SecretRef specifies the Secret containing the token used
											to validate the payload authenticity.
											"""
								properties: name: {
									description: "Name of the referent."
									type:        "string"
								}
								required: ["name"]
								type: "object"
							}
							suspend: {
								description: """
											Suspend tells the controller to suspend subsequent
											events handling for this receiver.
											"""
								type: "boolean"
							}
							type: {
								description: """
											Type of webhook sender, used to determine
											the validation procedure and payload deserialization.
											"""
								enum: ["generic", "generic-hmac", "github", "gitlab", "bitbucket", "harbor", "dockerhub", "quay", "gcr", "nexus", "acr", "cdevents"]
								type: "string"
							}
						}
						required: ["resources", "secretRef", "type"]
						type: "object"
					}
					status: {
						default: observedGeneration: -1
						description: "ReceiverStatus defines the observed state of the Receiver."
						properties: {
							conditions: {
								description: "Conditions holds the conditions for the Receiver."
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
											enum: ["True", "False", "Unknown"]
											type: "string"
										}
										type: {
											description: "type of condition in CamelCase or in foo.example.com/CamelCase."
											maxLength:   316
											pattern:     "^([a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*/)?(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])$"
											type:        "string"
										}
									}
									required: ["lastTransitionTime", "message", "reason", "status", "type"]
									type: "object"
								}
								type: "array"
							}
							lastHandledReconcileAt: {
								description: """
											LastHandledReconcileAt holds the value of the most recent
											reconcile request value, so a change of the annotation value
											can be detected.
											"""
								type: "string"
							}
							observedGeneration: {
								description: "ObservedGeneration is the last observed generation of the Receiver object."
								format:      "int64"
								type:        "integer"
							}
							webhookPath: {
								description: """
											WebhookPath is the generated incoming webhook address in the format
											of '/hook/sha256sum(token+name+namespace)'.
											"""
								type: "string"
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
		}, {
			additionalPrinterColumns: [{
				jsonPath: ".metadata.creationTimestamp"
				name:     "Age"
				type:     "date"
			}, {
				jsonPath: ".status.conditions[?(@.type==\"Ready\")].status"
				name:     "Ready"
				type:     "string"
			}, {
				jsonPath: ".status.conditions[?(@.type==\"Ready\")].message"
				name:     "Status"
				type:     "string"
			}]
			deprecated:         true
			deprecationWarning: "v1beta1 Receiver is deprecated, upgrade to v1"
			name:               "v1beta1"
			schema: openAPIV3Schema: {
				description: "Receiver is the Schema for the receivers API"
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
						description: "ReceiverSpec defines the desired state of Receiver"
						properties: {
							events: {
								description: """
											A list of events to handle,
											e.g. 'push' for GitHub or 'Push Hook' for GitLab.
											"""
								items: type: "string"
								type: "array"
							}
							resources: {
								description: "A list of resources to be notified about changes."
								items: {
									description: """
												CrossNamespaceObjectReference contains enough information to let you locate the
												typed referenced object at cluster level
												"""
									properties: {
										apiVersion: {
											description: "API version of the referent"
											type:        "string"
										}
										kind: {
											description: "Kind of the referent"
											enum: ["Bucket", "GitRepository", "Kustomization", "HelmRelease", "HelmChart", "HelmRepository", "ImageRepository", "ImagePolicy", "ImageUpdateAutomation", "OCIRepository"]
											type: "string"
										}
										matchLabels: {
											additionalProperties: type: "string"
											description: """
														MatchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels
														map is equivalent to an element of matchExpressions, whose key field is "key", the
														operator is "In", and the values array contains only "value". The requirements are ANDed.
														"""
											type: "object"
										}
										name: {
											description: "Name of the referent"
											maxLength:   53
											minLength:   1
											type:        "string"
										}
										namespace: {
											description: "Namespace of the referent"
											maxLength:   53
											minLength:   1
											type:        "string"
										}
									}
									required: ["kind", "name"]
									type: "object"
								}
								type: "array"
							}
							secretRef: {
								description: """
											Secret reference containing the token used
											to validate the payload authenticity
											"""
								properties: name: {
									description: "Name of the referent."
									type:        "string"
								}
								required: ["name"]
								type: "object"
							}
							suspend: {
								description: """
											This flag tells the controller to suspend subsequent events handling.
											Defaults to false.
											"""
								type: "boolean"
							}
							type: {
								description: """
											Type of webhook sender, used to determine
											the validation procedure and payload deserialization.
											"""
								enum: ["generic", "generic-hmac", "github", "gitlab", "bitbucket", "harbor", "dockerhub", "quay", "gcr", "nexus", "acr"]
								type: "string"
							}
						}
						required: ["resources", "secretRef", "type"]
						type: "object"
					}
					status: {
						default: observedGeneration: -1
						description: "ReceiverStatus defines the observed state of Receiver"
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
											enum: ["True", "False", "Unknown"]
											type: "string"
										}
										type: {
											description: "type of condition in CamelCase or in foo.example.com/CamelCase."
											maxLength:   316
											pattern:     "^([a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*/)?(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])$"
											type:        "string"
										}
									}
									required: ["lastTransitionTime", "message", "reason", "status", "type"]
									type: "object"
								}
								type: "array"
							}
							observedGeneration: {
								description: "ObservedGeneration is the last observed generation."
								format:      "int64"
								type:        "integer"
							}
							url: {
								description: """
											Generated webhook URL in the format
											of '/hook/sha256sum(token+name+namespace)'.
											"""
								type: "string"
							}
						}
						type: "object"
					}
				}
				type: "object"
			}
			served:  true
			storage: false
			subresources: status: {}
		}, {
			additionalPrinterColumns: [{
				jsonPath: ".metadata.creationTimestamp"
				name:     "Age"
				type:     "date"
			}, {
				jsonPath: ".status.conditions[?(@.type==\"Ready\")].status"
				name:     "Ready"
				type:     "string"
			}, {
				jsonPath: ".status.conditions[?(@.type==\"Ready\")].message"
				name:     "Status"
				type:     "string"
			}]
			deprecated:         true
			deprecationWarning: "v1beta2 Receiver is deprecated, upgrade to v1"
			name:               "v1beta2"
			schema: openAPIV3Schema: {
				description: "Receiver is the Schema for the receivers API."
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
						description: "ReceiverSpec defines the desired state of the Receiver."
						properties: {
							events: {
								description: """
											Events specifies the list of event types to handle,
											e.g. 'push' for GitHub or 'Push Hook' for GitLab.
											"""
								items: type: "string"
								type: "array"
							}
							interval: {
								description: "Interval at which to reconcile the Receiver with its Secret references."
								pattern:     "^([0-9]+(\\.[0-9]+)?(ms|s|m|h))+$"
								type:        "string"
							}
							resources: {
								description: "A list of resources to be notified about changes."
								items: {
									description: """
												CrossNamespaceObjectReference contains enough information to let you locate the
												typed referenced object at cluster level
												"""
									properties: {
										apiVersion: {
											description: "API version of the referent"
											type:        "string"
										}
										kind: {
											description: "Kind of the referent"
											enum: ["Bucket", "GitRepository", "Kustomization", "HelmRelease", "HelmChart", "HelmRepository", "ImageRepository", "ImagePolicy", "ImageUpdateAutomation", "OCIRepository"]
											type: "string"
										}
										matchLabels: {
											additionalProperties: type: "string"
											description: """
														MatchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels
														map is equivalent to an element of matchExpressions, whose key field is "key", the
														operator is "In", and the values array contains only "value". The requirements are ANDed.
														MatchLabels requires the name to be set to `*`.
														"""
											type: "object"
										}
										name: {
											description: """
														Name of the referent
														If multiple resources are targeted `*` may be set.
														"""
											maxLength: 53
											minLength: 1
											type:      "string"
										}
										namespace: {
											description: "Namespace of the referent"
											maxLength:   53
											minLength:   1
											type:        "string"
										}
									}
									required: ["kind", "name"]
									type: "object"
								}
								type: "array"
							}
							secretRef: {
								description: """
											SecretRef specifies the Secret containing the token used
											to validate the payload authenticity.
											"""
								properties: name: {
									description: "Name of the referent."
									type:        "string"
								}
								required: ["name"]
								type: "object"
							}
							suspend: {
								description: """
											Suspend tells the controller to suspend subsequent
											events handling for this receiver.
											"""
								type: "boolean"
							}
							type: {
								description: """
											Type of webhook sender, used to determine
											the validation procedure and payload deserialization.
											"""
								enum: ["generic", "generic-hmac", "github", "gitlab", "bitbucket", "harbor", "dockerhub", "quay", "gcr", "nexus", "acr"]
								type: "string"
							}
						}
						required: ["resources", "secretRef", "type"]
						type: "object"
					}
					status: {
						default: observedGeneration: -1
						description: "ReceiverStatus defines the observed state of the Receiver."
						properties: {
							conditions: {
								description: "Conditions holds the conditions for the Receiver."
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
											enum: ["True", "False", "Unknown"]
											type: "string"
										}
										type: {
											description: "type of condition in CamelCase or in foo.example.com/CamelCase."
											maxLength:   316
											pattern:     "^([a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*/)?(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])$"
											type:        "string"
										}
									}
									required: ["lastTransitionTime", "message", "reason", "status", "type"]
									type: "object"
								}
								type: "array"
							}
							lastHandledReconcileAt: {
								description: """
											LastHandledReconcileAt holds the value of the most recent
											reconcile request value, so a change of the annotation value
											can be detected.
											"""
								type: "string"
							}
							observedGeneration: {
								description: "ObservedGeneration is the last observed generation of the Receiver object."
								format:      "int64"
								type:        "integer"
							}
							url: {
								description: """
											URL is the generated incoming webhook address in the format
											of '/hook/sha256sum(token+name+namespace)'.
											Deprecated: Replaced by WebhookPath.
											"""
								type: "string"
							}
							webhookPath: {
								description: """
											WebhookPath is the generated incoming webhook address in the format
											of '/hook/sha256sum(token+name+namespace)'.
											"""
								type: "string"
							}
						}
						type: "object"
					}
				}
				type: "object"
			}
			served:  true
			storage: false
			subresources: status: {}
		}]
	}
}
