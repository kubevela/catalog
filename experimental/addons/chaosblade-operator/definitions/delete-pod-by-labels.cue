"chaosblade-delete-pod-by-labels": {
	alias: ""
	annotations: {}
	attributes: {
                appliesToWorkloads:["webservice","worker","cloneset"]
                conflictsWith:[]
                podDisruptive:false
                workloadRefPath:""
	}
	description: "delete pod by labels"
	labels: {}
	type: "trait"
}

template: {
outputs:"chaosblade-delete-pod-by-labels":{
		apiVersion: "chaosblade.io/v1alpha1"
		kind:       "ChaosBlade"
		metadata: name: parameter.bladeName
		spec: experiments: [{
			action: "delete"
			desc:   "delete pod by labels"
			matchers: [{
				name: "labels"
				value: parameter.labels //key=value
			}, {
				name: "namespace"
				value: parameter.nsName
			}, {
				name: "evict-count"
				value: parameter.counts
			}]
			scope:  "pod"
			target: "pod"
		}]
	}

	parameter: {
		       // +usage=Specify the name for ChaosBlade
            bladeName:string
            // +usage=Specify the labels
            labels:[...string]
            // +usage=Specify the ns names
            nsName:[...string]
            // +usage=Specify the evict counts
            counts:[...string]
	}
}
