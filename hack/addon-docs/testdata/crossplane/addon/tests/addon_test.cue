import "vela/test"

_xrd: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "ComponentDefinition"
	metadata: {name: "crossplane-xrd", namespace: "vela-system"}
}

"installs Crossplane 2 by default, on the hub only": test.#AddonRender & {
	addon: ".."
	expect: {
		components: crossplane: {
			type: "helmchart"
			properties: {
				chart: {source: "crossplane", repoURL: "https://charts.crossplane.io/stable", version: "2.5.0"}
				release: {name: "crossplane", namespace: "crossplane-system"}
			}
		}
		application: spec: {
			policies: [{type: "topology", properties: clusters: ["local"]}] @contains()
		}
		definitions: ComponentDefinition: {
			"crossplane-provider": kind:    "ComponentDefinition"
			"crossplane-function": kind:    "ComponentDefinition"
			"crossplane-composition": kind: "ComponentDefinition"
		}
	}
}

"ships the Crossplane 2 composite resource definition and activation policy": test.#AddonRender & {
	addon: ".."
	expect: {
		auxiliaries: [
			_xrd & {spec: schematic: cue: template: =~"apiextensions.crossplane.io/v2"},
			{kind: "ComponentDefinition", metadata: name: "crossplane-activation-policy"},
		] @contains()
	}
}

"major 1 installs Crossplane 1.20": test.#AddonRender & {
	addon: ".."
	parameter: major: 1
	expect: components: crossplane: properties: chart: version: "1.20.15"
}

"major 1 ships the v1 composite resource definition, under the same name, and no activation policy": test.#AddonRender & {
	addon: ".."
	parameter: major: 1
	expect: {
		auxiliaries: [_xrd & {spec: schematic: cue: template: =~"apiextensions.crossplane.io/v1"}] @exact()
	}
}

"refuses a chart from the other major": test.#AddonRender & {
	addon: ".."
	parameter: chart: version: "1.20.15"
	expect: error: =~"chart.version 1.20.15 is major 1, but major 2 is selected: set major to match"
}

"refuses a chart older than the selected major's floor": test.#AddonRender & {
	addon: ".."
	parameter: {major: 1, chart: version: "1.19.4"}
	expect: error: =~"chart.version 1.19.4 is older than 1.20.0"
}

"takes a later chart within the major": test.#AddonRender & {
	addon: ".."
	parameter: chart: version: "2.6.0"
	expect: components: crossplane: properties: chart: version: "2.6.0"
}

"refuses a major it has no definitions for": test.#AddonRender & {
	addon: ".."
	parameter: major: 3
	expect: error:    =~"major"
}

"chartInstall false still ships the selected major's definitions": test.#AddonRender & {
	addon: ".."
	parameter: {chartInstall: false, major: 1}
	expect: {
		components: crossplane?: _|_
		auxiliaries: [_xrd & {spec: schematic: cue: template: =~"apiextensions.crossplane.io/v1"}] @exact()
	}
}

"replicas, monitoring and args go to the chart": test.#AddonRender & {
	addon: ".."
	parameter: {replicas: 2, monitoring: true, args: ["--debug"]}
	expect: components: crossplane: properties: values: {replicas: 2, metrics: enabled: true, args: ["--debug"]}
}

"resources set the Crossplane pod's": test.#AddonRender & {
	addon: ".."
	parameter: resources: requests: cpu: "200m"
	expect: components: crossplane: properties: values: resourcesCrossplane: requests: cpu: "200m"
}

"placement applies to Crossplane and its RBAC manager": test.#AddonRender & {
	addon: ".."
	parameter: {nodeSelector: pool: "system", tolerations: [{key: "dedicated", operator: "Exists"}]}
	expect: components: crossplane: properties: values: {
		nodeSelector: pool: "system"
		tolerations: [{key: "dedicated", operator: "Exists"}]
		rbacManager: {nodeSelector: pool: "system", tolerations: [{key: "dedicated", operator: "Exists"}]}
	}
}

"refuses a toleration operator Kubernetes does not have": test.#AddonRender & {
	addon: ".."
	parameter: tolerations: [{key: "dedicated", operator: "Equals"}]
	expect: error: =~"operator"
}

