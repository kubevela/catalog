"increase-container-cpu-load-by-id": {
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
		metadata: name: "increase-container-cpu-load-by-id"
		spec: experiments: [{
			action: "fullload"
			desc:   "increase container cpu load by id"
			matchers: [{
				name: "container-ids"
				value: ["2ff814b246f86"]
			}, {
				name: "cpu-percent"
				value: ["100"]
			}, {
				name: "names"
				value: ["frontend-d89756ff7-pbnnc"]
			}]
			scope:  "container"
			target: "cpu"
		}]
	}
	outputs: {}
	parameter: {}
}
