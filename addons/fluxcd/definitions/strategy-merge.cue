"kustomize-strategy-merge": {
	attributes: {
		podDisruptive: false
	}
	description: "A list of strategic merge to kustomize config"
	labels: {
		"ui-hidden": "true"
	}
	type: "trait"
}

template: {
	patch: {
		spec: {
			patches: parameter.patchesStrategicMerge
		}
	}

	parameter: {
		// +usage=a list of strategicmerge, defined as inline yaml objects.
		patchesStrategicMerge: [...#nestedmap]
	}

	#nestedmap: {
		...
	}
}
