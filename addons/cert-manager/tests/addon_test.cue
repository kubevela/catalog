import "vela/test"

"installs the pinned chart": test.#AddonRender & {
	addon: ".."
	expect: {
		components: "cert-manager": {
			type: "helmchart"
			properties: {
				chart: {source: "cert-manager", repoURL: "https://charts.jetstack.io", version: "v1.21.3"}
				release: {name: "cert-manager", namespace: "cert-manager"}
				values: {crds: {enabled: true, keep: true}, replicaCount: 1, webhook: replicaCount: 1, cainjector: replicaCount: 1}
			}
		}
		definitions: {
			ComponentDefinition: issuer: kind:  "ComponentDefinition"
			TraitDefinition: certificate: kind: "TraitDefinition"
			PolicyDefinition?: _|_
		}
	}
}

"deploys to every cluster unless clusters are named": test.#AddonRender & {
	addon: ".."
	expect: application: spec: {
		policies: [{type: "topology", properties: clusterLabelSelector: {}}] @contains()
	}
}

"deploys to the named clusters": test.#AddonRender & {
	addon: ".."
	parameter: clusters: ["local", "edge-1"]
	expect: application: spec: {
		policies: [{type: "topology", properties: clusters: ["local", "edge-1"]}] @contains()
	}
}

"chartInstall false installs no chart, but still ships the definitions": test.#AddonRender & {
	addon: ".."
	parameter: chartInstall: false
	expect: {
		components: "cert-manager"?: _|_
		definitions: TraitDefinition: certificate: kind: "TraitDefinition"
	}
}

"refuses installWith without chartInstall": test.#AddonRender & {
	addon: ".."
	parameter: {chartInstall: false, installWith: "flux"}
	expect: error: =~"installWith has no effect with chartInstall false"
}

"installWith flux renders a HelmRepository and a HelmRelease that upgrades CRDs": test.#AddonRender & {
	addon: ".."
	parameter: {installWith: "flux", values: replicaCount: 2}
	expect: components: "cert-manager": {
		type: "k8s-objects"
		properties: objects: [{
			apiVersion: "source.toolkit.fluxcd.io/v1"
			kind:       "HelmRepository"
			metadata: {name: "cert-manager", namespace: "vela-system"}
			spec: {url: "https://charts.jetstack.io", type?: _|_}
		}, {
			apiVersion: "helm.toolkit.fluxcd.io/v2"
			kind:       "HelmRelease"
			metadata: {name: "cert-manager", namespace: "vela-system"}
			spec: {
				releaseName:      "cert-manager"
				targetNamespace:  "cert-manager"
				storageNamespace: "cert-manager"
				chart: spec: {chart: "cert-manager", version: "v1.21.3", sourceRef: {kind: "HelmRepository", name: "cert-manager"}}
				install: crds: "CreateReplace"
				upgrade: crds: "CreateReplace"
				values: {replicaCount: 2, crds: {enabled: true, keep: true}}
			}
		}]
	}
}

"installWith flux reads an OCI mirror as an OCI repository": test.#AddonRender & {
	addon: ".."
	parameter: {installWith: "flux", chart: repoURL: "oci://registry.example.com/charts"}
	expect: components: "cert-manager": properties: objects: [{spec: {url: "oci://registry.example.com/charts", type: "oci"}}, _]
}

"installWith argo renders an Argo CD Application": test.#AddonRender & {
	addon: ".."
	parameter: {installWith: "argo", chart: version: "v1.21.4"}
	expect: components: "cert-manager": {
		type: "k8s-objects"
		properties: objects: [{
			apiVersion: "argoproj.io/v1alpha1"
			kind:       "Application"
			metadata: {name: "cert-manager", namespace: "argocd"}
			spec: {
				source: {
					repoURL:        "https://charts.jetstack.io"
					chart:          "cert-manager"
					targetRevision: "v1.21.4"
					// A string: valuesObject needs Argo CD 2.6.
					helm: {releaseName: "cert-manager", values: "crds:\n  enabled: true\n  keep: true\nreplicaCount: 1\nwebhook:\n  replicaCount: 1\ncainjector:\n  replicaCount: 1\n"}
				}
				destination: {server: "https://kubernetes.default.svc", namespace: "cert-manager"}
				syncPolicy: syncOptions: ["CreateNamespace=true", "ServerSideApply=true"]
			}
		}]
	}
}

