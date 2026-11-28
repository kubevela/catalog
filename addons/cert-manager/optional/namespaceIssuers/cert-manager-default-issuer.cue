import "vela/kube"

"cert-manager-default-issuer": {
	type:        "policy"
	description: "Gives the certificate trait the issuer a namespace names in its cert-manager.oam.dev/cluster-issuer or cert-manager.oam.dev/issuer annotation."
	annotations: {}
	labels: {}
	attributes: {
		scope:    "Application"
		global:   true
		priority: 100
	}
}

template: {
	schema: ctx: close({
		certManager?: issuerRef: {
			kind: "ClusterIssuer" | "Issuer"
			name: string
		}
	})

	parameter: {}

	_clusterIssuerKey: "cert-manager.oam.dev/cluster-issuer"
	_issuerKey:        "cert-manager.oam.dev/issuer"

	// The PolicyDefinition webhook compiles the template with no Application, so appComponents may be absent.
	_components: *context.appComponents | []
	_uses: len([for c in _components if c.traits != _|_ for t in c.traits if t.type == "certificate" {t}]) > 0

	config: enabled: _uses
	output: {}

	// Only Applications with the trait pay for the read, once per reconcile.
	if _uses {
		_ns: kube.#Get & {$params: resource: {apiVersion: "v1", kind: "Namespace", metadata: name: context.namespace}}
		_annotations: *_ns.$returns.metadata.annotations | {}

		// Application-scoped policies take no errs, so a refusal is a conflict whose path is the message.
		// An empty annotation names no issuer.
		_cluster: (_annotations[_clusterIssuerKey] & =~".") != _|_
		_local:   (_annotations[_issuerKey] & =~".") != _|_
		if _cluster && _local {
			_refuse: "namespace \(context.namespace) sets both \(_issuerKey) and \(_clusterIssuerKey); keep one": true & false
		}

		_named: [
			if _cluster {{kind: "ClusterIssuer", name: _annotations[_clusterIssuerKey]}},
			if _local {{kind: "Issuer", name: _annotations[_issuerKey]}},
		]
		if len(_named) == 1 {
			output: ctx: certManager: issuerRef: _named[0]
		}
	}
}
