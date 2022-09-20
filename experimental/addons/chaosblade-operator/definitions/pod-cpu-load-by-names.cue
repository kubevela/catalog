"pod-cpu-load-by-names": {
	alias: ""
	annotations: {}
	attributes: {
                appliesToWorkloads:["webservice","worker","cloneset"]
                conflictsWith:[]
                podDisruptive:false
                workloadRefPath:""
	}
	description: "increase node cpu load by names"
	labels: {}
	type: "trait"
}

template: {
outputs:"pod-cpu-load-by-names":{
		apiVersion: "chaosblade.io/v1alpha1"
		kind:       "ChaosBlade"
		metadata: name: parameter.bladeName
		spec: experiments: [{
			action: "fullload"
			desc:   "increase node cpu load by names"
			matchers: [{
				name: "names"
				value: parameter.names
			}, {
				name: "cpu-percent"
				value: parameter.cpuPercent
			}]
			scope:  "pod"
			target: "cpu"
		}]
	}
	parameter: {
		    // +usage=Specify the name for ChaosBlade
            bladeName:string
            // +usage=Specify the cpuPercent
            cpuPercent:[...string]
            // +usage=Specify the names
            names:[...string]
	}
}
