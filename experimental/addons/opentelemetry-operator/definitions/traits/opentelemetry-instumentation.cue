"opentelemetry-instrumentation": {
	alias: ""
	annotations: {}
	attributes: {
		stage: "PreDispatch"
		workload: type: "autodetects.core.oam.dev"
	}
	description: "opentelemetry instrumentation trait"
	labels: {}
	type: "trait"
}

template: {
	outputs: instrumentation: {
		kind:       "Instrumentation"
		apiVersion: "opentelemetry.io/v1alpha1"
		metadata: {
			name: context.name
		}
		spec: {
			apacheHttpd: parameter.apacheHttpd
			dotnet:      parameter.dotnet
			env:         parameter.env
			exporter:    parameter.exporter
			java:        parameter.java
			nodejs:      parameter.nodejs
			propagators: parameter.propagators
			python:      parameter.python
			resource:    parameter.resource
			sampler:     parameter.sampler
		}
	}
	parameter: {
		//+usage=Apache defines configuration for Apache HTTPD auto-instrumentation.
		apacheHttpd: *null | {...}
		//+usage=DotNet defines configuration for DotNet auto-instrumentation.
		dotnet: *null | {...}
		//+usage=Env defines common env vars. There are four layers for env vars' definitions and the precedence order is: `original container env vars` > `language specific env vars` > `common env vars` > `instrument spec configs' vars`. If the former var had been defined, then the other vars would be ignored.
		env: *null | [...]
		//+usage=Exporter defines exporter configuration.
		exporter: *null | {...}
		//+usage=Java defines configuration for java auto-instrumentation.
		java: *null | {...}
		//+usage=NodeJS defines configuration for nodejs auto-instrumentation.
		nodejs: *null | {...}
		//+usage=Propagators defines inter-process context propagation configuration. Values in this list will be set in the OTEL_PROPAGATORS env var. Enum=tracecontext;baggage;b3;b3multi;jaeger;xray;ottrace;none
		propagators: *null | [...]
		//+usage=Python defines configuration for python auto-instrumentation.
		python: *null | {...}
		//+usage=Resource defines the configuration for the resource attributes, as defined by the OpenTelemetry specification.
		resource: *null | {...}
		//+usage=Sampler defines sampling configuration.
		sampler: *null | {...}
	}
}
