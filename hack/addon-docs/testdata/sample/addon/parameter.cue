parameter: {
	// +usage=Namespace to install into
	namespace: *"sample" | string
	// +usage=How many replicas to run
	replicas: *1 | int
	// +usage=What installs it. Default: vela
	installWith?: "vela" | "flux" | "argo"
	// +usage=Clusters to install on. Leave it out for every cluster
	clusters?: [...string]
	// +usage=CPU and memory for each pod
	resources?: {
		// +usage=What each pod asks for
		requests?: {
			cpu?:    string
			memory?: string
		}
	}
	// +usage=Extra flags, one entry each
	extraArgs?: [...{
		// +usage=Flag name
		name: string
		// +usage=Flag value
		value?: string
	}]
	// +usage=Labels on every object
	labels?: [string]: string
	// +ui:hidden
	// +usage=Chart values set as written
	values?: {...}
}
