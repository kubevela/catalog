parameter: {
	// +usage=Crossplane major version: 2, or 1 for platforms not yet on 2. The definitions for each differ
	// +ui:label=Crossplane Major Version
	major: *2 | 1
	// +usage=Namespace Crossplane is installed into
	// +ui:label=Namespace
	namespace: *"crossplane-system" | string

	// +usage=Replicas of the Crossplane Deployment
	// +ui:label=Replicas
	replicas: *1 | int & >=1
	// +usage=Expose Crossplane's metrics on its pods, for Prometheus to scrape
	// +ui:label=Monitoring
	monitoring: *false | bool
	// +usage=Extra flags for Crossplane, such as --enable-realtime-compositions or --debug
	// +ui:advanced
	// +ui:label=Arguments
	args?: [...string]

	// +usage=CPU and memory for the Crossplane pod
	// +ui:advanced
	// +ui:section=Pods
	// +ui:label=Resources
	resources?: {
		// +usage=What the pod is guaranteed
		// +ui:label=Requests
		requests?: {
			// +usage=CPU, in cores (0.5) or millicores (500m)
			// +ui:placeholder=100m
			cpu?: string & =~"^[0-9]+(\\.[0-9]+)?m?$" | number & >=0
			// +usage=Memory, in bytes or with a suffix such as Mi or Gi
			// +ui:placeholder=256Mi
			memory?: string & =~"^[0-9]+(\\.[0-9]+)?([KMGTPE]i|[kMGTPE])?$"
		}
		// +usage=The most the pod may use
		// +ui:label=Limits
		limits?: {
			// +usage=CPU, in cores (0.5) or millicores (500m)
			// +ui:placeholder=500m
			cpu?: string & =~"^[0-9]+(\\.[0-9]+)?m?$" | number & >=0
			// +usage=Memory, in bytes or with a suffix such as Mi or Gi
			// +ui:placeholder=1024Mi
			memory?: string & =~"^[0-9]+(\\.[0-9]+)?([KMGTPE]i|[kMGTPE])?$"
		}
	}
	// +usage=Run Crossplane only on nodes with these labels
	// +ui:advanced
	// +ui:section=Pods
	// +ui:label=Node Selector
	nodeSelector?: [string]: string
	// +usage=Taints Crossplane's pods tolerate, so they can run on nodes kept for them
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
	// +usage=Kubernetes affinity rules for Crossplane's pods, as in a pod spec
	// +ui:advanced
	// +ui:section=Pods
	// +ui:label=Affinity
	affinity?: {
		// +usage=Nodes the pods may run on
		// +ui:label=Node Affinity
		nodeAffinity?: {
			// +usage=Node rules that must hold; a node matching any one term will do
			// +ui:label=Required
			requiredDuringSchedulingIgnoredDuringExecution?: {
				// +usage=Terms, any one of which a node must match
				// +ui:label=Node Selector Terms
				nodeSelectorTerms: [...{
					// +usage=Node labels that must match
					// +ui:label=Match Expressions
					matchExpressions?: [...{
						// +usage=Label to match
						key: string
						// +usage=How the label is matched
						operator: "In" | "NotIn" | "Exists" | "DoesNotExist" | "Gt" | "Lt"
						// +usage=Values for In and NotIn, or one number for Gt and Lt
						values?: [...string]
					}]
					// +usage=Node fields that must match, such as metadata.name
					// +ui:label=Match Fields
					matchFields?: [...{
						// +usage=Label to match
						key: string
						// +usage=How the label is matched
						operator: "In" | "NotIn" | "Exists" | "DoesNotExist" | "Gt" | "Lt"
						// +usage=Values for In and NotIn, or one number for Gt and Lt
						values?: [...string]
					}]
				}]
			}
			// +usage=Node rules the scheduler tries to meet, each with a weight
			// +ui:label=Preferred
			preferredDuringSchedulingIgnoredDuringExecution?: [...{
				// +usage=Weight, from 1 to 100
				weight: int & >=1 & <=100
				// +usage=The node rule
				preference: {
					// +usage=Node labels that must match
					// +ui:label=Match Expressions
					matchExpressions?: [...{
						// +usage=Label to match
						key: string
						// +usage=How the label is matched
						operator: "In" | "NotIn" | "Exists" | "DoesNotExist" | "Gt" | "Lt"
						// +usage=Values for In and NotIn, or one number for Gt and Lt
						values?: [...string]
					}]
					// +usage=Node fields that must match, such as metadata.name
					// +ui:label=Match Fields
					matchFields?: [...{
						// +usage=Label to match
						key: string
						// +usage=How the label is matched
						operator: "In" | "NotIn" | "Exists" | "DoesNotExist" | "Gt" | "Lt"
						// +usage=Values for In and NotIn, or one number for Gt and Lt
						values?: [...string]
					}]
				}
			}]
		}
		// +usage=Pods to run alongside
		// +ui:label=Pod Affinity
		podAffinity?: {
			// +usage=Rules that must hold to schedule a pod
			// +ui:label=Required
			requiredDuringSchedulingIgnoredDuringExecution?: [...{
				// +usage=Pods to place relative to
				// +ui:label=Label Selector
				labelSelector?: {
					// +usage=Labels the pods must have
					// +ui:label=Match Labels
					matchLabels?: [string]: string
					// +usage=Label rules the pods must meet
					// +ui:label=Match Expressions
					matchExpressions?: [...{
						// +usage=Label to match
						key: string
						// +usage=How the label is matched
						operator: "In" | "NotIn" | "Exists" | "DoesNotExist"
						// +usage=Values for In and NotIn
						values?: [...string]
					}]
				}
				// +usage=Node label that defines the domain, such as kubernetes.io/hostname or topology.kubernetes.io/zone
				// +ui:label=Topology Key
				topologyKey: string
				// +usage=Namespaces of those pods; leave empty for this pod's own
				namespaces?: [...string]
			}]
			// +usage=Rules the scheduler tries to meet, each with a weight
			// +ui:label=Preferred
			preferredDuringSchedulingIgnoredDuringExecution?: [...{
				// +usage=Weight, from 1 to 100
				weight: int & >=1 & <=100
				// +usage=The rule
				// +ui:label=Rule
				podAffinityTerm: {
					// +usage=Pods to place relative to
					// +ui:label=Label Selector
					labelSelector?: {
						// +usage=Labels the pods must have
						// +ui:label=Match Labels
						matchLabels?: [string]: string
						// +usage=Label rules the pods must meet
						// +ui:label=Match Expressions
						matchExpressions?: [...{
							// +usage=Label to match
							key: string
							// +usage=How the label is matched
							operator: "In" | "NotIn" | "Exists" | "DoesNotExist"
							// +usage=Values for In and NotIn
							values?: [...string]
						}]
					}
					// +usage=Node label that defines the domain, such as kubernetes.io/hostname or topology.kubernetes.io/zone
					// +ui:label=Topology Key
					topologyKey: string
					// +usage=Namespaces of those pods; leave empty for this pod's own
					namespaces?: [...string]
				}
			}]
		}
		// +usage=Pods to keep away from, such as other replicas
		// +ui:label=Pod Anti-Affinity
		podAntiAffinity?: {
			// +usage=Rules that must hold to schedule a pod
			// +ui:label=Required
			requiredDuringSchedulingIgnoredDuringExecution?: [...{
				// +usage=Pods to place relative to
				// +ui:label=Label Selector
				labelSelector?: {
					// +usage=Labels the pods must have
					// +ui:label=Match Labels
					matchLabels?: [string]: string
					// +usage=Label rules the pods must meet
					// +ui:label=Match Expressions
					matchExpressions?: [...{
						// +usage=Label to match
						key: string
						// +usage=How the label is matched
						operator: "In" | "NotIn" | "Exists" | "DoesNotExist"
						// +usage=Values for In and NotIn
						values?: [...string]
					}]
				}
				// +usage=Node label that defines the domain, such as kubernetes.io/hostname or topology.kubernetes.io/zone
				// +ui:label=Topology Key
				topologyKey: string
				// +usage=Namespaces of those pods; leave empty for this pod's own
				namespaces?: [...string]
			}]
			// +usage=Rules the scheduler tries to meet, each with a weight
			// +ui:label=Preferred
			preferredDuringSchedulingIgnoredDuringExecution?: [...{
				// +usage=Weight, from 1 to 100
				weight: int & >=1 & <=100
				// +usage=The rule
				// +ui:label=Rule
				podAffinityTerm: {
					// +usage=Pods to place relative to
					// +ui:label=Label Selector
					labelSelector?: {
						// +usage=Labels the pods must have
						// +ui:label=Match Labels
						matchLabels?: [string]: string
						// +usage=Label rules the pods must meet
						// +ui:label=Match Expressions
						matchExpressions?: [...{
							// +usage=Label to match
							key: string
							// +usage=How the label is matched
							operator: "In" | "NotIn" | "Exists" | "DoesNotExist"
							// +usage=Values for In and NotIn
							values?: [...string]
						}]
					}
					// +usage=Node label that defines the domain, such as kubernetes.io/hostname or topology.kubernetes.io/zone
					// +ui:label=Topology Key
					topologyKey: string
					// +usage=Namespaces of those pods; leave empty for this pod's own
					namespaces?: [...string]
				}
			}]
		}
	}
	// +usage=PriorityClass for Crossplane's pods
	// +ui:advanced
	// +ui:section=Pods
	// +ui:label=Priority Class
	priorityClassName?: string
	// +usage=Registry to pull Crossplane's image from instead of xpkg.crossplane.io, such as a mirror
	// +ui:advanced
	// +ui:section=Pods
	// +ui:label=Image Registry
	// +ui:placeholder=registry.example.com
	imageRegistry?: string
	// +usage=Secrets in Crossplane's namespace holding the credentials to pull its image and packages
	// +ui:advanced
	// +ui:section=Pods
	// +ui:label=Image Pull Secrets
	imagePullSecrets?: [...string]

	// +usage=Largest the package cache may grow
	// +ui:advanced
	// +ui:section=Packages
	// +ui:label=Package Cache Size
	// +ui:placeholder=20Mi
	packageCacheSize?: string
	// +usage=ConfigMap in Crossplane's namespace with the CA bundle of a private package registry
	// +ui:advanced
	// +ui:section=Packages
	// +ui:label=Registry CA Bundle
	registryCaBundle?: {
		// +usage=Name of the ConfigMap
		name: string
		// +usage=Key in the ConfigMap that holds the bundle
		key: string
	}
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
installWith: *"vela" | "flux" | "argo"
// +usage=Helm release to install or take over, if not the addon's own name. Upgrading from an addon that installed through the fluxcd addon, name its release as the addon's namespace and name joined by a hyphen, e.g. vela-system-cert-manager
// +ui:advanced
// +ui:section=Install
// +ui:label=Release Name
releaseName?: =~"^[a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*$" & =~"^.{1,53}$"
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
