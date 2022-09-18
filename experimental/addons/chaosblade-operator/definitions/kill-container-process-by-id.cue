"kill-container-process-by-id": {
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
		metadata: name: "kill-container-process-by-id"
		spec: experiments: [{
			action: "kill"
			desc:   "kill container process by id"
			matchers: [{
				name: "container-ids"
				value: ["f1de335b4eeaf"]
			}, {
				name: "process"
				value: ["top"]
			}, {
				name: "names"
				value: ["frontend-d89756ff7-tl4xl"]
			}]
			scope:  "container"
			target: "process"
		}]
	}
	outputs: {}
	parameter: {}
}
