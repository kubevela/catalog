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
	description: "kill container process by id"
	labels: {}
	type: "trait"
}

template: {
       outputs:"kill-container-process-by-id":{
		apiVersion: "chaosblade.io/v1alpha1"
		kind:       "ChaosBlade"
		metadata: name: parameter.bladeName
		spec: experiments: [{
			action: "kill"
			desc:   "kill container process by id"
			matchers: [{
				name: "container-ids"
				value: parameter.ids
			}, {
				name: "process"
				value: parameter.process
			}, {
				name: "names"
				value: parameter.names
			}]
			scope:  "container"
			target: "process"
		}]
	}

        parameter: {
            // +usage=Specify the name for ChaosBlade
            bladeName:string
            // +usage=Specify the ids
            ids:[...string]
            // +usage=Specify the process
            process:[...string]
            // +usage=Specify the names
            names:[...string]
        }
}
