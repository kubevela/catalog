"fail-pod-by-labels": {
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
		metadata: name: "delete-two-pod-by-labels"
		spec: experiments: [{
			action: "fail"
			desc:   "inject fail image to  select pod"
			matchers: [{
				name: "labels"
				value: ["app=guestbook"]
			}, {
				name: "namespace"
				value: ["default"]
			}]
			scope:  "pod"
			target: "pod"
		}]
	}
	outputs: {}
	parameter: {}
}
