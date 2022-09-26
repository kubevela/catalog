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
	description: "increase container cpu load by id"
	labels: {}
	type: "trait"
}

template: {
       outputs:"increase-container-cpu-load-by-id":{
		apiVersion: "chaosblade.io/v1alpha1"
		kind:       "ChaosBlade"
		metadata: name: parameter.bladeName
		spec: experiments: [{
			action: "fullload"
			desc:   "increase container cpu load by id"
			matchers: [{
				name: "container-ids"
				value: parameter.ids
			}, {
				name: "cpu-percent"
				value: parameter.percent
			}, {
				name: "names"
				value: parameter.names
			}]
			scope:  "container"
			target: "cpu"
		}]
	}
        parameter: {
            // +usage=Specify the name for ChaosBlade
            bladeName:string
            // +usage=Specify the ids
            ids:[...string]
            // +usage=Specify the percent
            percent:[...string]
            // +usage=Specify the names
            names:[...string]
        }
}
