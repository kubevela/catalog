metadata: {
	name:        "nacos-config"
	alias:       "Nacos Configuration"
	description: "Write the configuration to the nacos"
	sensitive:   false
	scope:       "system"
}

template: {
	nacos: {
		// The endpoint can not references the parameter.
		endpoint: {
			// Users must create a config base the nacos-server template firstly.
			name: "nacos"
		}
		format: parameter.contentType

		// could references the parameter
		metadata: {
			dataId: parameter.dataId
			group:  parameter.group
			if parameter.appName != _|_ {
				appName: parameter.appName
			}
			if parameter.namespaceId != _|_ {
				namespaceId: parameter.namespaceId
			}
			if parameter.tenant != _|_ {
				tenant: parameter.tenant
			}
			if parameter.tag != _|_ {
				tag: parameter.tag
			}
		}
		content: parameter.content
	}
	parameter: {
		// +usage=Configuration ID
		dataId: string
		// +usage=Configuration group
		group: *"DEFAULT_GROUP" | string
		// +usage=The configuration content.
		content: {
			...
		}
		contentType: *"json" | "yaml" | "properties" | "toml"
		// +usage=The app name of the configuration
		appName?: string
		// +usage=The namespaceId of the configuration
		namespaceId?: string
		// +usage=The tenant, corresponding to the namespace ID field of Nacos
		tenant?: string
		// +usage=The tag of the configuration
		tag?: string
	}
}
