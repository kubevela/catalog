import "encoding/json"

"helm": {
	annotations: {}
	attributes: workload: {
		type: "autodetects.core.oam.dev"
	}
	description: "An argocd-based helm support."
	labels: {}
	type:      "component"
	namespace: "vela-system"
}

template: {

	parameter: {

		repoType: *"helm" | "git"
		// +usage=The interval at which to check for repository/bucket and release updates, default to 5m
		//  pullInterval: *"5m" | string
		// +usage=The  Interval at which to reconcile the Helm release, default to 30s
		//  interval: *"30s" | string
		// +usage=The Git or Helm repository URL, OSS endpoint, accept HTTP/S or SSH address as git url,
		url: string
		// +usage=The name of the secret containing authentication credentials
		secretRef?: string
		// +usage=The timeout for operations like download index/clone repository, optional
		//  timeout?: string
		// +usage=The timeout for operation `helm install`, optional
		//  installTimeout: *"10m" | string

		git?: {
			// +usage=The Git reference to checkout and monitor for changes, defaults to master branch
			branch: string
		}
		//  oss?: {
		//   // +usage=The bucket's name, required if repoType is oss
		//   bucketName: string
		//   // +usage="generic" for Minio, Amazon S3, Google Cloud Storage, Alibaba Cloud OSS, "aws" for retrieve credentials from the EC2 service when credentials not specified, default "generic"
		//   provider: *"generic" | "aws"
		//   // +usage=The bucket region, optional
		//   region?: string
		//  }

		// +usage=1.The relative path to helm chart for git/oss source. 2. chart name for helm resource 3. relative path for chart package(e.g. ./charts/podinfo-1.2.3.tgz)
		chart: string
		// +usage=Chart version
		version: *"*" | string
		// +usage=The namespace for helm chart, optional
		targetNamespace?: string
		// +usage=The release name
		releaseName?: string
		// +usage=Chart values
		values?: #nestedmap
	}

	#nestedmap: {
		...
	}

	output: {
		apiVersion: "argoproj.io/v1alpha1"
		kind:       "Application"
		metadata: {
			name:      context.name
			namespace: "argocd"
			finalizers: ["resources-finalizer.argocd.argoproj.io"]
		}

		spec: {
			destination: {
				if parameter.targetNamespace != _|_ {
					namespace: parameter.targetNamespace
				}
				if parameter.targetNamespace == _|_ {
					namespace: context.namespace
				}
				server: "https://kubernetes.default.svc"
			}
			project: "default"
			source: {
				repoURL: parameter.url
				if parameter.repoType == "git" {
					path: parameter.chart
					if parameter.git != _|_ {
						targetRevision: parameter.git.branch
					}
					if parameter.git == _|_ {
						targetRevision: "HEAD"
					}
				}

				if parameter.repoType == "helm" {
					chart:          parameter.chart
					targetRevision: parameter.version
					helm: {
						skipCrds: false
						if parameter.releaseName != _|_ {
							releaseName: parameter.releaseName
						}
						if parameter.values != _|_ {
							values: json.Marshal(parameter.values)
						}
					}
				}
			}
			syncPolicy: {
				automated: {
					// Prune specifies whether to delete resources from the cluster that are not found in the sources anymore as part of automated sync (default: false)
					prune: false
					// SelfHeal specifes whether to revert resources back to their desired state upon modification in the cluster (default: false)
					selfHeal: false
					// AllowEmpty allows apps have zero live resources (default: false)
					allowEmpty: false
				}
				//    syncOptions:{}
				retry: {
					limit: 10
					backoff: {
						// Duration is the amount to back off. Default unit is seconds, but could also be a duration (e.g. "2m", "1h")
						duration: "5s"
						// Factor is a factor to multiply the base duration after each failed retry
						factor: 2
						// MaxDuration is the maximum amount of time allowed for the backoff strategy
						maxDuration: "3m"
					}
				}
			}
		}
	}
}
