"sample-tag": {
	type:        "trait"
	description: "Adds a tag label to the component's workload."
	annotations: {}
	labels: {}
	attributes: appliesToWorkloads: ["*"]
}

template: {
	patch: metadata: labels: "sample.oam.dev/tag": parameter.tag
	parameter: {
		// +usage=Tag to add
		tag: string
	}
}
