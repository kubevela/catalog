package main

import "strings"

_install: {
	name:      "cert-manager"
	namespace: parameter.namespace
	chart: {
		source:  "cert-manager"
		repoURL: "https://charts.jetstack.io"
		version: "v1.21.3"
		// crds.enabled and crds.keep, which the values below set, arrived in v1.15.0.
		minVersion: "v1.15.0"
	}
	// Each parameter becomes a default, so the same key in parameter.values wins.
	values: {
		// The chart ships its CRDs in templates/, so an upgrade updates them; keep leaves them on uninstall.
		crds: {enabled: *true | bool, keep: *parameter.keepCRDs | bool}
		replicaCount: *parameter.replicas | _
		webhook: replicaCount: *parameter.replicas | _
		cainjector: replicaCount: *parameter.replicas | _
		if parameter.highAvailability {
			podDisruptionBudget: enabled: *true | _
			webhook: podDisruptionBudget: enabled: *true | _
			cainjector: podDisruptionBudget: enabled: *true | _
		}
		if parameter.monitoring {
			prometheus: {enabled: *true | _, servicemonitor: enabled: *true | _}
		}
		if parameter.resources != _|_ {
			resources: *parameter.resources | _
			webhook: resources: *parameter.resources | _
			cainjector: resources: *parameter.resources | _
		}
		if parameter.nodeSelector != _|_ {
			global: nodeSelector: *parameter.nodeSelector | _
		}
		if parameter.tolerations != _|_ {
			tolerations: *parameter.tolerations | _
			webhook: tolerations: *parameter.tolerations | _
			cainjector: tolerations: *parameter.tolerations | _
			startupapicheck: tolerations: *parameter.tolerations | _
		}
		if parameter.affinity != _|_ {
			affinity: *parameter.affinity | _
			webhook: affinity: *parameter.affinity | _
			cainjector: affinity: *parameter.affinity | _
			startupapicheck: affinity: *parameter.affinity | _
		}
		if parameter.priorityClassName != _|_ {
			global: priorityClassName: *parameter.priorityClassName | _
		}
		if parameter.imageRegistry != _|_ {
			imageRegistry: *parameter.imageRegistry | _
		}
		if parameter.imagePullSecrets != _|_ {
			global: imagePullSecrets: *[for n in parameter.imagePullSecrets {name: n}] | _
		}
		if parameter.featureGates != _|_ {
			featureGates: *strings.Join([for k, v in parameter.featureGates {"\(k)=\(v)"}], ",") | _
		}
		if parameter.dns01Nameservers != _|_ {
			dns01RecursiveNameservers: *strings.Join(parameter.dns01Nameservers, ",") | _
			dns01RecursiveNameserversOnly: *true | _
		}
		if parameter.certificateOwnerRef {
			enableCertificateOwnerRef: *true | _
		}
	}
	// Concrete, so it meets the shared default without a second one.
	keepCRDs: [if parameter.values.crds.keep != _|_ {parameter.values.crds.keep}, parameter.keepCRDs][0]

	if parameter.highAvailability && parameter.replicas < 2 {
		_refuse: "highAvailability needs replicas of 2 or more: a PodDisruptionBudget over one pod blocks every drain": true & false
	}
}

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	spec: {
		components: _install.components
		policies: [for p in _install.policies {p}, {
			// 2.x made an Issuer, Certificate and token Secret from dns01, and an alidns webhook release,
			// as these components. 3.0.0 has none of them: leave what an upgrade finds running.
			// Orphan, not strategy never: a strategy is fixed when a resource is dispatched, so only
			// propagation is read at deletion, and these were dispatched by 2.x.
			type: "garbage-collect"
			name: "keep-2x-dns01"
			properties: rules: [{
				selector: componentNames: ["certificate-conf", "alidns-webhook"]
				propagation: "orphan"
			}]
		}, {
			type: "topology"
			name: "deploy-cert-manager"
			properties: {
				if parameter.clusters != _|_ {clusters: parameter.clusters}
				if parameter.clusters == _|_ {clusterLabelSelector: {}}
			}
		}]
	}
}
