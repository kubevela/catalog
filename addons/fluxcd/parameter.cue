parameter: {
	//+usage=Base URL for images that the FluxCD controllers use, defaults to GitHub Container Registry.
	registry: *"ghcr.io" | string
	//+usage=Deploy to specified clusters. Leave empty to deploy to all clusters.
	clusters?: [...string]
}
