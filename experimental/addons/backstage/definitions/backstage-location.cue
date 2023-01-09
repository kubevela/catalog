"backstage-location": {
	alias: ""
	annotations: {
		"definition.oam.dev/example-url": "https://raw.githubusercontent.com/kubevela/catalog/master/examples/backstage/app-location.yaml"
	}
	attributes: {
		appliesToWorkloads: ["*"]
		podDisruptive: false
	}
	description: "Mark backstage location entity to help better integration."
	labels: {}
	type: "trait"
}

template: {

	parameter: {
		// +usage=Specify the type of this backstage location
		type?: string
		// +usage=Specify the system of this backstage location
		system?: string
		//  +usage=Specify the targets of this backstage location
		targets: [...string]
	}
}
