"jaeger": {
	alias: ""
	annotations: {}
	attributes: workload: type: "autodetects.core.oam.dev"
	description: "jaeger component"
	labels: {}
	type: "component"
}

template: {
	output: {
		kind:       "Jaeger"
		apiVersion: "jaegertracing.io/v1"
		metadata: {
			name: context.name
		}
		spec: {
			affinity:                 parameter.affinity
			agent:                    parameter.agent
			allInOne:                 parameter.allInOne
			annotations:              parameter.annotations
			collector:                parameter.collector
			containerSecurityContext: parameter.containerSecurityContext
			imagePullPolicy:          parameter.imagePullPolicy
			imagePullSecrets:         parameter.imagePullSecrets
			ingester:                 parameter.ingester
			ingress:                  parameter.ingress
			labels:                   parameter.labels
			livenessProbe:            parameter.livenessProbe
			query:                    parameter.query
			resources:                parameter.resources
			sampling:                 parameter.sampling
			securityContext:          parameter.securityContext
			serviceAccount:           parameter.serviceAccount
			storage:                  parameter.storage
			strategy:                 parameter.strategy
			tolerations:              parameter.tolerations
			ui:                       parameter.ui
			volumeMounts:             parameter.volumeMounts
			volumes:                  parameter.volumes
		}
	}
	parameter: {
		//+usage=configure affinity.
		affinity: *null | {...}
		//+usage=configure agent.
		agent: *null | {...}
		//+usage=configure allInOne.
		allInOne: *null | {...}
		//+usage=configure annotations.
		annotations: *null | {...}
		//+usage=configure collector.
		collector: *null | {...}
		//+usage=configure containerSecurityContext.
		containerSecurityContext: *null | {...}
		//+usage=configure imagePullPolicy.
		imagePullPolicy: *null | string
		//+usage=configure imagePullSecrets.
		imagePullSecrets: *null | [...]
		//+usage=configure ingester.
		ingester: *null | {...}
		//+usage=configure ingress.
		ingress: *null | {...}
		//+usage=configure labels.
		labels: *null | {...}
		//+usage=configure livenessProbe.
		livenessProbe: *null | {...}
		//+usage=configure query.
		query: *null | {...}
		//+usage=configure resources.
		resources: *null | {...}
		//+usage=configure sampling.
		sampling: *null | {...}
		//+usage=configure securityContext.
		securityContext: *null | {...}
		//+usage=configure serviceAccount.
		serviceAccount: *null | string
		//+usage=configure storage.
		storage: *null | {...}
		//+usage=configure strategy.
		strategy: *null | string
		//+usage=configure tolerations.
		tolerations: *null | [...]
		//+usage=configure ui.
		ui: *null | {...}
		//+usage=configure volumeMounts.
		volumeMounts: *null | [...]
		//+usage=configure volumes.
		volumes: *null | {...}
	}
}
