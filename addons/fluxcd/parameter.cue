parameter: {
	//+usage=Base URL for images that the FluxCD controllers use. Defaults to Docker Hub.
	registry: *"docker.io/library" | string
	//+usage=Deploy to specified clusters. Leave empty to deploy to all clusters.
	clusters?: [...string]
}
