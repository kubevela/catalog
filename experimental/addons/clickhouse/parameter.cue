parameter: {
	// +usage=Service type
	serviceType: *"ClusterIP" | "NodePort" | "LoadBalancer"
	name:        "addon-clickhouse"
	// +usage=The clusters to install
	clusters?: [...string]
	// +usage=Enable grafana dashboard for clickhouse operator, this requires prism and garafna addon enabled.
	grafanaDashbord: *false | true
}