"refuses an unknown installer": test.#AddonRender & {
	addon: ".."
	parameter: installWith: "kustomize"
	expect: error:          =~"installWith"
}

"a chart version and mirror override the pinned ones": test.#AddonRender & {
	addon: ".."
	parameter: chart: {version: "v1.21.4", repoURL: "https://charts.example.com/jetstack"}
	expect: components: "cert-manager": properties: chart: {
		source:  "cert-manager"
		repoURL: "https://charts.example.com/jetstack"
		version: "v1.21.4"
	}
}

"values override what the parameters set": test.#AddonRender & {
	addon: ".."
	parameter: values: {replicaCount: 2, crds: keep: false}
	expect: components: "cert-manager": properties: values: {
		replicaCount: 2
		crds: {enabled: true, keep: false}
	}
}

"the release follows the namespace": test.#AddonRender & {
	addon: ".."
	parameter: namespace: "tls"
	expect: components: "cert-manager": properties: release: namespace: "tls"
}

// vela addon upgrade carries stored parameters forward and cannot unset one, so 2.x's must still be accepted.
_v2: {
	dns01: {namespace: "shop", cloudflare: {email: "ops@example.com", token: "s3cr3t-token", zone: "example.com", domain: "example.com"}}
	staging:     true
	installCRDs: true
	upgradeCRD:  false
	replicas:    2
}

"accepts the 2.x parameters an upgrade carries over, ignoring all but replicas": test.#AddonRender & {
	addon:     ".."
	parameter: _v2
	expect: {
		components: "cert-manager": properties: values: crds: {enabled: true, keep: true}
		components: "cert-manager": properties: values: replicaCount: 2
		components: "certificate-conf"?: _|_
		auxiliaries?: []
	}
}

"ships no global policy unless asked": test.#AddonRender & {
	addon: ".."
	expect: auxiliaries?: []
}

"namespaceIssuers adds the global policy that lets a namespace choose its issuer": test.#AddonRender & {
	addon: ".."
	parameter: namespaceIssuers: true
	expect: auxiliaries: [{
		apiVersion: "core.oam.dev/v1beta1"
		kind:       "PolicyDefinition"
		metadata: {name: "cert-manager-default-issuer", namespace: "vela-system"}
		// A range, not 100: the harness hands auxiliaries back with numbers as floats (1e+2).
		spec: {global: true, priority: >=100 & <=100, schematic: cue: template: =~"cert-manager.oam.dev/cluster-issuer"}
	}]
}

"never garbage-collects the chart's CRDs, so disabling keeps every certificate": test.#AddonRender & {
	addon: ".."
	expect: application: spec: {
		policies: [{
			type: "garbage-collect"
			properties: rules: [{
				selector: {componentNames: ["cert-manager"], resourceTypes: ["CustomResourceDefinition"]}
				strategy: "never"
			}]
		}] @contains()
	}
}

"leaves CRDs to Flux, which keeps them on uninstall as Helm does": test.#AddonRender & {
	addon: ".."
	parameter: installWith: "flux"
	expect: application: spec: {
		policies: [{name: "cert-manager-keep-crds"}] @contains() @not()
	}
}

"releaseName keeps an existing release, such as the one the 2.x addon installed through Flux": test.#AddonRender & {
	addon: ".."
	parameter: releaseName: "cert-manager-cert-manager"
	expect: {
		components: "cert-manager": properties: release: {name: "cert-manager-cert-manager", namespace: "cert-manager"}
		application: spec: {
			policies: [{
				type: "garbage-collect"
				properties: rules: [{selector: componentNames: ["cert-manager"]}]
			}] @contains()
		}
	}
}

"releaseName names the Flux release too": test.#AddonRender & {
	addon: ".."
	parameter: {installWith: "flux", releaseName: "cert-manager-cert-manager"}
	expect: components: "cert-manager": properties: {
		objects: [{kind: "HelmRelease", spec: releaseName: "cert-manager-cert-manager"}] @contains()
	}
}

