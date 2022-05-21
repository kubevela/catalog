"istio-vs": {
	annotations: {}
	attributes: {
		appliesToWorkloads: ["*"]
		podDisruptive: false
	}
	description: "Handle Traffic Via Istio VirtualService."
	labels: {}
	type: "trait"
}

template: {
	outputs: VirtualService:{
		apiVersion: "networking.istio.io/v1alpha3"
		kind:       "VirtualService"
		metadata: name: context.name
		spec: {
			if parameter.hosts != _|_ {
				hosts: parameter.hosts
			}
			if parameter.gateways != _|_ {
				gateways: parameter.gateways
			}
			if parameter["http"] != _|_ {
				http: parameter.http
			}

		}
	}

	parameter: {
		// +usage=Annotations variable name
		annotations?: [string]: string
		// +usage=The destination hosts to which traffic is being sent
		hosts?: [...string]
		// +usage=The names of gateways and sidecars that should apply these routes
		gateways?: [...string]
		// +usage=An ordered list of route rules for HTTP traffic
		http?: [...#HTTPRoute]
		// +usage=An ordered list of route rules for opaque TCP traffic
		tcp?: [...#TCPRoute]
		// +usage=A list of namespaces to which this virtual service is exported
		exportTo?: [...string]
	}

	#TCPRoute:{
		// +usage=Match conditions to be satisfied for the rule to be activated
		match?: [...#L4MatchAttributes]
		// +usage=The destination to which the connection should be forwarded to
		route?: [...#RouteDestination]
	}

	#L4MatchAttributes:{
		// +usage=IPv4 or IPv6 ip addresses of destination with optional subnet
		destinationSubnets?: [...string]
		// +usage=Specifies the port on the host that is being addressed.
		port?: int
		// +usage=One or more labels that constrain the applicability of a rule to workloads with the given labels
		sourceLabels?: [string]:string
		// +usage=Names of gateways where the rule should be applied.
		gateways?: [...string]
		// +usage=Source namespace constraining the applicability of a rule to workloads in that namespace
		sourceNamespace?: string
	}

	#HTTPRoute:{
		// +usage=The name assigned to the route for debugging purposes
		name?: string
		// +usage=Match conditions to be satisfied for the rule to be activated
		match?: [...#HTTPMatchRequest]
		// +usage=A HTTP rule can either redirect or forward (default) traffic
		route?: [...#RouteDestination]
		// +usage=Rewrite HTTP URIs and Authority headers
		rewrite?: #HTTPRewrite
		// +usage=Cross-Origin Resource Sharing policy (CORS)
		corsPolicy?: #CorsPolicy
		// +usage=Header manipulation rules
		headers?: #Headers
	}
	// +usage=
	#StringMatchOneOf: { prefix: string } | { exact: string } | { regex: string }

	#HTTPMatchRequest: {
		// +usage=URI to match values are case-sensitive Ref(https://github.com/google/re2/wiki/Syntax).:
		uri?: #StringMatchOneOf
		// +usage=HTTP Authority to match values are case-sensitive Ref(https://github.com/google/re2/wiki/Syntax).:
		authority?: #StringMatchOneOf
		// +usage=URI Scheme to match values are case-sensitive Ref(https://github.com/google/re2/wiki/Syntax).:
		scheme?: #StringMatchOneOf
		// +usage=HTTP Method to match values are case-sensitive Ref(https://github.com/google/re2/wiki/Syntax).:
		method?: #StringMatchOneOf
		// +usage=The header keys must be lowercase and use hyphen as the separator, e.g. x-request-id.
		headers?: [string]: #StringMatchOneOf
	}

	#RouteDestination:{
		// +usage=Destination uniquely identifies the instances of a service to which the request/connection should be forwarded to.
		destination?: #Destination
		// +usage=Weight specifies the relative proportion of traffic to be forwarded to the destination
		weight?: int
	}

	#HTTPRewrite:{
		// +usage=Rewrite the path (or the prefix) portion of the URI with this value
		uri?: string
		// +usage=Rewrite the Authority/Host header with this value.
		authority?: string
	}

	#CorsPolicy:{
		// +usage=String patterns that match allowed origins.
		allowOrigins?: [...#StringMatchOneOf]
		// this three elements not suit for community version, only for gs
		// +usage=List of HTTP methods allowed to access the resource
		allowMethods?: [...string]
		// +usage=List of HTTP headers that can be used when requesting the resource
		allowHeaders?: [...string]
		// +usage=Indicates whether the caller is allowed to send the actual request (not the preflight) using credentials
		allowCredentials?: bool
	}

	#Destination:{
		// +usage=The name of a service from the service registry
		host?: string
		// +usage=The name of a subset within the service
		subset?: string
		// +usage=Specifies the port on the host that is being addressed
		port?: #PortSelector
	}

	#Headers:{
		// +usage=Header manipulation rules to apply before forwarding a request to the destination service
		request?: #HeaderOperations
		// +usage=Header manipulation rules to apply before returning a response to the caller
		response?: #HeaderOperations
	}

	#HeaderOperations:{
		// +usage=Overwrite the headers specified by key with the given values
		set?: [string]: string
		// +usage=Append the given values to the headers specified by keys (will create a comma-separated list of values)
		add?: [string]: string
		// +usage=Remove the specified headers
		remove?: [...string]
	}

	#PortSelector:{
		// +usage=Valid port number
		number: int
	}

}
