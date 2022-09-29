parameter: {
	//+usage=Base URL for images that the FluxCD controllers use, e.g. ghcr.io
	registry: *"" | string
	//+usage=Deploy to specified clusters. Leave empty to deploy to all clusters.
	clusters?: [...string]
	//+usage=Namespace to deploy to, defaults to flux-system
	namespace: *"flux-system" | string
	//+usage=OnlyHelmComponents only enable helm associated components, default to false
	onlyHelmComponents: *false | bool
}
