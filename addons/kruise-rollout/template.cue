import "encoding/json"

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	metadata: {
		name:      "kruise-rollout"
		namespace: "vela-system"
	}
	spec: components: [{
		name: "kruise-rollout"
		type: "helm"
		properties: {
			repoType: "helm"
			url:      "https://openkruise.github.io/charts/"
			chart:    "kruise-rollout"
			version:  "0.2.0"
		}
	}]
}

outputs: resourceTree: {
	apiVersion: "v1"
	kind:       "ConfigMap"
	metadata: {
		name:      "kruise-rollout-relation"
		namespace: "vela-system"
		labels: {
			"rules.oam.dev/resources":       "true"
			"rules.oam.dev/resource-format": "json"
		}
	}
	data: rules: json.Marshal(_rules)
}

_kruiseRollout: {
	group: "rollouts.kruise.io"
	kind:  "Rollout"
}

_batchRelease: {
	group: "rollouts.kruise.io"
	kind:  "BatchRelease"
}

_batchReleaseApiVersion: {
	apiVersion: "rollouts.kruise.io/v1alpha1"
	kind:       "BatchRelease"
}

_deploymentApiVersion: {
	apiVersion: "apps/v1"
	kind:       "Deployment"
}

_rules: [{
	parentResourceType: _kruiseRollout
	childrenResourceType: [_batchReleaseApiVersion]
}, {
	parentResourceType: _batchRelease
	childrenResourceType: [_deploymentApiVersion]
}]
