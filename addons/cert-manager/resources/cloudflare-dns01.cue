package main

cfTokenSecret: _
cfCertificate: _
cfIssuer:      _

if parameter.dns01 != _|_ && parameter.dns01.cloudflare != _|_ {
	cfTokenSecret: {
		apiVersion: "v1"
		kind:       "Secret"
		metadata: {
			name:      "cloudflare-token-secret"
			namespace: parameter.namespace
		}
		type: "Opaque"
		stringData: {
			"cloudflare-token": parameter.dns01.cloudflare.token
		}
	}

	cfCertificate: {
		apiVersion: "cert-manager.io/v1"
		kind:       "Certificate"
		metadata: {
			name:      "cloudflare-certificate"
			namespace: parameter.dns01.namespace
		}
		spec: {
			secretName: "cloudflare-tls"
			issuerRef: {
				name: "letsencrypt"
				kind: "ClusterIssuer"
			}
			commonName: "*." + parameter.dns01.cloudflare.domain
			dnsNames: [
				parameter.dns01.cloudflare.domain,
				"*." + parameter.dns01.cloudflare.domain,
			]
		}

	}

	cfIssuer: {
		apiVersion: "cert-manager.io/v1"
		kind:       "ClusterIssuer"
		metadata: name: "letsencrypt"
		spec: acme: {
			if parameter.staging {
				server: "https://acme-staging-v02.api.letsencrypt.org/directory"
			}
			if !parameter.staging {
				server: "https://acme-v02.api.letsencrypt.org/directory"
			}
			email: parameter.dns01.cloudflare.email
			privateKeySecretRef: name: "letsencrypt-private-key"
			solvers: [{
				dns01: cloudflare: {
					email: parameter.dns01.cloudflare.email
					apiTokenSecretRef: {
						name: "cloudflare-token-secret"
						key:  "cloudflare-token"
					}
				}
				selector: dnsZones: [parameter.dns01.cloudflare.zone]
			}]
		}
	}
}
