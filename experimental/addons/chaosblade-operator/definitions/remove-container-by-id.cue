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
	description: "remove container by id"
	labels: {}
	type: "trait"
}

template: {
outputs:"remove-container-by-id":{
		apiVersion: "chaosblade.io/v1alpha1"
		kind:       "ChaosBlade"
		metadata: name: parameter.bladeName
		spec: experiments: [{
			action: "remove"
			desc:   "remove container by id"
			matchers: [{
				name: "container-ids"
				value: parameter.ids
			}, {
				name: "names"
				value: ["frontend-d89756ff7-szblb"]
			}, {
				name: "namespace"
				value: parameter.namespaces
			}]
			scope:  "container"
			target: "container"
		}]
	}
        parameter: {
            // +usage=Specify the name for ChaosBlade
            bladeName:string
            // +usage=Specify the ids
            ids:[...string]
            // +usage=Specify the names
            names:[...string]
            // +usage=Specify the namespaces
            namespaces:[...string]
        }
}
