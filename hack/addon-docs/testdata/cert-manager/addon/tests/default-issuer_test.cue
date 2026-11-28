import "vela/test"

_withCert: components: [{
	name: "shop"
	type: "webservice"
	properties: image: "shop:1.0"
	traits: [{type: "certificate", properties: dnsNames: ["shop.example.com"]}]
}]

_ns: {
	$params: resource: kind: "Namespace"
	$returns: {apiVersion: "v1", kind: "Namespace", metadata: {name: "shop", annotations: {}}}
}

_policy: {
	definition: "../optional/namespaceIssuers/cert-manager-default-issuer"
	context: namespace: "shop"
}

"publishes nothing for a namespace with no annotation": test.#ApplicationPolicyRender & _policy & {
	spec: _withCert
	mocks: "vela/kube": "#Get": _ns
	expect: {
		enabled: true
		output: ctx?: _|_
	}
}

"a namespace's cluster-issuer annotation wins": test.#ApplicationPolicyRender & _policy & {
	spec: _withCert
	mocks: "vela/kube": "#Get": [_ns & {$returns: metadata: annotations: "cert-manager.oam.dev/cluster-issuer": "team-acme"}]
	expect: output: ctx: certManager: issuerRef: {kind: "ClusterIssuer", name: "team-acme"}
}

"a namespace's issuer annotation names an Issuer in that namespace": test.#ApplicationPolicyRender & _policy & {
	spec: _withCert
	mocks: "vela/kube": "#Get": [_ns & {$returns: metadata: annotations: "cert-manager.oam.dev/issuer": "team-ca"}]
	expect: output: ctx: certManager: issuerRef: {kind: "Issuer", name: "team-ca"}
}

"refuses a namespace that names both kinds": test.#ApplicationPolicyRender & _policy & {
	spec: _withCert
	mocks: "vela/kube": "#Get": [_ns & {$returns: metadata: annotations: {
		"cert-manager.oam.dev/issuer":         "team-ca"
		"cert-manager.oam.dev/cluster-issuer": "team-acme"
	}}]
	expect: error: =~"both cert-manager.oam.dev/issuer and cert-manager.oam.dev/cluster-issuer"
}

"reads only the namespace": test.#ApplicationPolicyRender & _policy & {
	spec: _withCert
	mocks: "vela/kube": "#Get": _ns
	expect: calls: "vela/kube": "#Get": [{$params: resource: {kind: "Namespace", metadata: name: "shop"}}]
}

"leaves an Application without the certificate trait alone, reading nothing": test.#ApplicationPolicyRender & _policy & {
	spec: components: [{name: "shop", type: "webservice", properties: image: "shop:1.0"}]
	expect: {
		enabled: false
		calls: "vela/kube"?: _|_
	}
}

"treats an empty annotation as none": test.#ApplicationPolicyRender & _policy & {
	spec: _withCert
	mocks: "vela/kube": "#Get": [_ns & {$returns: metadata: annotations: "cert-manager.oam.dev/issuer": ""}]
	expect: output: ctx?: _|_
}
