package main

crd: {
	name: "kubetrigger-crd"
	type: "k8s-objects"
	properties: objects: [{
		"apiVersion": "apiextensions.k8s.io/v1"
		"kind":       "CustomResourceDefinition"
		"metadata": {
			"annotations": {
				"controller-gen.kubebuilder.io/version": "v0.9.0"
			}
			"creationTimestamp": null
			"name":              "triggerservices.standard.oam.dev"
		}
		"spec": {
			"group": "standard.oam.dev"
			"names": {
				"kind":     "TriggerService"
				"listKind": "TriggerServiceList"
				"plural":   "triggerservices"
				"singular": "triggerservice"
			}
			"scope": "Namespaced"
			"versions": [
				{
					"name": "v1alpha1"
					"schema": {
						"openAPIV3Schema": {
							"description": "TriggerService is the Schema for the kubetriggerconfigs API."
							"properties": {
								"apiVersion": {
									"description": "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources"
									"type":        "string"
								}
								"kind": {
									"description": "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds"
									"type":        "string"
								}
								"metadata": {
									"type": "object"
								}
								"spec": {
									"description": "TriggerServiceSpec defines the desired state of TriggerService."
									"properties": {
										"triggers": {
											"description": "Config for kube-trigger"
											"items": {
												"description": "TriggerMeta is the meta data of a trigger."
												"properties": {
													"action": {
														"description": "ActionMeta is what users type in their configurations, specifying what action they want to use and what properties they provided."
														"properties": {
															"properties": {
																"description":                          "Properties are user-provided parameters. You should parse it yourself."
																"type":                                 "object"
																"x-kubernetes-preserve-unknown-fields": true
															}
															"type": {
																"description": "Type is the type (identifier) of this action."
																"type":        "string"
															}
														}
														"required": [
															"type",
														]
														"type": "object"
													}
													"filter": {
														"type": "string"
													}
													"source": {
														"description": "Source defines the Source of trigger."
														"properties": {
															"properties": {
																"type":                                 "object"
																"x-kubernetes-preserve-unknown-fields": true
															}
															"type": {
																"type": "string"
															}
														}
														"required": [
															"properties",
															"type",
														]
														"type": "object"
													}
												}
												"required": [
													"action",
													"source",
												]
												"type": "object"
											}
											"type": "array"
										}
										"worker": {
											"description": "Worker defines the config of the worker"
											"properties": {
												"properties": {
													"type":                                 "object"
													"x-kubernetes-preserve-unknown-fields": true
												}
												"template": {
													"type": "string"
												}
											}
											"type": "object"
										}
									}
									"required": [
										"triggers",
									]
									"type": "object"
								}
							}
							"type": "object"
						}
					}
					"served":  true
					"storage": true
					"subresources": {
						"status": {}
					}
				},
			]
		}
	}, {
		"apiVersion": "apiextensions.k8s.io/v1"
		"kind":       "CustomResourceDefinition"
		"metadata": {
			"annotations": {
				"controller-gen.kubebuilder.io/version": "v0.9.0"
			}
			"creationTimestamp": null
			"name":              "eventlisteners.standard.oam.dev"
		}
		"spec": {
			"group": "standard.oam.dev"
			"names": {
				"kind":     "EventListener"
				"listKind": "EventListenerList"
				"plural":   "eventlisteners"
				"singular": "eventlistener"
			}
			"scope": "Namespaced"
			"versions": [
				{
					"name": "v1alpha1"
					"schema": {
						"openAPIV3Schema": {
							"description": "EventListener is the schema for the event listener."
							"properties": {
								"apiVersion": {
									"description": "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources"
									"type":        "string"
								}
								"events": {
									"items": {
										"description": "Event is the schema for the event."
										"properties": {
											"data": {
												"description":                          "Data is the data of the event that carries."
												"type":                                 "object"
												"x-kubernetes-preserve-unknown-fields": true
											}
											"resource": {
												"description": "Resource is the resource that triggers the event."
												"properties": {
													"apiVersion": {
														"type": "string"
													}
													"kind": {
														"type": "string"
													}
													"name": {
														"type": "string"
													}
													"namespace": {
														"type": "string"
													}
												}
												"required": [
													"apiVersion",
													"kind",
													"name",
													"namespace",
												]
												"type": "object"
											}
											"timestamp": {
												"description": "Timestamp is the time when the event is triggered."
												"format":      "date-time"
												"type":        "string"
											}
											"type": {
												"description": "Type is the type of the event."
												"type":        "string"
											}
										}
										"required": [
											"resource",
											"timestamp",
										]
										"type": "object"
									}
									"nullable": true
									"type":     "array"
								}
								"kind": {
									"description": "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds"
									"type":        "string"
								}
								"metadata": {
									"type": "object"
								}
							}
							"type": "object"
						}
					}
					"served":  true
					"storage": true
				},
			]
		}
	}]
}
