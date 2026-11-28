import "vela/test"

_issuer: {
	definition: "../definitions/issuer"
	context: {name: "letsencrypt", namespace: "shop"}
}

"an ACME ClusterIssuer on Let's Encrypt production, solving over an ingress class": test.#ComponentRender & _issuer & {
	parameter: acme: {email: "ops@example.com", http01: ingressClassName: "traefik"}
	expect: output: {
		apiVersion: "cert-manager.io/v1"
		kind:       "ClusterIssuer"
		metadata: name: "letsencrypt"
		spec: acme: {
			server: "https://acme-v02.api.letsencrypt.org/directory"
			email:  "ops@example.com"
			privateKeySecretRef: name: "letsencrypt-account-key"
			solvers: [{http01: ingress: ingressClassName: "traefik"}]
		}
	}
}

"staging is a name for Let's Encrypt staging": test.#ComponentRender & _issuer & {
	parameter: acme: {server: "staging", email: "ops@example.com", http01: ingressClassName: "traefik"}
	expect: output: spec: acme: server: "https://acme-staging-v02.api.letsencrypt.org/directory"
}

"any other ACME server is taken as a URL": test.#ComponentRender & _issuer & {
	parameter: acme: {server: "https://acme.zerossl.com/v2/DV90", email: "ops@example.com", http01: ingressClassName: "traefik"}
	expect: output: spec: acme: server: "https://acme.zerossl.com/v2/DV90"
}

"http01 through a Gateway": test.#ComponentRender & _issuer & {
	parameter: acme: {email: "ops@example.com", http01: gateway: {name: "public", namespace: "gateways"}}
	expect: output: spec: acme: solvers: [{http01: gatewayHTTPRoute: parentRefs: [{name: "public", namespace: "gateways", kind: "Gateway"}]}]
}

"dns01 on Cloudflare reads the token from a Secret": test.#ComponentRender & _issuer & {
	parameter: acme: {email: "ops@example.com", dns01: cloudflare: apiTokenSecretRef: {name: "cloudflare", key: "token"}}
	expect: output: spec: acme: solvers: [{dns01: cloudflare: apiTokenSecretRef: {name: "cloudflare", key: "token"}}]
}

"dns01 on Route53 with ambient credentials": test.#ComponentRender & _issuer & {
	parameter: acme: {email: "ops@example.com", dns01: route53: region: "eu-west-1"}
	expect: output: spec: acme: solvers: [{dns01: route53: {region: "eu-west-1", accessKeyIDSecretRef?: _|_, secretAccessKeySecretRef?: _|_}}]
}

"a self-signed issuer": test.#ComponentRender & _issuer & {
	parameter: selfSigned: {}
	expect: output: spec: selfSigned: {}
}

"a CA issuer signs with a Secret's key pair": test.#ComponentRender & _issuer & {
	parameter: ca: secretName: "root-ca"
	expect: output: spec: ca: secretName: "root-ca"
}

"a namespaced Issuer lives in the Application's namespace": test.#ComponentRender & _issuer & {
	parameter: {scope: "namespace", selfSigned: {}}
	expect: output: {kind: "Issuer", metadata: {name: "letsencrypt", namespace: "shop"}}
}

"refuses an issuer of no type": test.#ComponentRender & _issuer & {
	parameter: {}
	expect: error: =~"exactly one of acme, selfSigned or ca"
}

"refuses an issuer of two types": test.#ComponentRender & _issuer & {
	parameter: {selfSigned: {}, ca: secretName: "root-ca"}
	expect: error: =~"exactly one of acme, selfSigned or ca"
}

"refuses an ACME issuer with no solver": test.#ComponentRender & _issuer & {
	parameter: acme: email: "ops@example.com"
	expect: error: =~"http01 or dns01"
}

"ready once cert-manager reports Ready": test.#ComponentStatus & _issuer & {
	parameter: selfSigned: {}
	observed: output: status: conditions: [{type: "Ready", status: "True", message: "Signing CA verified"}]
	expect: {healthy: true, message: "Signing CA verified"}
}

"not ready while the ACME account registers": test.#ComponentStatus & _issuer & {
	parameter: acme: {email: "ops@example.com", http01: ingressClassName: "traefik"}
	observed: output: status: conditions: [{type: "Ready", status: "False", message: "Failed to register ACME account"}]
	expect: {healthy: false, message: "Failed to register ACME account"}
}

"not ready before cert-manager has looked at it": test.#ComponentStatus & _issuer & {
	parameter: selfSigned: {}
	expect: {healthy: false, message: "Waiting for cert-manager"}
}

"ready with no message says Ready, as a self-signed issuer reports it": test.#ComponentStatus & _issuer & {
	parameter: selfSigned: {}
	observed: output: status: conditions: [{type: "Ready", status: "True", reason: "IsReady"}]
	expect: {healthy: true, message: "Ready"}
}

"not ready with no message gives the reason": test.#ComponentStatus & _issuer & {
	parameter: ca: secretName: "root-ca"
	observed: output: status: conditions: [{type: "Ready", status: "False", reason: "ErrGetKeyPair"}]
	expect: {healthy: false, message: "ErrGetKeyPair"}
}
