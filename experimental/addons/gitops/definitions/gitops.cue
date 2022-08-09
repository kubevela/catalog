gitops: {
	annotations: {}
	attributes: workload: definition: {
		apiVersion: "apps/v1"
		kind: "Deployment"
	}
	description: "KubeVela addon for implementing GitOps for continuous deployment using either fluxcd or argocd"
	type: "component"
	labels: {}
}

template: {
	output: {
		if parameter.agent == "fluxcd" {
			apiVersion: "source.toolkit.fluxcd.io/v1beta2"
		}
		if parameter.agent == "argocd" {
			apiVersion: "argoproj.io/v1alpha1"
		}
		kind: ""
		metadata: {
			name: context.name
			namespace: context.namespace
		}
		spec: {
			interval: parameter.pullInterval
			sourceRef: {
				if parameter.repoType == "git" {
					kind: "GitRepository"
				}
				if parameter.repoType == "oss" {
					kind: "Bucket"
				}
				name: context.name
				namespace: context.namespace
			}
			path: parameter.paths.glob
			suspend: parameter.suspend
			prune: parameter.prune
			pruneTimeout: parameter.pruneTimeout
			force: parameter.force
		}
	}

	parameter: {

		// +usage=The gitops agent to be used
		agent: *"fluxcd" | "argocd"

		namespace: string

		repoType: *"git" | "oss"

		imageRepository?: {
			// +usage=The image url
			image: string
			// +usage=The name of the secret containing authentication credentials
			secretRef?: string
			// +usage=Policy gives the particulars of the policy to be followed in selecting the most recent image.
		}

		// +usage=The interval at which to check for repository/bucket and release updates, default to 5m
		pullInterval: *"5m" | string

		// +usage=The Git or Helm repository URL, OSS endpoint, accept HTTP/S or SSH address as git url,
		url: string

		// +usage=The name of the secret containing authentication credentials
		secretRef?: string

		// +usage=The timeout for operations like download index/clone repository, optional
		timeout?: string

		git?: {
			// +usage=The Git reference to checkout and monitor for changes, defaults to master branch
			branch: string
			// +usage=Determines which git client library to use. Defaults to GitHub, it will pick go-git. AzureDevOps will pick libgit2.
			provider?: *"GitHub" | "AzureDevOps"
		}

		oss?: {
			// +usage=The bucket's name, required if repoType is oss
			bucketName: string
			// +usage="generic" for Minio, Amazon S3, Google Cloud Storage, Alibaba Cloud OSS, "aws" for retrieve credentials from the EC2 service when credentials not specified, default "generic"
			provider: *"generic" | "aws"
			// +usage=The bucket region, optional
			region?: string
		}

		paths: {
			// +usage=Read all YAML files from this directory or subdirectory, depending on how it is specified
			glob: *"/**/*.{yaml,yml,json}" | string
		}

		// +usage=Determines whether previously applied objects should be pruned (deleted)
		prune: *true | bool

		// +usage=Determines whether to wait for all resources to be fully deleted after pruning, and if so, how long to wait.
		pruneTimeout: *"3600s" | string

		//+usage=This flag tells the controller to suspend subsequent kustomize executions, it does not apply to already started executions. Defaults to false.
		suspend: *false | bool

		//+usage=Force instructs the controller to recreate resources when patching fails due to an immutable field change.
		force: *false | bool
	}

	outputs: {}
}
