"remove-container-by-id": {
	alias: ""
	annotations: {}
	attributes: {
		appliesToWorkloads: []
		conflictsWith: []
		definitionRef:   ""
		podDisruptive:   false
		workloadRefPath: ""
	}
	description: ""
	labels: {}
	type: "trait"
}

template: {
	output: {
		apiVersion: "chaosblade.io/v1alpha1"
		kind:       "ChaosBlade"
		metadata: name: "remove-container-by-id"
		spec: experiments: [{
			action: "remove"
			desc:   "remove container by id"
			matchers: [{
				name: "container-ids"
				value: ["072aa6bbf2e2e2"]
			}, {
				name: "names"
				value: ["frontend-d89756ff7-szblb"]
			}, {
				name: "namespace"
				value: ["default"]
			}]
			scope:  "container"
			target: "container"
		}]
	}
	outputs: {}
	parameter: {}
}
