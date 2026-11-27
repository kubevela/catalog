package main

// Each major has its own pinned chart and floor. The definitions under variants/major/ follow the same choice.
_majors: {
	"1": {version: "1.20.15", minVersion: "1.20.0"}
	"2": {version: "2.5.0", minVersion: "2.0.0"}
}

_install: {
	name:      "crossplane"
	namespace: parameter.namespace
	chart: {
		source:     "crossplane"
		repoURL:    "https://charts.crossplane.io/stable"
		version:    _majors["\(parameter.major)"].version
		minVersion: _majors["\(parameter.major)"].minVersion
		major:      parameter.major
	}
	// Each parameter becomes a default, so the same key in parameter.values wins.
	values: {
		replicas: *parameter.replicas | _
		if parameter.monitoring {
			metrics: enabled: *true | _
		}
		if parameter.args != _|_ {
			args: *parameter.args | _
		}
		if parameter.resources != _|_ {
			resourcesCrossplane: *parameter.resources | _
		}
		if parameter.nodeSelector != _|_ {
			nodeSelector: *parameter.nodeSelector | _
			rbacManager: nodeSelector: *parameter.nodeSelector | _
		}
		if parameter.tolerations != _|_ {
			tolerations: *parameter.tolerations | _
			rbacManager: tolerations: *parameter.tolerations | _
		}
		if parameter.affinity != _|_ {
			affinity: *parameter.affinity | _
			rbacManager: affinity: *parameter.affinity | _
		}
		if parameter.priorityClassName != _|_ {
			priorityClassName: *parameter.priorityClassName | _
		}
		if parameter.imageRegistry != _|_ {
			image: repository: *"\(parameter.imageRegistry)/crossplane/crossplane" | _
		}
		if parameter.imagePullSecrets != _|_ {
			imagePullSecrets: *parameter.imagePullSecrets | _
		}
		if parameter.packageCacheSize != _|_ {
			packageCache: sizeLimit: *parameter.packageCacheSize | _
		}
		if parameter.registryCaBundle != _|_ {
			registryCaBundleConfig: *parameter.registryCaBundle | _
		}
	}
}

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	spec: {
		components: _install.components
		// Crossplane is the hub's control plane: it runs where KubeVela does.
		policies: [for p in _install.policies {p}, {
			type: "topology"
			name: "deploy-crossplane"
			properties: clusters: ["local"]
		}]
	}
}
