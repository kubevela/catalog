package main

import (
	"list"
	"strconv"
)

shardKeys: *[] | [...string]
if parameter.shardNames != _|_ {
	shardKeys: parameter.shardNames
}
if parameter.shardNames == _|_ && parameter.nShards != _|_ {
	shardKeys: [ for j in [ for i in list.Range(0, parameter.nShards, 1) {strconv.FormatInt(i, 10)}] {"shard-\(j)"}]
}

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	spec: {
		components: [
			for key in shardKeys {
				type: "ref-objects"
				name: "\(parameter.deploymentName)-\(key)"
				properties: objects: [{
					resource: "deployments"
					name:     parameter.deploymentName
				}]
				traits: [{
					type: "command"
					properties: {
						containerName: parameter.containerName
						addArgs: ["--shard-id=\(key)"]
					}
				}, {
					type: "json-merge-patch"
					properties: {
						metadata: name: "\(parameter.deploymentName)-\(key)"
						spec: {
							replicas: parameter.replicas
							_labels: {
								"app.kubernetes.io/instance":       parameter.instanceName
								"controller.core.oam.dev/shard-id": key
							}
							selector: matchLabels: _labels
							template: metadata: labels: _labels
						}
					}
				}, {
					type: "json-patch"
					properties: operations: [
						if parameter.cpu != _|_ {
							op:    "add"
							path:  "/spec/template/spec/containers/0/resources/limits/cpu"
							value: parameter.cpu
						},
						if parameter.cpu != _|_ {
							op:    "add"
							path:  "/spec/template/spec/containers/0/resources/requests/cpu"
							value: parameter.cpu
						},
						if parameter.memory != _|_ {
							op:    "add"
							path:  "/spec/template/spec/containers/0/resources/limits/memory"
							value: parameter.memory
						},
						if parameter.memory != _|_ {
							op:    "add"
							path:  "/spec/template/spec/containers/0/resources/requests/memory"
							value: parameter.memory
						},
					]
				}]
			},
		]
	}
}