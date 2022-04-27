"argocd-project": {
	annotations: {}
	attributes: workload: {
		type: "autodetects.core.oam.dev"
	}
	description: "Argocd-project is a definition of appproject resource."
	labels: {}
	type: "component"
}

template: {

	parameter: {

		// AppProject provides a logical grouping of applications, providing controls for:
		// (1) where the apps may deploy to (cluster whitelist)
		// (2) what may be deployed (repository whitelist, resource whitelist/blacklist)
		// (3) who can access these applications (roles, OIDC group claims bindings)
		// (4) and what they can do (RBAC policies)
		// (5) automation access to these roles (JWT tokens)
		AppProject: {
			metadata: #ObjectMeta
			spec:     #AppProjectSpec
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

		// GroupKind specifies a Group and a Kind, but does not force a version.  This is useful for identifying
		// concepts during lookup stages without having partially valid types
		#GroupKind: {
			group: string
			kind:  string
		}

		// AppProjectSpec is the specification of an AppProject
		#AppProjectSpec: {
			// SourceRepos contains list of repository URLs which can be used for deployment
			sourceRepos?: [...string]

			// Destinations contains list of destinations available for deployment
			destinations: [...#ApplicationDestination]

			// Description contains optional project description
			description?: string

			// Roles are user defined RBAC roles associated with this project
			roles?: [...#ProjectRole]

			// ClusterResourceWhitelist contains list of whitelisted cluster level resources
			clusterResourceWhitelist?: [...#GroupKind]

			// NamespaceResourceBlacklist contains list of blacklisted namespace level resources
			namespaceResourceBlacklist?: [...#GroupKind]

			// OrphanedResources specifies if controller should monitor orphaned resources of apps in this project
			orphanedResources?: null | #OrphanedResourcesMonitorSettings

			// SyncWindows controls when syncs can be run for apps in this project
			syncWindows?: #SyncWindows

			// NamespaceResourceWhitelist contains list of whitelisted namespace level resources
			namespaceResourceWhitelist?: [...#GroupKind]

			// SignatureKeys contains a list of PGP key IDs that commits in Git must be signed with in order to be allowed for sync
			signatureKeys?: [...#SignatureKey]

			// ClusterResourceBlacklist contains list of blacklisted cluster level resources
			clusterResourceBlacklist?: [...#GroupKind]
		}

		// ApplicationDestination holds information about the application's destination
		#ApplicationDestination: {
			namespace: string
			server:    string
		}

		// SyncWindows is a collection of sync windows in this project
		#SyncWindows: [...null | #SyncWindow]

		// SyncWindow contains the kind, time, duration and attributes that are used to assign the syncWindows to apps
		#SyncWindow: {
			// Kind defines if the window allows or blocks syncs
			kind?: string

			// Schedule is the time the window will begin, specified in cron format
			schedule?: string

			// Duration is the amount of time the sync window will be open
			duration?: string

			// Applications contains a list of applications that the window will apply to
			applications?: [...string]

			// Namespaces contains a list of namespaces that the window will apply to
			namespaces?: [...string]

			// Clusters contains a list of clusters that the window will apply to
			clusters?: [...string]

			// ManualSync enables manual syncs when they would otherwise be blocked
			manualSync?: bool

			//TimeZone of the sync that will be applied to the schedule
			timeZone?: string
		}

		// ProjectRole represents a role that has access to a project
		#ProjectRole: {
			// Name is a name for this role
			name: string

			// Description is a description of the role
			description?: string

			// Policies Stores a list of casbin formatted strings that define access policies for the role in the project
			policies?: [...string]

			// JWTTokens are a list of generated JWT tokens bound to this role
			jwtTokens?: [...#JWTToken]

			// Groups are a list of OIDC group claims bound to this role
			groups?: [...string]
		}

		// ApplicationDestination holds information about the application's destination
		//  #ApplicationDestination: _

		// OrphanedResourcesMonitorSettings holds settings of orphaned resources monitoring
		#OrphanedResourcesMonitorSettings: {
			// Warn indicates if warning condition should be created for apps which have orphaned resources
			warn?: null | bool

			// Ignore contains a list of resources that are to be excluded from orphaned resources monitoring
			ignore?: [...#OrphanedResourceKey]
		}

		// OrphanedResourceKey is a reference to a resource to be ignored from
		#OrphanedResourceKey: {
			group?: string
			kind?:  string
			name?:  string
		}

		// SignatureKey is the specification of a key required to verify commit signatures with
		#SignatureKey: {
			// The ID of the key in hexadecimal notation
			keyID: string
		}

		// JWTToken holds the issuedAt and expiresAt values of a token
		#JWTToken: {
			iat:  int64
			exp?: int64
			id?:  string
		}
	}

	output: {
		{
			apiVersion: "argoproj.io/v1alpha1"
			kind:       "AppProject"
		} & parameter.abc
	}
}
