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
		// Argocd Application is a definition of Application resource.
		Application: {
			metadata:   #ObjectMeta
			spec:       #ApplicationSpec
			operation?: null | #Operation
		}
		// ObjectMeta is metadata that all persisted resources must have, which includes all objects
		// users must create.
		#ObjectMeta: {
			name:                        string
			namespace:                   *"argocd" | string
			deletionGracePeriodSeconds?: null | int64
			labels?: {
				[string]: string
			}
			annotations?: {
				[string]: string
			}
			finalizers?: [...string]
			clusterName?: string
		}

		// ApplicationSpec represents desired application state. Contains link to repository with application definition and additional parameters link definition revision.
		#ApplicationSpec: {
			// Source is a reference to the location of the application's manifests or chart
			source: #ApplicationSource

			// Destination is a reference to the target Kubernetes server and namespace
			destination: #ApplicationDestination

			// Project is a reference to the project this application belongs to.
			// The empty string means that application belongs to the 'default' project.
			project: string

			// SyncPolicy controls when and how a sync will be performed
			syncPolicy?: null | #SyncPolicy

			// IgnoreDifferences is a list of resources and their fields which should be ignored during comparison
			ignoreDifferences?: [...#ResourceIgnoreDifferences]

			// Info contains a list of information (URLs, email addresses, and plain text) that relates to the application
			info?: [...#Info]

			// RevisionHistoryLimit limits the number of items kept in the application's revision history, which is used for informational purposes as well as for rollbacks to previous versions.
			// This should only be changed in exceptional circumstances.
			// Setting to zero will store no history. This will reduce storage used.
			// Increasing will increase the space used to store the history, so we do not recommend increasing it.
			// Default is 10.
			revisionHistoryLimit?: null | int64
		}

		// ApplicationSource contains all required information about the source of an application
		#ApplicationSource: {
			// RepoURL is the URL to the repository (Git or Helm) that contains the application manifests
			repoURL: string

			// Path is a directory path within the Git repository, and is only valid for applications sourced from Git.
			path?: string

			// TargetRevision defines the revision of the source to sync the application to.
			// In case of Git, this can be commit, tag, or branch. If omitted, will equal to HEAD.
			// In case of Helm, this is a semver tag for the Chart's version.
			targetRevision?: string

			// Helm holds helm specific options
			helm?: null | #ApplicationSourceHelm

			// Kustomize holds kustomize specific options
			kustomize?: null | #ApplicationSourceKustomize

			// Ksonnet holds ksonnet specific options
			ksonnet?: null | #ApplicationSourceKsonnet

			// Directory holds path/directory specific options
			directory?: null | #ApplicationSourceDirectory

			// ConfigManagementPlugin holds config management plugin specific options
			plugin?: null | #ApplicationSourcePlugin

			// Chart is a Helm chart name, and must be specified for applications sourced from a Helm repo.
			chart?: string
		}

		// ApplicationDestination holds information about the application's destination
		#ApplicationDestination: {
			namespace: *"default" | string
			server:    *"https://kubernetes.default.svc" | string
		}

		#SyncOptions: [...string]

		// SyncPolicy controls when a sync will be performed in response to updates in git
		#SyncPolicy: {
			// Automated will keep an application synced to the target revision
			automated?: null | #SyncPolicyAutomated

			// Options allow you to specify whole app sync-options
			syncOptions?: #SyncOptions

			// Retry controls failed sync retry behavior
			retry?: null | #RetryStrategy
		}

		// RetryStrategy contains information about the strategy to apply when a sync failed
		#RetryStrategy: {
			// Limit is the maximum number of attempts for retrying a failed sync. If set to 0, no retries will be performed.
			limit?: int64

			// Backoff controls how to backoff on subsequent retries of failed syncs
			backoff?: null | #Backoff
		}

		// Backoff is the backoff strategy to use on subsequent retries for failing syncs
		#Backoff: {
			// Duration is the amount to back off. Default unit is seconds, but could also be a duration (e.g. "2m", "1h")
			duration?: string

			// Factor is a factor to multiply the base duration after each failed retry
			factor?: null | int64

			// MaxDuration is the maximum amount of time allowed for the backoff strategy
			maxDuration?: string
		}

		// SyncPolicyAutomated controls the behavior of an automated sync
		#SyncPolicyAutomated: {
			// Prune specifies whether to delete resources from the cluster that are not found in the sources anymore as part of automated sync (default: false)
			prune?: bool

			// SelfHeal specifes whether to revert resources back to their desired state upon modification in the cluster (default: false)
			selfHeal?: bool

			// AllowEmpty allows apps have zero live resources (default: false)
			allowEmpty?: bool
		}

		// ResourceIgnoreDifferences contains resource filter and list of json paths which should be ignored during comparison with live state.
		#ResourceIgnoreDifferences: {
			group?:     string
			kind:       string
			name?:      string
			namespace?: string
			jsonPointers?: [...string]
			jqPathExpressions?: [...string]

			// ManagedFieldsManagers is a list of trusted managers. Fields mutated by those managers will take precedence over the
			// desired state defined in the SCM and won't be displayed in diffs
			managedFieldsManagers?: [...string]
		}

		#Info: {
			name:  string
			value: string
		}

		// ApplicationSourceHelm holds helm specific options
		#ApplicationSourceHelm: {
			// ValuesFiles is a list of Helm value files to use when generating a template
			valueFiles?: [...string]

			// Parameters is a list of Helm parameters which are passed to the helm template command upon manifest generation
			parameters?: [...#HelmParameter]

			// ReleaseName is the Helm release name to use. If omitted it will use the application name
			releaseName?: string

			// Values specifies Helm values to be passed to helm template, typically defined as a block
			values?: string

			// FileParameters are file parameters to the helm template
			fileParameters?: [...#HelmFileParameter]

			// Version is the Helm version to use for templating (either "2" or "3")
			version?: string

			// PassCredentials pass credentials to all domains (Helm's --pass-credentials)
			passCredentials?: bool

			// IgnoreMissingValueFiles prevents helm template from failing when valueFiles do not exist locally by not appending them to helm template --values
			ignoreMissingValueFiles?: bool

			// SkipCrds skips custom resource definition installation step (Helm's --skip-crds)
			skipCrds?: bool
		}

		// HelmParameter is a parameter that's passed to helm template during manifest generation
		#HelmParameter: {
			// Name is the name of the Helm parameter
			name?: string

			// Value is the value for the Helm parameter
			value?: string

			// ForceString determines whether to tell Helm to interpret booleans and numbers as strings
			forceString?: bool
		}

		// HelmFileParameter is a file parameter that's passed to helm template during manifest generation
		#HelmFileParameter: {
			// Name is the name of the Helm parameter
			name?: string

			// Path is the path to the file containing the values for the Helm parameter
			path?: string
		}

		// OperationState contains information about state of a running operation
		#OperationState: {
			// Operation is the original requested operation
			operation: #Operation

			// Phase is the current phase of the operation
			phase: string

			// Message holds any pertinent messages when attempting to perform operation (typically errors).
			message?: string

			// SyncResult is the result of a Sync operation
			syncResult?: null | #SyncOperationResult

			// StartedAt contains time of operation start
			startedAt: #Time

			// FinishedAt contains time of operation completion
			finishedAt?: null | #Time

			// RetryCount contains time of operation retries
			retryCount?: int64
		}

		// SyncOperationResult represent result of sync operation
		#SyncOperationResult: {
			// Resources contains a list of sync result items for each individual resource in a sync operation
			resources?: #ResourceResults

			// Revision holds the revision this sync operation was performed to
			revision: string

			// Source records the application source information of the sync, used for comparing auto-sync
			source?: #ApplicationSource
		}

		// ResourceResults defines a list of resource results for a given operation
		#ResourceResults: [...null | #ResourceResult]

		// ResourceResult holds the operation result details of a specific resource
		#ResourceResult: {
			// Group specifies the API group of the resource
			group: string

			// Version specifies the API version of the resource
			version: string

			// Kind specifies the API kind of the resource
			kind: string

			// Namespace specifies the target namespace of the resource
			namespace: string

			// Name specifies the name of the resource
			name: string

			// Status holds the final result of the sync. Will be empty if the resources is yet to be applied/pruned and is always zero-value for hooks
			status?: string

			// Message contains an informational or error message for the last sync OR operation
			message?: string

			// HookType specifies the type of the hook. Empty for non-hook resources
			hookType?: string

			// HookPhase contains the state of any operation associated with this resource OR hook
			// This can also contain values for non-hook resources.
			hookPhase?: string

			// SyncPhase indicates the particular phase of the sync that this result was acquired in
			syncPhase?: string
		}

		// Time is a wrapper around time.Time which supports correct
		// marshaling to YAML and JSON.  Wrappers are provided for many
		// of the factory methods that the time package offers.
		#Time: _

		// Operation contains information about a requested or running operation
		#Operation: {
			// Sync contains parameters for the operation
			sync?: null | #SyncOperation

			// InitiatedBy contains information about who initiated the operations
			initiatedBy?: #OperationInitiator

			// Info is a list of informational items for this operation
			info?: [...null | #Info]

			// Retry controls the strategy to apply if a sync fails
			retry?: #RetryStrategy
		}

		// SyncOperation contains details about a sync operation.
		#SyncOperation: {
			// Revision is the revision (Git) or chart version (Helm) which to sync the application to
			// If omitted, will use the revision specified in app spec.
			revision?: string

			// Prune specifies to delete resources from the cluster that are no longer tracked in git
			prune?: bool

			// DryRun specifies to perform a `kubectl apply --dry-run` without actually performing the sync
			dryRun?: bool

			// SyncStrategy describes how to perform the sync
			syncStrategy?: null | #SyncStrategy

			// Resources describes which resources shall be part of the sync
			resources?: [...#SyncOperationResource]

			// Source overrides the source definition set in the application.
			// This is typically set in a Rollback operation and is nil during a Sync operation
			source?: null | #ApplicationSource

			// Manifests is an optional field that overrides sync source with a local directory for development
			manifests?: [...string]

			// SyncOptions provide per-sync sync-options, e.g. Validate=false
			syncOptions?: #SyncOptions
		}

		// SyncStrategy controls the manner in which a sync is performed
		#SyncStrategy: {
			// Apply will perform a `kubectl apply` to perform the sync.
			apply?: null | #SyncStrategyApply

			// Hook will submit any referenced resources to perform the sync. This is the default strategy
			hook?: null | #SyncStrategyHook
		}

		// SyncStrategyApply uses `kubectl apply` to perform the apply
		#SyncStrategyApply: {
			// Force indicates whether or not to supply the --force flag to `kubectl apply`.
			// The --force flag deletes and re-create the resource, when PATCH encounters conflict and has
			// retried for 5 times.
			force?: bool
		}

		// SyncStrategyHook will perform a sync using hooks annotations.
		// If no hook annotation is specified falls back to `kubectl apply`.
		#SyncStrategyHook: {
			#SyncStrategyApply
		}

		// OperationInitiator contains information about the initiator of an operation
		#OperationInitiator: {
			// Username contains the name of a user who started operation
			username?: string

			// Automated is set to true if operation was initiated automatically by the application controller.
			automated?: bool
		}

		// SyncOperationResource contains resources to sync.
		#SyncOperationResource: {
			group?:     string
			kind:       string
			name:       string
			namespace?: string
		}

		// ApplicationSourceKustomize holds options specific to an Application source specific to Kustomize
		#ApplicationSourceKustomize: {
			// NamePrefix is a prefix appended to resources for Kustomize apps
			namePrefix?: string

			// NameSuffix is a suffix appended to resources for Kustomize apps
			nameSuffix?: string

			// Images is a list of Kustomize image override specifications
			images?: #KustomizeImages

			// CommonLabels is a list of additional labels to add to rendered manifests
			commonLabels?: {[string]: string}

			// Version controls which version of Kustomize to use for rendering manifests
			version?: string

			// CommonAnnotations is a list of additional annotations to add to rendered manifests
			commonAnnotations?: {[string]: string}

			// ForceCommonLabels specifies whether to force applying common labels to resources for Kustomize apps
			forceCommonLabels?: bool

			// ForceCommonAnnotations specifies whether to force applying common annotations to resources for Kustomize apps
			forceCommonAnnotations?: bool
		}

		// KustomizeImage represents a Kustomize image definition in the format [old_image_name=]<image_name>:<image_tag>
		#KustomizeImage: string

		// KustomizeImages is a list of Kustomize images
		#KustomizeImages: [...#KustomizeImage]

		// ApplicationSourceKsonnet holds ksonnet specific options
		#ApplicationSourceKsonnet: {
			// Environment is a ksonnet application environment name
			environment?: string

			// Parameters are a list of ksonnet component parameter override values
			parameters?: [...#KsonnetParameter]
		}

		// KsonnetParameter is a ksonnet component parameter
		#KsonnetParameter: {
			component?: string
			name:       string
			value:      string
		}

		// ApplicationSourceDirectory holds options for applications of type plain YAML or Jsonnet
		#ApplicationSourceDirectory: {
			// Recurse specifies whether to scan a directory recursively for manifests
			recurse?: bool

			// Jsonnet holds options specific to Jsonnet
			jsonnet?: #ApplicationSourceJsonnet

			// Exclude contains a glob pattern to match paths against that should be explicitly excluded from being used during manifest generation
			exclude?: string

			// Include contains a glob pattern to match paths against that should be explicitly included during manifest generation
			include?: string
		}

		// JsonnetVar represents a variable to be passed to jsonnet during manifest generation
		#JsonnetVar: {
			name:  string
			value: string
			code?: bool
		}

		// ApplicationSourceJsonnet holds options specific to applications of type Jsonnet
		#ApplicationSourceJsonnet: {
			// ExtVars is a list of Jsonnet External Variables
			extVars?: [...#JsonnetVar]

			// TLAS is a list of Jsonnet Top-level Arguments
			tlas?: [...#JsonnetVar]

			// Additional library search dirs
			libs?: [...string]
		}

		// ApplicationSourcePlugin holds options specific to config management plugins
		#ApplicationSourcePlugin: {
			name?: string
			env?:  #Env
		}

		// EnvEntry represents an entry in the application's environment
		#EnvEntry: {
			// Name is the name of the variable, usually expressed in uppercase
			name: string

			// Value is the value of the variable
			value: string
		}

		// Env is a list of environment variable entries
		#Env: [...null | #EnvEntry]
	}

	output: {
		{
			apiVersion: "argoproj.io/v1alpha1"
			kind:       "Application"
		} & parameter.Application
	}
}