"releaseName names the Argo CD release too": test.#AddonRender & {
	addon: ".."
	parameter: {installWith: "argo", releaseName: "cert-manager-cert-manager"}
	expect: components: "cert-manager": properties: {
		objects: [{kind: "Application", spec: source: helm: releaseName: "cert-manager-cert-manager"}] @contains()
	}
}

"leaves the issuer, certificate and webhook 2.x made from dns01 in place, rather than deleting them": test.#AddonRender & {
	addon: ".."
	expect: application: spec: {
		policies: [{
			type: "garbage-collect"
			properties: rules: [{
				selector: componentNames: ["certificate-conf", "alidns-webhook"]
				propagation: "orphan"
			}]
		}] @contains()
	}
}

"installWith argo removes what Argo CD applied when the addon is disabled": test.#AddonRender & {
	addon: ".."
	parameter: installWith: "argo"
	expect: components: "cert-manager": properties: {
		objects: [{
			kind: "Application"
			metadata: finalizers: ["resources-finalizer.argocd.argoproj.io"]
		}] @contains()
	}
}

"refuses a chart older than v1.15.0, which has no crds.enabled or crds.keep": test.#AddonRender & {
	addon: ".."
	parameter: chart: version: "v1.14.7"
	expect: error: =~"chart.version v1.14.7 is older than v1.15.0, the oldest this addon supports"
}

"accepts the oldest supported chart": test.#AddonRender & {
	addon: ".."
	parameter: chart: version: "v1.15.0"
	expect: components: "cert-manager": properties: chart: version: "v1.15.0"
}

"compares versions as numbers, not strings": test.#AddonRender & {
	addon: ".."
	parameter: chart: version: "v1.100.0"
	expect: components: "cert-manager": properties: chart: version: "v1.100.0"
}

"accepts a pre-release of a later version": test.#AddonRender & {
	addon: ".."
	parameter: chart: version: "v1.22.0-alpha.1"
	expect: components: "cert-manager": properties: chart: version: "v1.22.0-alpha.1"
}

"refuses a version it cannot compare": test.#AddonRender & {
	addon: ".."
	parameter: chart: version: "1.x"
	expect: error: =~"chart.version 1.x is not a version like v1.21.3"
}

"applies the floor to every installer": test.#AddonRender & {
	addon: ".."
	parameter: {installWith: "flux", chart: version: "v1.9.1"}
	expect: error: =~"older than v1.15.0"
}

"crds.keep false lets disabling the addon remove the CRDs": test.#AddonRender & {
	addon: ".."
	parameter: values: crds: keep: false
	expect: application: spec: {
		policies: [{name: "cert-manager-keep-crds"}] @contains() @not()
	}
}

"checks no chart version when it installs no chart": test.#AddonRender & {
	addon: ".."
	parameter: {chartInstall: false, chart: version: "v1.14.7"}
	expect: components: "cert-manager"?: _|_
}

"refuses a version with anything after it but a pre-release or build": test.#AddonRender & {
	addon: ".."
	parameter: chart: version: "v1.21.3foo"
	expect: error: =~"chart.version v1.21.3foo is not a version like v1.21.3"
}

"refuses a release name Helm cannot use": test.#AddonRender & {
	addon: ".."
	parameter: releaseName: "Cert_Manager"
	expect: error:          =~#"invalid value "Cert_Manager""#
}

"replicas sets every Deployment": test.#AddonRender & {
	addon: ".."
	parameter: replicas: 3
	expect: components: "cert-manager": properties: values: {replicaCount: 3, webhook: replicaCount: 3, cainjector: replicaCount: 3}
}

"highAvailability adds a PodDisruptionBudget to every Deployment": test.#AddonRender & {
	addon: ".."
	parameter: {replicas: 2, highAvailability: true}
	expect: components: "cert-manager": properties: values: {
		podDisruptionBudget: enabled: true
		webhook: podDisruptionBudget: enabled:    true
		cainjector: podDisruptionBudget: enabled: true
	}
}

"refuses highAvailability with one replica": test.#AddonRender & {
	addon: ".."
	parameter: highAvailability: true
	expect: error:               =~"highAvailability needs replicas of 2 or more"
}

"monitoring adds a ServiceMonitor": test.#AddonRender & {
	addon: ".."
	parameter: monitoring: true
	expect: components: "cert-manager": properties: values: prometheus: {enabled: true, servicemonitor: enabled: true}
}

