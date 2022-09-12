parameter: {
	//+usage=Base URL for images that the kube-trigger controllers use, e.g. ghcr.io
	registry?: *"" | string
	//+usage=Deploy to specified clusters. Leave empty to deploy to all clusters.
	clusters?: [...string]
	//+usage=Namespace to deploy to, defaults to kube-trigger-system
	namespace?: *"kube-trigger-system" | string
	//+usage=Create a default trigger instance so you don't need to create manually. Only recommended for testing purposes.
	createDefaultInstance: *true | false
}
