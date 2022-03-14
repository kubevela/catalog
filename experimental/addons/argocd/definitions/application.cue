"argo-app": {
	annotations: {}
	attributes: workload: {
		type: "autodetects.core.oam.dev"
	}
	description: "Argocd-application is a definition of application resource."
	labels: {}
	type: "component"
}

template: {

	parameter: {
		name:    string
		project: *"default" | string
		dest: {
			namespace: string
			server?:   *"https://kubernetes.default.svc" | string
		}
		source: {
			path:           string
			repoURL:        string
			targetRevision: string
		}

		#operation: {
			info?: [...{
				name?: string
				value: string
			}]
			initiatedBy?: {
				automated?: bool
				username?:  string
			}
			retry?: {
				backoff?: {
					duration?:    string
					factor?:      string
					maxDuration?: string
				}
				limit?: int
			}
			sync?: {
				dryRun?: bool
				manifests?: [...string]
				prune?: bool
				resources: [...{group?: string, kind: string, name: string, namespace?: string}]
				revision?: string
				source?: {
					chart?: string
					directory?: {
						exclude?: string
						include?: string
						jsonnet?: {
							exVars: [...{name: string, value: string}]
							libs: [...string]
							tlas: [...{code?: bool, name: string, value: string}]
						}
						resource?: bool
					}
					helm?: {
						fileParameters?: [...{name?: string, path?: string}]
						parameters?: [...{forceString?: bool, name?: string, value?: string}]
						passCredentials?: bool
						releaseName?:     string
						valueFiles?: [...string]
						values?:  string
						version?: string
					}
					ksonnet?: {
						environment?: string
						parameters?: [...{compononet?: string, name: string, value: string}]
					}
					kustomize?: {
						commonAnnotations?: {...}
						commonLabels?: {...}
						forceCommonAnnotations?: bool
						forceCommonLabels?:      bool
						images?: [...string]
						namePrefix?: string
						nameSuffix?: string
						version?:    string
					}
					path?: string
					plugin?: {
						env?: [...{name: string, value: string}]
						name?: string
					}
					repoURL:         string
					targetRevision?: string
				}
				syncOptions?: [...string]
				syncStrategy: {
					apply: {
						force?: bool
					}
					hook: {
						force?: bool
					}
				}
			}
		}

		operation?: #operation
	}

	output: {
		apiVersion: "argoproj.io/v1alpha1"
		kind:       "Application"
		metadata: {
			name:      parameter.name
			namespace: "argocd"
		}
		if parameter.operation != _|_ {
			operation: parameter.operation
		}
		spec: {
			destination: {
				namespace: parameter.dest.namespace
				server:    parameter.dest.server
			}
			project: parameter.project
			source: {
				path:           parameter.source.path
				repoURL:        parameter.source.repoURL
				targetRevision: parameter.source.targetRevision
			}
		}
	}

}
