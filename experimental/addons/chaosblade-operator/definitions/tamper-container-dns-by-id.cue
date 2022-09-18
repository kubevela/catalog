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
	output: {
		apiVersion: "chaosblade.io/v1alpha1"
		kind:       "ChaosBlade"
		metadata: name: "tamper-container-dns-by-id"
		spec: experiments: [{
			action: "dns"
			desc:   "tamper container dns by id"
			matchers: [{
				name: "container-ids"
				value: ["4b25f66580c4"]
			}, {
				name: "domain"
				value: ["www.baidu.com"]
			}, {
				name: "ip"
				value: ["10.0.0.1"]
			}, {
				name: "names"
				value: ["frontend-d89756ff7-trsxf"]
			}]
			scope:  "container"
			target: "network"
		}]
	}
	outputs: {}
	parameter: {}
}
