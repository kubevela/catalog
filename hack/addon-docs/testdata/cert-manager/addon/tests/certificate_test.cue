import "vela/test"

_cert: {
	definition: "../definitions/certificate"
	context: {name: "shop", namespace: "shop"}
	workload: {apiVersion: "apps/v1", kind: "Deployment", metadata: name: "shop"}
}

"issues a Certificate from the named issuer": test.#TraitRender & _cert & {
	parameter: {dnsNames: ["shop.example.com"], issuerRef: name: "letsencrypt"}
	expect: outputs: certificate: {
		apiVersion: "cert-manager.io/v1"
		kind:       "Certificate"
		metadata: name: "shop"
		spec: {
			secretName: "shop-tls"
			dnsNames: ["shop.example.com"]
			issuerRef: {group: "cert-manager.io", kind: "ClusterIssuer", name: "letsencrypt"}
		}
	}
}

"a namespaced issuer, a Secret name and the renewal window pass through": test.#TraitRender & _cert & {
	parameter: {
		dnsNames: ["shop.example.com", "www.shop.example.com"]
		secretName: "shop-cert"
		issuerRef: {name: "team-ca", kind: "Issuer"}
		duration:    "2160h"
		renewBefore: "360h"
	}
	expect: outputs: certificate: spec: {
		secretName: "shop-cert"
		dnsNames: ["shop.example.com", "www.shop.example.com"]
		issuerRef: {group: "cert-manager.io", kind: "Issuer", name: "team-ca"}
		duration:    "2160h"
		renewBefore: "360h"
	}
}

"takes the namespace's issuer from the policy when none is named": test.#TraitRender & _cert & {
	context: custom: certManager: issuerRef: {kind: "ClusterIssuer", name: "platform-acme"}
	parameter: dnsNames: ["shop.example.com"]
	expect: outputs: certificate: spec: issuerRef: {kind: "ClusterIssuer", name: "platform-acme"}
}

"a named issuer wins over the namespace's": test.#TraitRender & _cert & {
	context: custom: certManager: issuerRef: {kind: "ClusterIssuer", name: "platform-acme"}
	parameter: {dnsNames: ["shop.example.com"], issuerRef: name: "letsencrypt"}
	expect: outputs: certificate: spec: issuerRef: name: "letsencrypt"
}

"uses the ClusterIssuer named default when none is named": test.#TraitRender & _cert & {
	parameter: dnsNames: ["shop.example.com"]
	expect: outputs: certificate: spec: issuerRef: {group: "cert-manager.io", kind: "ClusterIssuer", name: "default"}
}

"refuses a certificate for no names": test.#TraitRender & _cert & {
	parameter: {dnsNames: [], issuerRef: name: "letsencrypt"}
	expect: error: =~"dnsNames"
}

"ready once issued, naming the Secret": test.#TraitStatus & _cert & {
	parameter: {dnsNames: ["shop.example.com"], issuerRef: name: "letsencrypt"}
	observed: outputs: certificate: status: conditions: [{type: "Ready", status: "True", message: "Certificate is up to date and has not expired"}]
	expect: {
		healthy: true
		message: "Certificate is up to date and has not expired"
		details: secretName: "shop-tls"
	}
}

"not ready while the order is pending": test.#TraitStatus & _cert & {
	parameter: {dnsNames: ["shop.example.com"], issuerRef: name: "letsencrypt"}
	observed: outputs: certificate: status: conditions: [{type: "Ready", status: "False", message: "Issuing certificate as Secret does not exist"}]
	expect: {healthy: false, message: "Issuing certificate as Secret does not exist"}
}

"ready with no message says Ready": test.#TraitStatus & _cert & {
	parameter: {dnsNames: ["shop.example.com"], issuerRef: name: "letsencrypt"}
	observed: outputs: certificate: status: conditions: [{type: "Ready", status: "True", reason: "Ready"}]
	expect: {healthy: true, message: "Ready"}
}
