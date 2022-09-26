"tamper-container-dns-by-id": {
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
outputs:"tamper-container-dns-by-id":{
		apiVersion: "chaosblade.io/v1alpha1"
		kind:       "ChaosBlade"
		metadata: name: parameter.bladeName
		spec: experiments: [{
			action: "dns"
			desc:   "tamper container dns by id"
			matchers: [{
				name: "container-ids"
				value: parameter.ids
			}, {
				name: "domain"
				value: parameter.domains
			}, {
				name: "ip"
				value: parameter.ips
			}, {
				name: "names"
				value: parameter.names
			}]
			scope:  "container"
			target: "network"
		}]
	}
        parameter: {
            // +usage=Specify the name for ChaosBlade
            bladeName:string
            // +usage=Specify the ids
            ids:[...string]
            // +usage=Specify the domains
            domains:[...string]
            // +usage=Specify the ips
            ips:[...string]
            // +usage=Specify the names
            names:[...string]
        }
}