"pulls from a mirror, with pull secrets and its CA bundle": test.#AddonRender & {
	addon: ".."
	parameter: {
		imageRegistry: "registry.example.com"
		imagePullSecrets: ["mirror-creds"]
		registryCaBundle: {name: "mirror-ca", key: "ca.crt"}
		packageCacheSize: "1Gi"
	}
	expect: components: crossplane: properties: values: {
		image: repository: "registry.example.com/crossplane/crossplane"
		imagePullSecrets: ["mirror-creds"]
		registryCaBundleConfig: {name: "mirror-ca", key: "ca.crt"}
		packageCache: sizeLimit: "1Gi"
	}
}

"sends nothing for a parameter left unset, so the chart's own default applies": test.#AddonRender & {
	addon: ".."
	expect: components: crossplane: properties: values: {
		replicas:             1
		metrics?:             _|_
		resourcesCrossplane?: _|_
		image?:               _|_
	}
}

"values pass a setting the addon has no parameter for, and override a parameter": test.#AddonRender & {
	addon: ".."
	parameter: {replicas: 2, values: {replicas: 3, deploymentStrategy: "Recreate"}}
	expect: components: crossplane: properties: values: {replicas: 3, deploymentStrategy: "Recreate"}
}

"affinity is typed and reaches every pod": test.#AddonRender & {
	addon: ".."
	parameter: affinity: {
		nodeAffinity: requiredDuringSchedulingIgnoredDuringExecution: nodeSelectorTerms: [{
			matchExpressions: [{key: "pool", operator: "In", values: ["system"]}]
		}]
		podAntiAffinity: preferredDuringSchedulingIgnoredDuringExecution: [{
			weight: 100
			podAffinityTerm: {topologyKey: "kubernetes.io/hostname", labelSelector: matchLabels: app: "crossplane"}
		}]
	}
	expect: components: "crossplane": properties: values: {
		affinity: {
			nodeAffinity: requiredDuringSchedulingIgnoredDuringExecution: nodeSelectorTerms: [{
				matchExpressions: [{key: "pool", operator: "In", values: ["system"]}]
			}]
			podAntiAffinity: preferredDuringSchedulingIgnoredDuringExecution: [{
				weight: 100
				podAffinityTerm: {topologyKey: "kubernetes.io/hostname", labelSelector: matchLabels: app: "crossplane"}
			}]
		}
		rbacManager: affinity: {
			nodeAffinity: requiredDuringSchedulingIgnoredDuringExecution: nodeSelectorTerms: [{
				matchExpressions: [{key: "pool", operator: "In", values: ["system"]}]
			}]
			podAntiAffinity: preferredDuringSchedulingIgnoredDuringExecution: [{
				weight: 100
				podAffinityTerm: {topologyKey: "kubernetes.io/hostname", labelSelector: matchLabels: app: "crossplane"}
			}]
		}
	}
}


"refuses an affinity operator Kubernetes does not have": test.#AddonRender & {
	addon: ".."
	parameter: affinity: nodeAffinity: requiredDuringSchedulingIgnoredDuringExecution: nodeSelectorTerms: [{
		matchExpressions: [{key: "pool", operator: "Equals", values: ["system"]}]
	}]
	expect: error: =~"operator"
}

"accepts cpu and memory as Kubernetes quantities": test.#AddonRender & {
	addon: ".."
	parameter: resources: {requests: {cpu: 0.5, memory: "256Mi"}, limits: {cpu: "500m", memory: "1G"}}
	expect: components: "crossplane": type: "helmchart"
}

"refuses cpu that is not a quantity": test.#AddonRender & {
	addon: ".."
	parameter: resources: requests: cpu: "lots"
	expect: error: =~"cpu"
}

"refuses memory that is not a quantity": test.#AddonRender & {
	addon: ".."
	parameter: resources: limits: memory: "1 GB"
	expect: error: =~"memory"
}

"installWith defaults to vela, and vela without chartInstall installs nothing": test.#AddonRender & {
	addon: ".."
	parameter: {chartInstall: false, installWith: "vela"}
	expect: components: "crossplane"?: _|_
}
