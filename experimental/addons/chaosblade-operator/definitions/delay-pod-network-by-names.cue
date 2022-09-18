"delay-pod-network-by-names": {
	alias: ""
	annotations: {}
	attributes: {
                appliesToWorkloads:["webservice","worker","cloneset"]
                conflictsWith:[]
                podDisruptive:false
                workloadRefPath:""
	}
	description: "delay pod network by names"
	labels: {}
	type: "trait"
}

template: {
outputs:"delay-pod-network-by-names":{
		apiVersion: "chaosblade.io/v1alpha1"
		kind:       "ChaosBlade"
		metadata: name: parameter.bladeName
		spec: experiments: [{
			action: "delay"
			desc:   "delay pod network by names"
			matchers: [{
				name: "names"
				value: parameter.podName
			}, {
				name: "namespace"
				value: parameter.nsName
			}, {
				name: "local-port"
				value: parameter.ports
			}, {
				name: "interface"
				value: parameter.interfaces
			}, {
				name: "time"
				value: parameter.time
			}, {
				name: "offset"
				value: parameter.offset
			}]
			scope:  "pod"
			target: "network"
		}]
	}
        parameter: {
            // +usage=Specify the name for ChaosBlade
            bladeName:string
            // +usage=Specify the pod names
            podName:[...string]
            // +usage=Specify the ns names
            nsName:[...string]
            // +usage=Specify the ports
            ports:[...string]
            // +usage=Specify the interfaces
            interfaces:[...string]
            // +usage=Specify the time
            time:[...string]
            // +usage=Specify the offset
            offset:[...string]
        }
}
