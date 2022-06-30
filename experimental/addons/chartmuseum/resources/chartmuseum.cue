output: {
	type: "helm"
	properties: {
		url:      "https://chartmuseum.github.io/charts"
		repoType: "helm"
		chart:    "chartmuseum/chartmuseum"
		version:  context.metadata.version
		values: {
			env: open: {
				STORAGE
			}
		}
	}
	
}