"keepCRDs false lets disabling remove the CRDs": test.#AddonRender & {
	addon: ".."
	parameter: keepCRDs: false
	expect: {
		components: "cert-manager": properties: values: crds: keep: false
		application: spec: {
			policies: [{name: "cert-manager-keep-crds"}] @contains() @not()
		}
	}
}

"resources apply to every pod": test.#AddonRender & {
	addon: ".."
	parameter: resources: requests: {cpu: "10m", memory: "64Mi"}
	expect: components: "cert-manager": properties: values: {
		resources: requests: {cpu: "10m", memory: "64Mi"}
		webhook: resources: requests: {cpu: "10m", memory: "64Mi"}
		cainjector: resources: requests: {cpu: "10m", memory: "64Mi"}
	}
}

"placement applies to every pod": test.#AddonRender & {
	addon: ".."
	parameter: {
		nodeSelector: pool: "system"
		tolerations: [{key: "dedicated", value: "system", effect: "NoSchedule"}]
		priorityClassName: "system-cluster-critical"
	}
	expect: components: "cert-manager": properties: values: {
		global: {nodeSelector: pool: "system", priorityClassName: "system-cluster-critical"}
		tolerations: [{key: "dedicated", operator: "Equal", value: "system", effect: "NoSchedule"}]
		webhook: tolerations: [{key: "dedicated", operator: "Equal", value: "system", effect: "NoSchedule"}]
		startupapicheck: tolerations: [{key: "dedicated", operator: "Equal", value: "system", effect: "NoSchedule"}]
	}
}

"refuses a toleration effect Kubernetes does not have": test.#AddonRender & {
	addon: ".."
	parameter: tolerations: [{key: "dedicated", effect: "NoRun"}]
	expect: error: =~"parameter.tolerations.0.effect: .*empty disjunction"
}

"pulls images from a mirror with pull secrets": test.#AddonRender & {
	addon: ".."
	parameter: {imageRegistry: "registry.example.com", imagePullSecrets: ["mirror-creds"]}
	expect: components: "cert-manager": properties: values: {
		imageRegistry: "registry.example.com"
		global: imagePullSecrets: [{name: "mirror-creds"}]
	}
}

"featureGates and dns01Nameservers become the chart's comma-separated strings": test.#AddonRender & {
	addon: ".."
	parameter: {featureGates: {ServerSideApply: true}, dns01Nameservers: ["1.1.1.1:53", "8.8.8.8:53"]}
	expect: components: "cert-manager": properties: values: {
		featureGates:                  "ServerSideApply=true"
		dns01RecursiveNameservers:     "1.1.1.1:53,8.8.8.8:53"
		dns01RecursiveNameserversOnly: true
	}
}

"certificateOwnerRef deletes a certificate's Secret with it": test.#AddonRender & {
	addon: ".."
	parameter: certificateOwnerRef: true
	expect: components: "cert-manager": properties: values: enableCertificateOwnerRef: true
}

"sends nothing for a parameter left unset, so the chart's own default applies": test.#AddonRender & {
	addon: ".."
	expect: components: "cert-manager": properties: values: {
		resources?:                 _|_
		prometheus?:                _|_
		global?:                    _|_
		enableCertificateOwnerRef?: _|_
	}
}

"values pass a setting the addon has no parameter for": test.#AddonRender & {
	addon: ".."
	parameter: values: podDnsPolicy: "None"
	expect: components: "cert-manager": properties: values: podDnsPolicy: "None"
}

