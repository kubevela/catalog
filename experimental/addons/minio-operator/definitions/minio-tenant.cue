"minio-tenant": {
	alias: ""
	annotations: {}
	attributes: workload: type: "autodetects.core.oam.dev"
	description: "minio tenant component"
	labels: {}
	type: "component"
}

template: {
	output: {
		kind:       "Tenant"
		apiVersion: "minio.min.io/v2"
		metadata: {
			name: context.name
		}
		spec: {
			buckets:                   parameter.buckets
			certConfig:                parameter.certConfig
			configuration:             parameter.configuration
			env:                       parameter.env
			exposeServices:            parameter.exposeServices
			externalCaCertSecret:      parameter.externalCaCertSecret
			externalCertSecret:        parameter.externalCertSecret
			externalClientCertSecret:  parameter.externalClientCertSecret
			externalClientCertSecrets: parameter.externalClientCertSecrets
			features:                  parameter.features
			image:                     parameter.image
			imagePullPolicy:           parameter.imagePullPolicy
			imagePullSecret:           parameter.imagePullSecret
			kes:                       parameter.kes
			liveness:                  parameter.liveness
			logging:                   parameter.logging
			mountPath:                 parameter.mountPath
			podManagementPolicy:       parameter.podManagementPolicy
			pools:                     parameter.pools
			priorityClassName:         parameter.priorityClassName
			prometheusOperator:        parameter.prometheusOperator
			readiness:                 parameter.readiness
			requestAutoCert:           parameter.requestAutoCert
			serviceAccountName:        parameter.serviceAccountName
			serviceMetadata:           parameter.serviceMetadata
			sideCars:                  parameter.sideCars
			startup:                   parameter.startup
			subPath:                   parameter.subPath
			users:                     parameter.users
		}
	}
	parameter: {
		//+usage=the size of the zookeeper cluster.
		buckets:                   *null | [...]
		certConfig:                *null | {...}
		configuration:             *null | {...}
		credsSecret:               *null | {...}
		env:                       *null | [...]
		exposeServices:            *null | {...}
		externalCaCertSecret:      *null | [...]
		externalCertSecret:        *null | [...]
		externalClientCertSecret:  *null | {...}
		externalClientCertSecrets: *null | [...]
		features:                  *null | {...}
		image:                     *null | string
		imagePullPolicy:           *null | string
		imagePullSecret:           *null | {...}
		kes:                       *null | {...}
		liveness:                  *null | {...}
		logging:                   *null | {...}
		mountPath:                 *null | string
		podManagementPolicy:       *null | string
		pools:                     *null | [...]
		priorityClassName:         *null | string
		prometheusOperator:        *null | bool
		readiness:                 *null | {...}
		requestAutoCert:           *null | bool
		serviceAccountName:        *null | string
		serviceMetadata:           *null | {...}
		sideCars:                  *null | {...}
		startup:                   *null | {...}
		subPath:                   *null | string
		users:                     *null | [...]
	}
}
