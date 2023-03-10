package main
output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	spec: {
		components: [
			{
				name: "koordinator"
				type: "helm"
				properties:	{
					repoType: "helm"
					url: "https://koordinator-sh.github.io/charts/"
					chart: "koordinator"
					version: "1.1.1"
				}
			},
		]
	}
}
