parameter: {
	// +usage=Namespace to install cert-manager into
	// +ui:label=Namespace
	namespace: *"cert-manager" | string
	// +usage=Deploy to the named clusters. Leave empty to deploy to every cluster
	// +ui:optionsFrom=clusters
	// +ui:label=Clusters
	clusters?: [...string]
	// +usage=Install a global policy that lets a namespace choose the issuer for its certificates, with the annotation cert-manager.oam.dev/cluster-issuer or cert-manager.oam.dev/issuer. Needs global policies enabled in vela-core
	// +ui:label=Issuer per Namespace
	namespaceIssuers: *false | bool

	// 2.x parameters, ignored: vela addon upgrade carries them forward and cannot unset one.
	// +usage=Ignored since 3.0.0. Create issuers with the issuer component
	// +ui:hidden
	// +ui:label=DNS01
	dns01?: {...}
	// +usage=Ignored since 3.0.0
	// +ui:hidden
	// +ui:label=Staging
	staging?: bool
	// +usage=Ignored since 3.0.0. The chart's CRDs are always installed, and kept unless keepCRDs is false
	// +ui:hidden
	// +ui:label=Install CRDs
	installCRDs?: bool
	// +usage=Ignored since 3.0.0. The chart's CRDs are upgraded with it
	// +ui:hidden
	// +ui:label=Upgrade CRD
	upgradeCRD?: bool
	// +usage=Replicas of each cert-manager Deployment: the controller, the webhook and the CA injector
	// +ui:label=Replicas
	replicas: *1 | int & >=1
	// +usage=Keep every cert-manager Deployment available through node drains, with a PodDisruptionBudget each. Needs replicas of 2 or more
	// +ui:label=High Availability
	highAvailability: *false | bool
	// +usage=Expose cert-manager's metrics to Prometheus with a ServiceMonitor. Needs the Prometheus operator's CRDs
	// +ui:label=Monitoring
	monitoring: *false | bool
	// +usage=Keep cert-manager's CRDs, and so every certificate and issuer, when the addon is disabled
	// +ui:advanced
	// +ui:label=Keep CRDs
	keepCRDs: *true | bool

	// +usage=CPU and memory for each cert-manager pod
	// +ui:advanced
	// +ui:section=Pods
	// +ui:label=Resources
	resources?: {
		// +usage=What each pod is guaranteed
		// +ui:label=Requests
		requests?: {
			// +usage=CPU, in cores or millicores
			// +ui:placeholder=10m
			cpu?: string | number
			// +usage=Memory, in bytes or with a suffix
			// +ui:placeholder=64Mi
			memory?: string
		}
		// +usage=The most each pod may use
		// +ui:label=Limits
		limits?: {
			// +usage=CPU, in cores or millicores
			// +ui:placeholder=100m
			cpu?: string | number
			// +usage=Memory, in bytes or with a suffix
			// +ui:placeholder=256Mi
			memory?: string
		}
	}
	// +usage=Run cert-manager only on nodes with these labels
	// +ui:advanced
	// +ui:section=Pods
	// +ui:label=Node Selector
	nodeSelector?: [string]: string
	// +usage=Taints cert-manager's pods tolerate, so they can run on nodes kept for them
	// +ui:advanced
	// +ui:section=Pods
	// +ui:label=Tolerations
	tolerations?: [...{
		// +usage=Taint key; leave empty with operator Exists to tolerate every taint
		key?: string
		// +usage=Equal matches the taint's value; Exists matches any value
		operator: *"Equal" | "Exists"
		// +usage=Taint value, with operator Equal
		value?: string
		// +usage=Taint effect to tolerate; leave empty for every effect
		effect?: "NoSchedule" | "PreferNoSchedule" | "NoExecute"
		// +usage=With effect NoExecute, how long the pod stays on a node after the taint appears
		tolerationSeconds?: int
	}]
	// +usage=Kubernetes affinity rules for cert-manager's pods, as in a pod spec
	// +ui:advanced
	// +ui:section=Pods
	// +ui:label=Affinity
	affinity?: {...}
	// +usage=PriorityClass for cert-manager's pods
	// +ui:advanced
	// +ui:section=Pods
	// +ui:label=Priority Class
	priorityClassName?: string
	// +usage=Registry to pull cert-manager's images from instead of quay.io, such as a mirror
	// +ui:advanced
	// +ui:section=Pods
	// +ui:label=Image Registry
	// +ui:placeholder=registry.example.com
	imageRegistry?: string
	// +usage=Secrets in cert-manager's namespace holding the credentials to pull its images
	// +ui:advanced
	// +ui:section=Pods
	// +ui:label=Image Pull Secrets
	imagePullSecrets?: [...string]

	// +usage=cert-manager feature gates to turn on or off, such as ServerSideApply: true
	// +ui:advanced
	// +ui:section=cert-manager
	// +ui:label=Feature Gates
	featureGates?: [string]: bool
	// +usage=DNS servers to check DNS01 challenges against instead of the cluster's, such as 1.1.1.1:53
	// +ui:advanced
	// +ui:section=cert-manager
	// +ui:label=DNS01 Nameservers
	dns01Nameservers?: [...string]
	// +usage=Delete a certificate's Secret when the certificate is deleted
	// +ui:advanced
	// +ui:section=cert-manager
	// +ui:label=Certificate Owns Secret
	certificateOwnerRef: *false | bool

	// --- shared install parameters: synced from hack/addon-install/parameter.cue, do not edit ---
	// +usage=Install the chart. Set false for the definitions alone, beside a tool you already run another way
	// +ui:advanced
	// +ui:section=Install
	// +ui:label=Install the Chart
	chartInstall: *true | bool
	// +usage=What installs the chart: vela (the built-in helmchart component, the default), flux (a HelmRelease; needs Flux 2.3 or later running) or argo (an Argo CD Application; needs Argo CD running)
	// +ui:advanced
	// +ui:section=Install
	// +ui:label=Install With
	installWith?: "vela" | "flux" | "argo"
	// +usage=Helm release to install or take over, if not the addon's own name. Upgrading from an addon that installed through the fluxcd addon, name its release as the addon's namespace and name joined by a hyphen, e.g. vela-system-cert-manager
	// +ui:advanced
	// +ui:section=Install
	// +ui:label=Release Name
	releaseName?: =~"^[a-z0-9]([-a-z0-9.]{0,51}[a-z0-9])?$"
	// +usage=Override the pinned chart, at your own risk: version takes another chart version, repoURL a mirror of the chart repository
	// +ui:advanced
	// +ui:section=Install
	// +ui:label=Chart Override
	chart?: {
		// +usage=Chart version to install instead of the one the addon pins, at or above the addon's minimum and, where the addon offers majors, within the chosen one
		// +ui:placeholder=The version the addon pins
		// +ui:label=Chart Version
		version?: string
		// +usage=Chart repository to install from instead of the chart's own, such as a mirror
		// +ui:label=Repository URL
		// +ui:placeholder=https://charts.example.com/mirror
		repoURL?: string
	}
	// +usage=Free-form override of the chart's values, applied over what the parameters above set. Nothing checks them, so use it at your own risk
	// +ui:hidden
	// +ui:label=Overrides
	values?: {...}
	// --- end shared install parameters ---
}
