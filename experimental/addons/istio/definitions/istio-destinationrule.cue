"istio-destinationrule": {
	annotations: {}
	attributes: {
		appliesToWorkloads: ["deployments.apps"]
		podDisruptive: false
	}
	description: "DestinationRule defines policies that apply to traffic intended for a service after routing has occurred."
	labels: {}
	type: "trait"
}

template: {
	outputs: DestinationRule: {
		apiVersion: "networking.istio.io/v1alpha3"
		kind:       "DestinationRule"
		metadata: name: context.name
		spec: {
			host: parameter.host
			if parameter.trafficPolicy != _|_ {
				trafficPolicy: parameter.trafficPolicy
			}
			if parameter.subsets != _|_ {
				subsets: parameter.subsets
			}
			if parameter.exportTo != _|_ {
				exportTo: parameter.exportTo
			}
			if parameter.workloadSelector != _|_ {
				workloadSelector: parameter.workloadSelector
			}
		}
	}

	parameter: {
		// +usage=The name of a service from the service registry. Service names are looked up from the platform’s service registry (e.g., Kubernetes services, Consul services, etc.) and from the hosts declared by ServiceEntries. Rules defined for services that do not exist in the service registry will be ignored.
		host: string
		// +usage=Traffic policies to apply (load balancing policy, connection pool sizes, outlier detection).
		trafficPolicy?: #TrafficPolicy
		// +usage=One or more named sets that represent individual versions of a service. Traffic policies can be overridden at subset level.
		subsets?: [...#Subset]
		// +usage=A list of namespaces to which this destination rule is exported. The resolution of a destination rule to apply to a service occurs in the context of a hierarchy of namespaces. Exporting a destination rule allows it to be included in the resolution hierarchy for services in other namespaces. This feature provides a mechanism for service owners and mesh administrators to control the visibility of destination rules across namespace boundaries.
		exportTo?: [...string]
		// +usage=Criteria used to select the specific set of pods/VMs on which this DestinationRule configuration should be applied. If specified, the DestinationRule configuration will be applied only to the workload instances matching the workload selector label in the same namespace. Workload selectors do not apply across namespace boundaries. If omitted, the DestinationRule falls back to its default behavior. For example, if specific sidecars need to have egress TLS settings for services outside of the mesh, instead of every sidecar in the mesh needing to have the configuration (which is the default behaviour), a workload selector can be specified.
		workloadSelector?: {
			// +usage=One or more labels that indicate a specific set of pods/VMs on which a policy should be applied. The scope of label search is restricted to the configuration namespace in which the resource is present.
			matchLabels: [string]: string | null
		}
	}

	#TrafficPolicy: {
		// +usage=Settings controlling the load balancer algorithms.
		loadBalancer?: #LoadBalancerSettings
		// +usage=Settings controlling the volume of connections to an upstream service
		connectionPool?: #ConnectionPoolSettings
		// +usage=Settings controlling eviction of unhealthy hosts from the load balancing pool
		outlierDetection?: #OutlierDetection
		// +usage=TLS related settings for connections to the upstream service.
		tls?: #ClientTLSSettings
		// +usage=Traffic policies specific to individual ports. Note that port level settings will override the destination-level settings. Traffic settings specified at the destination-level will not be inherited when overridden by port-level settings, i.e. default values will be applied to fields omitted in port-level traffic policies.
		portLevelSettings?: [...#PortTrafficPolicy]
		// +usage=Configuration of tunneling TCP over other transport or application layers for the host configured in the DestinationRule. Tunnel settings can be applied to TCP or TLS routes and can’t be applied to HTTP routes.
		tunnel?: #TunnelSettings
	}

	#LoadBalancerSettings: {
		// +usage=Standard load balancing algorithms that require no tuning.
		simple?: #SimpleLB
		// +usage=Consistent Hash-based load balancing can be used to provide soft session affinity based on HTTP headers, cookies or other properties. The affinity to a particular destination host will be lost when one or more hosts are added/removed from the destination service.
		consistentHash?: #ConsistentHashLB
		// +usage:Locality load balancer settings, this will override mesh wide settings in entirety, meaning no merging would be performed between this object and the object one in MeshConfig
		localityLbSetting?: #LocalityLoadBalancerSetting
		// +usage=Settings controlling the outlier detection algorithms.Represents the warmup duration of Service. If set, the newly created endpoint of service remains in warmup mode starting from its creation time for the duration of this window and Istio progressively increases amount of traffic for that endpoint instead of sending proportional amount of traffic. This should be enabled for services that require warm up time to serve full production load with reasonable latency. Currently this is only supported for ROUND_ROBIN and LEAST_CONN load balancers.
		warmupDurationSecs?: #Duration
	}

	#Duration: =~"^[0-9]*(\\.[0-9]+)?s$"

	#SimpleLB: "UNSPECIFIED" | "RANDOM" | "PASSTHROUGH" | "ROUND_ROBIN" | "LEAST_REQUEST" | "LEAST_CONN"

	#ConsistentHashLB: {
		// +usage=Hash based on a specific HTTP header.
		httpHeaderName?: string
		// +usage=Hash based on HTTP cookie.
		httpCookie?: {
			// +usage=Name of the cookie.
			name: string
			// +usage=Path to set for the cookie.
			path?: string
			// +usage=Lifetime of the cookie, ends in s to indicate seconds and is preceded by the number of seconds, with nanoseconds expressed as fractional seconds.
			ttl?: #Duration
		}
		// +usage=Hash based on the source IP address. This is applicable for both TCP and HTTP connections.
		useSourceIp?: bool
		// +usage=Hash based on a specific HTTP query parameter.
		httpQueryParameterName?: string
		// +usage=The minimum number of virtual nodes to use for the hash ring. Defaults to 1024. Larger ring sizes result in more granular load distributions. If the number of hosts in the load balancing pool is larger than the ring size, each host will be assigned a single virtual node.
		minimumRingSize?: int
	}

	#LocalityLoadBalancerSetting: {
		// +usage:Optional: only one of distribute, failover or failoverPriority can be set. Explicitly specify loadbalancing weight across different zones and geographical locations. Refer to Locality weighted load balancing If empty, the locality weight is set according to the endpoints number within it.
		distribute?: {
			// +usage:Optional: only one of distribute, failover or failoverPriority can be set. Explicitly specify the region traffic will land on when endpoints in local region becomes unhealthy. Should be used together with OutlierDetection to detect unhealthy endpoints. Note: if no OutlierDetection specified, this will not take effect.
			failover?: {
				// +usage:failoverPriority is an ordered list of labels used to sort endpoints to do priority based load balancing. This is to support traffic failover across different groups of endpoints.
				failoverPriority?: [...string]
			}
		}
		// +usage:enable locality load balancing, this is DestinationRule-level and will override mesh wide settings in entirety. e.g. true means that turn on locality load balancing for this DestinationRule no matter what mesh wide settings is.
		enabled?: bool
	}

	#ConnectionPoolSettings: {
		// +usage=Settings common to both HTTP and TCP upstream connections.
		tcp?: {
			// +usage=Maximum number of HTTP1 /TCP connections to a destination host. Default 2^32-1.
			maxConnections?: int
			// +usage=TCP connection timeout. format: 1h/1m/1s/1ms. MUST BE >=1ms. Default is 10s.
			connectTimeout?: #Duration
			// +usage=If set then set SO_KEEPALIVE on the socket to enable TCP Keepalives.
			tcpKeepalive?: {
				// +usage=Maximum number of keepalive probes to send without response before deciding the connection is dead. Default is to use the OS level configuration (unless overridden, Linux defaults to 9.)
				probes?: int
				// +usage=The time duration a connection needs to be idle before keep-alive probes start being sent. Default is to use the OS level configuration (unless overridden, Linux defaults to 7200s (ie 2 hours.)
				time?: #Duration
				// +usage=The time duration between keep-alive probes. Default is to use the OS level configuration (unless overridden, Linux defaults to 75s.)
				interval?: #Duration
			}
		}
		// +usage=HTTP connection pool settings.
		http?: {
			// +usage=Maximum number of pending HTTP requests to a destination. Default 2^32-1.
			http1MaxPendingRequests?: int
			// +usage=Maximum number of requests to a backend. Default 2^32-1.
			http2MaxRequests?: int
			// +usage=Maximum number of requests per connection to a backend. Setting this parameter to 1 disables keep alive. Default 0, meaning “unlimited”, up to 2^29.
			maxRequestsPerConnection?: int
			// +usage=Maximum number of retries that can be outstanding to all hosts in a cluster at a given time. Defaults to 2^32-1.
			maxRetries?: int
			// +usage=The idle timeout for upstream connection pool connections. The idle timeout is defined as the period in which there are no active requests. If not set, the default is 1 hour. When the idle timeout is reached, the connection will be closed. If the connection is an HTTP/2 connection a drain sequence will occur prior to closing the connection. Note that request based timeouts mean that HTTP/2 PINGs will not keep the connection alive. Applies to both HTTP1.1 and HTTP2 connections.
			idleTimeout?: #Duration
			// +usage=Specify if http1.1 connection should be upgraded to http2 for the associated destination.
			h2UpgradePolicy?: "DEFAULT" | "DO_NOT_UPGRADE" | "UPGRADE"
			// +usage=If set to true, client protocol will be preserved while initiating connection to backend. Note that when this is set to true, h2_upgrade_policy will be ineffective i.e. the client connections will not be upgraded to http2.
			useClientProtocol?: bool
		}
	}

	#OutlierDetection: {
		// +usage=Determines whether to distinguish local origin failures from external errors. If set to true consecutive_local_origin_failure is taken into account for outlier detection calculations. This should be used when you want to derive the outlier detection status based on the errors seen locally such as failure to connect, timeout while connecting etc. rather than the status code retuned by upstream service. This is especially useful when the upstream service explicitly returns a 5xx for some requests and you want to ignore those responses from upstream service while determining the outlier detection status of a host. Defaults to false.
		splitExternalLocalOriginErrors?: bool
		// +usage=The number of consecutive locally originated failures before ejection occurs. Defaults to 5. Parameter takes effect only when split_external_local_origin_errors is set to true.
		consecutiveLocalOriginFailures?: int
		// +usage=Number of gateway errors before a host is ejected from the connection pool. When the upstream host is accessed over HTTP, a 502, 503, or 504 return code qualifies as a gateway error. When the upstream host is accessed over an opaque TCP connection, connect timeouts and connection error/failure events qualify as a gateway error. This feature is disabled by default or when set to the value 0. Note that consecutive_gateway_errors and consecutive_5xx_errors can be used separately or together. Because the errors counted by consecutive_gateway_errors are also included in consecutive_5xx_errors, if the value of consecutive_gateway_errors is greater than or equal to the value of consecutive_5xx_errors, consecutive_gateway_errors will have no effect.
		consecutiveGatewayErrors?: int
		// +usage=Number of 5xx errors before a host is ejected from the connection pool. When the upstream host is accessed over an opaque TCP connection, connect timeouts, connection error/failure and request failure events qualify as a 5xx error. This feature defaults to 5 but can be disabled by setting the value to 0. Note that consecutive_gateway_errors and consecutive_5xx_errors can be used separately or together. Because the errors counted by consecutive_gateway_errors are also included in consecutive_5xx_errors, if the value of consecutive_gateway_errors is greater than or equal to the value of consecutive_5xx_errors, consecutive_gateway_errors will have no effect.
		consecutive5xxErrors?: int
		// +usage=Time interval between ejection sweep analysis. format: 1h/1m/1s/1ms. MUST BE >=1ms. Default is 10s.
		interval?: #Duration
		// +usage=Minimum ejection duration. A host will remain ejected for a period equal to the product of minimum ejection duration and the number of times the host has been ejected. This technique allows the system to automatically increase the ejection period for unhealthy upstream servers. format: 1h/1m/1s/1ms. MUST BE >=1ms. Default is 30s.
		baseEjectionTime?: #Duration
		// +usage=Maximum % of hosts in the load balancing pool for the upstream service that can be ejected. Defaults to 10%.
		maxEjectionPercent?: int
		// +usage=Outlier detection will be enabled as long as the associated load balancing pool has at least min_health_percent hosts in healthy mode. When the percentage of healthy hosts in the load balancing pool drops below this threshold, outlier detection will be disabled and the proxy will load balance across all hosts in the pool (healthy and unhealthy). The threshold can be disabled by setting it to 0%. The default is 0% as it’s not typically applicable in k8s environments with few pods per service.
		minHealthPercent?: int
	}

	#ClientTLSSettings: {
		// +usage=Indicates whether connections to this port should be secured using TLS. The value of this field determines how TLS is enforced.
		mode: "DISABLE" | "SIMPLE" | "MUTUAL" | "ISTIO_MUTUAL"
		// +usage=REQUIRED if mode is MUTUAL. The path to the file holding the client-side TLS certificate to use. Should be empty if mode is ISTIO_MUTUAL.
		clientCertificate?: string
		// +usage=REQUIRED if mode is MUTUAL. The path to the file holding the client’s private key. Should be empty if mode is ISTIO_MUTUAL.
		privateKey?: string
		// +usage=OPTIONAL: The path to the file containing certificate authority certificates to use in verifying a presented server certificate. If omitted, the proxy will not verify the server’s certificate. Should be empty if mode is ISTIO_MUTUAL.
		caCertificates?: string
		// +usage=The name of the secret that holds the TLS certs for the client including the CA certificates. Secret must exist in the same namespace with the proxy using the certificates. The secret (of type generic)should contain the following keys and values: key: <privateKey>, cert: <clientCert>, cacert: <CACertificate>. Here CACertificate is used to verify the server certificate. Secret of type tls for client certificates along with ca.crt key for CA certificates is also supported. Only one of client certificates and CA certificate or credentialName can be specified.NOTE: This field is applicable at sidecars only if DestinationRule has a workloadSelector specified. Otherwise the field will be applicable only at gateways, and sidecars will continue to use the certificate paths.
		credentialName?: string
		// +usage=A list of alternate names to verify the subject identity in the certificate. If specified, the proxy will verify that the server certificate’s subject alt name matches one of the specified values. If specified, this list overrides the value of subject_alt_names from the ServiceEntry.
		subjectAltNames?: [...string]
		// +usage=SNI string to present to the server during TLS handshake. If unspecified, SNI will be automatically set based on downstream HTTP host/authority header for SIMPLE and MUTUAL TLS modes, provided ENABLE_AUTO_SNI environmental variable is set to true.
		sni?: string
		// +usage=InsecureSkipVerify specifies whether the proxy should skip verifying the CA signature and SAN for the server certificate corresponding to the host. This flag should only be set if global CA signature verifcation is enabled, VerifyCertAtClient environmental variable is set to true, but no verification is desired for a specific host. If enabled with or without VerifyCertAtClient enabled, verification of the CA signature and SAN will be skipped.InsecureSkipVerify is false by default. VerifyCertAtClient is false by default in Istio version 1.9 but will be true by default in a later version where, going forward, it will be enabled by default.
		insecureSkipVerify?: bool
	}

	#PortTrafficPolicy: {
		// +usage=Specifies the number of a port on the destination service on which this policy is being applied.
		port?: {
			number: int
		}
		// +usage=Settings controlling the load balancer algorithms.
		loadBalancer?: #LoadBalancerSettings
		// +usage=Settings controlling the volume of connections to an upstream service
		connectionPool?: #ConnectionPoolSettings
		// +usage=Settings controlling eviction of unhealthy hosts from the load balancing pool
		outlierDetection?: #OutlierDetection
		// +usage=TLS related settings for connections to the upstream service.
		tls?: #ClientTLSSettings
	}

	#TunnelSettings: {
		// +usage=Specifies which protocol to use for tunneling the downstream connection. Supported protocols are: connect - uses HTTP CONNECT; post - uses HTTP POST. HTTP version for upstream requests is determined by the service protocol defined for the proxy.
		protocol: string
		// +usage=Specifies a host to which the downstream connection is tunneled. Target host must be an FQDN or IP address.
		targetHost: string
		// +usage=Specifies a port to which the downstream connection is tunneled.
		targetPort: int
	}

	#Subset: {
		// +usage=Name of the subset. The service name and the subset name can be used for traffic splitting in a route rule.
		name: string
		// +usage=Labels apply a filter over the endpoints of a service in the service registry. See route rules for examples of usage.
		labels?: [string]: string | null
		// +usage=Traffic policies that apply to this subset. Subsets inherit the traffic policies specified at the DestinationRule level. Settings specified at the subset level will override the corresponding settings specified at the DestinationRule level.
		trafficPolicy?: #TrafficPolicy
	}
}
