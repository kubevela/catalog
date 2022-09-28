parameter: {
	// +usage=Service type
	serviceType: *"ClusterIP" | "NodePort" | "LoadBalancer"
	name:        "addon-clickhouse"
	// +usage=The clusters to install
	clusters?: [...string]
}