"affinity is typed and reaches every pod": test.#AddonRender & {
	addon: ".."
	parameter: affinity: {
		nodeAffinity: requiredDuringSchedulingIgnoredDuringExecution: nodeSelectorTerms: [{
			matchExpressions: [{key: "pool", operator: "In", values: ["system"]}]
		}]
		podAntiAffinity: preferredDuringSchedulingIgnoredDuringExecution: [{
			weight: 100
			podAffinityTerm: {topologyKey: "kubernetes.io/hostname", labelSelector: matchLabels: app: "cert-manager"}
		}]
	}
	expect: components: "cert-manager": properties: values: {
		affinity: {
			nodeAffinity: requiredDuringSchedulingIgnoredDuringExecution: nodeSelectorTerms: [{
				matchExpressions: [{key: "pool", operator: "In", values: ["system"]}]
			}]
			podAntiAffinity: preferredDuringSchedulingIgnoredDuringExecution: [{
				weight: 100
				podAffinityTerm: {topologyKey: "kubernetes.io/hostname", labelSelector: matchLabels: app: "cert-manager"}
			}]
		}
		webhook: affinity: {
			nodeAffinity: requiredDuringSchedulingIgnoredDuringExecution: nodeSelectorTerms: [{
				matchExpressions: [{key: "pool", operator: "In", values: ["system"]}]
			}]
			podAntiAffinity: preferredDuringSchedulingIgnoredDuringExecution: [{
				weight: 100
				podAffinityTerm: {topologyKey: "kubernetes.io/hostname", labelSelector: matchLabels: app: "cert-manager"}
			}]
		}
		cainjector: affinity: {
			nodeAffinity: requiredDuringSchedulingIgnoredDuringExecution: nodeSelectorTerms: [{
				matchExpressions: [{key: "pool", operator: "In", values: ["system"]}]
			}]
			podAntiAffinity: preferredDuringSchedulingIgnoredDuringExecution: [{
				weight: 100
				podAffinityTerm: {topologyKey: "kubernetes.io/hostname", labelSelector: matchLabels: app: "cert-manager"}
			}]
		}
		startupapicheck: affinity: {
			nodeAffinity: requiredDuringSchedulingIgnoredDuringExecution: nodeSelectorTerms: [{
				matchExpressions: [{key: "pool", operator: "In", values: ["system"]}]
			}]
			podAntiAffinity: preferredDuringSchedulingIgnoredDuringExecution: [{
				weight: 100
				podAffinityTerm: {topologyKey: "kubernetes.io/hostname", labelSelector: matchLabels: app: "cert-manager"}
			}]
		}
	}
}

"refuses an affinity operator Kubernetes does not have": test.#AddonRender & {
	addon: ".."
	parameter: affinity: nodeAffinity: requiredDuringSchedulingIgnoredDuringExecution: nodeSelectorTerms: [{
		matchExpressions: [{key: "pool", operator: "Equals", values: ["system"]}]
	}]
	expect: error: =~"matchExpressions.0.operator: .*empty disjunction"
}

"accepts cpu and memory as Kubernetes quantities": test.#AddonRender & {
	addon: ".."
	parameter: resources: {requests: {cpu: 0.5, memory: "256Mi"}, limits: {cpu: "500m", memory: "1G"}}
	expect: components: "cert-manager": type: "helmchart"
}

"refuses cpu that is not a quantity": test.#AddonRender & {
	addon: ".."
	parameter: resources: requests: cpu: "lots"
	expect: error: =~"parameter.resources.requests.cpu: .*empty disjunction"
}

"refuses memory that is not a quantity": test.#AddonRender & {
	addon: ".."
	parameter: resources: limits: memory: "1 GB"
	expect: error: =~"parameter.resources.limits.memory: invalid value \"1 GB\""
}

"installWith defaults to vela, and vela without chartInstall installs nothing": test.#AddonRender & {
	addon: ".."
	parameter: {chartInstall: false, installWith: "vela"}
	expect: components: "cert-manager"?: _|_
}

"accepts a dotted releaseName": test.#AddonRender & {
	addon: ".."
	parameter: releaseName: "certs.team-a"
	expect: components: "cert-manager": properties: release: name: "certs.team-a"
}

"refuses a releaseName with an empty label": test.#AddonRender & {
	addon: ".."
	parameter: releaseName: "a..b"
	expect: error:          =~#"invalid value "a\.\.b""#
}

"refuses a releaseName with a label starting with a hyphen": test.#AddonRender & {
	addon: ".."
	parameter: releaseName: "a.-b"
	expect: error:          =~#"invalid value "a\.-b""#
}

"refuses a releaseName longer than Helm's 53 characters": test.#AddonRender & {
	addon: ".."
	parameter: releaseName: "a234567890123456789012345678901234567890123456789012.b"
	expect: error:          =~#"invalid value "a234567890123456789012345678901234567890123456789012\.b""#
}
