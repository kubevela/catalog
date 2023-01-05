backstage: {
	alias: ""
	annotations: {
		"definition.oam.dev/example-url": "https://raw.githubusercontent.com/kubevela/catalog/master/examples/backstage/app.yaml"
	}
	attributes: {
		appliesToWorkloads: ["*"]
		podDisruptive: false
	}
	description: "Mark backstage information to help better integration."
	labels: {}
	type: "trait"
}

template: {
	#EntityLink: {
		// +usage=Specify the url of this link
		url?: string
		// +usage=Specify the title of this link
		title?: string
		// +usage=Specify the icon of this link
		icon?: string
		// +usage=Specify the type of this link
		type?: string
	}

	parameter: {
		// +usage=Specify the type of this backstage component
		typeAlias?: string
		// +usage=Specify the lifecycle of this backstage component
		lifecycle?: string
		// +usage=Specify the owner of this backstage component
		owner?: string
		// +usage=Add description for this backstage component
		description?: string
		// +usage=Add title for this backstage component
		title?: string
		// +usage=Add tags for this backstage component
		tags?: [...string]
		// +usage=Add well-known-annotations(https://backstage.io/docs/features/software-catalog/well-known-annotations) for this backstage component
		annotations?: {...}
		// +usage=Add labels for this backstage component
		labels?: {...}
		// +usage=Add links for this backstage component
		links?: [...#EntityLink]
	}
}
