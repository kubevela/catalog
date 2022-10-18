package main

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
  								name: type: "string"
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