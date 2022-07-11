helm: {
	attributes: {
		workload: type: "autodetects.core.oam.dev"
		status: {
			healthPolicy: #"""
				isHealth: len(context.outputs.release.status.conditions) != 0 && context.outputs.release.status.conditions[0]["status"]=="True"
				"""#
			customStatus: #"""
					repoMessage:    *"" | string
					releaseMessage: *"" | string
					if context.output.status == _|_ {
						repoMessage:    "Fetching repository"
						releaseMessage: "Wating repository ready"
					}
					if context.output.status != _|_ {
						repoStatus: context.output.status
						if len(repoStatus.conditions) == 0 || repoStatus.conditions[0]["type"] != "Ready" {
							repoMessage: "Fetch repository fail"
						}
						if len(repoStatus.conditions) != 0 && repoStatus.conditions[0]["type"] == "Ready" {
							repoMessage: "Fetch repository successfully"
						}

						if context.outputs.release.status == _|_ {
							releaseMessage: "Creating helm release"
						}
						if context.outputs.release.status != _|_ {
							if context.outputs.release.status.conditions[0]["message"] == "Release reconciliation succeeded" {
								releaseMessage: "Create helm release successfully"
							}
							if context.outputs.release.status.conditions[0]["message"] != "Release reconciliation succeeded" {
								releaseBasicMessage: "Delivery helm release in progress, message: " + context.outputs.release.status.conditions[0]["message"]
								if len(context.outputs.release.status.conditions) == 1 {
									releaseMessage: releaseBasicMessage
								}
								if len(context.outputs.release.status.conditions) > 1 {
									releaseMessage: releaseBasicMessage + ", " + context.outputs.release.status.conditions[1]["message"]
								}
							}
						}
					}
					message: repoMessage + ", " + releaseMessage
				"""#
		}
	}
	description: "helm release is a group of K8s resources from either git repository or helm repo"
	type:        "component"
}

template: {
	output: {
		apiVersion: "source.toolkit.fluxcd.io/v1beta2"
		metadata: {
			name: context.name
		}
		if parameter.repoType == "git" {
			kind: "GitRepository"
			spec: {
				url: parameter.url
				if parameter.git.branch != _|_ {
					ref: branch: parameter.git.branch
				}
				_secret
				_sourceCommonArgs
			}
		}
		if parameter.repoType == "oss" {
			kind: "Bucket"
			spec: {
				endpoint:   parameter.url
				bucketName: parameter.oss.bucketName
				provider:   parameter.oss.provider
				if parameter.oss.region != _|_ {
					region: parameter.oss.region
				}
				_secret
				_sourceCommonArgs
			}
		}
		if parameter.repoType == "helm" || parameter.repoType == "oci" {
			kind: "HelmRepository"
			spec: {
				url: parameter.url
				if parameter.repoType == "oci" {
					type: "oci"
				}
				_secret
				_sourceCommonArgs
			}
		}
	}

	outputs: release: {
		apiVersion: "helm.toolkit.fluxcd.io/v2beta1"
		kind:       "HelmRelease"
		metadata: {
			name: context.name
		}
		spec: {
			timeout:  parameter.installTimeout
			interval: parameter.pullInterval
			chart: {
				spec: {
					chart:   parameter.chart
					version: parameter.version
					sourceRef: {
						if parameter.repoType == "git" {
							kind: "GitRepository"
						}
						if parameter.repoType == "helm" || parameter.repoType == "oci" {
							kind: "HelmRepository"
						}
						if parameter.repoType == "oss" {
							kind: "Bucket"
						}
						name: context.name
					}
					interval: parameter.interval
					if parameter["valuesFiles"] != _|_ {
						valuesFiles: parameter["valuesFiles"]
					}
				}
			}
			if parameter.targetNamespace != _|_ {
				targetNamespace: parameter.targetNamespace
			}
			if parameter.releaseName != _|_ {
				releaseName: parameter.releaseName
			}
			if parameter.values != _|_ {
				values: parameter.values
			}
			install: {
				remediation: {
					retries: parameter.retries
				}
			}
			upgrade: {
				remediation: {
					retries: parameter.retries
				}
			}
		}
	}

	_secret: {
		if parameter.secretRef != _|_ {
			if parameter.secretRef != "" {
				secretRef: {
					name: parameter.secretRef
				}
			}
		}
	}

	_sourceCommonArgs: {
		interval: parameter.pullInterval
		if parameter.timeout != _|_ {
			timeout: parameter.timeout
		}
	}

	parameter: {
		repoType: *"helm" | "git" | "oss" | "oci"
		// +usage=The interval at which to check for repository/bucket and release updates, default to 5m
		pullInterval: *"5m" | string
		// +usage=The  Interval at which to reconcile the Helm release, default to 30s
		interval: *"30s" | string
		// +usage=The Git or Helm repository URL, OSS endpoint, accept HTTP/S or SSH address as git url,
		url: string
		// +usage=The name of the secret containing authentication credentials
		secretRef?: string
		// +usage=The timeout for operations like download index/clone repository, optional
		timeout?: string
		// +usage=The timeout for operation `helm install`, optional
		installTimeout: *"10m" | string

		git?: {
			// +usage=The Git reference to checkout and monitor for changes, defaults to master branch
			branch: string
		}
		oss?: {
			// +usage=The bucket's name, required if repoType is oss
			bucketName: string
			// +usage="generic" for Minio, Amazon S3, Google Cloud Storage, Alibaba Cloud OSS, "aws" for retrieve credentials from the EC2 service when credentials not specified, default "generic"
			provider: *"generic" | "aws"
			// +usage=The bucket region, optional
			region?: string
		}
		// +usage=Alternative list of values files to use as the chart values (values.yaml is not included by default), expected to be a relative path in the SourceRef.Values files are merged in the order of this list with the last file overriding the first.
		valuesFiles?: [...string]

		// +usage=1.The relative path to helm chart for git/oss source. 2. chart name for helm resource 3. relative path for chart package(e.g. ./charts/podinfo-1.2.3.tgz)
		chart: string
		// +usage=Chart version
		version: *"*" | string
		// +usage=The namespace for helm chart, optional
		targetNamespace?: string
		// +usage=The release name
		releaseName?: string
		// +usage=Retry times when install/upgrade fail.
		retries: *3 | int
		// +usage=Chart values
		values?: #nestedmap
	}

	#nestedmap: {
		...
	}
}
