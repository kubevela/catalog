package main

alidnsWebhook: _
alidnsTokenSecret: _
alidnsCertificate: _
alidnsIssuer:      _

clusterIssuerName: "letsencrypt"

if parameter.dns01 != _|_ && parameter.dns01.alidns != _|_ {
  alidnsWebhook: {
    name: "alidns-webhook"
    type: "helm"
    dependsOn: ["cert-manager"]
    properties: {
      repoType:        "helm"
      url:             "https://devmachine-fr.github.io/cert-manager-alidns-webhook"
      chart:           "alidns-webhook"
      targetNamespace: parameter.namespace
      version:         "0.6.1"
      values: {
        groupName: parameter.dns01.alidns.groupName
				// set cert-manager service account name according to namespace name
				certManager: {
					namespace: parameter.namespace
					serviceAccountName: parameter.namespace + "-cert-manager"
				}
      }
    }
  }

	alidnsTokenSecret: {
		apiVersion: "v1"
		kind:       "Secret"
		metadata: {
			name:      "alidns-token-secret"
			namespace: parameter.namespace
		}
		type: "Opaque"
		stringData: {
			"access-token": parameter.dns01.alidns.accessToken
      "secret-key": parameter.dns01.alidns.secretKey
		}
	}

	alidnsCertificate: {
		apiVersion: "cert-manager.io/v1"
		kind:       "Certificate"
		metadata: {
			name:      "alidns-certificate"
			namespace: parameter.dns01.namespace
		}
		spec: {
			secretName: alidnsCertificate.metadata.name + "-tls"
			issuerRef: {
				name: clusterIssuerName
				kind: "ClusterIssuer"
			}
			commonName: "*." + parameter.dns01.alidns.groupName
			dnsNames: [
				parameter.dns01.alidns.groupName,
				"*." + parameter.dns01.alidns.groupName,
			]
		}

	}

	alidnsIssuer: {
		apiVersion: "cert-manager.io/v1"
		kind:       "ClusterIssuer"
		metadata: name: clusterIssuerName
		spec: acme: {
			if parameter.staging {
				server: "https://acme-staging-v02.api.letsencrypt.org/directory"
			}
			if !parameter.staging {
				server: "https://acme-v02.api.letsencrypt.org/directory"
			}
			email: parameter.dns01.alidns.email
			privateKeySecretRef: name: "letsencrypt-private-key"
			solvers: [{
				dns01: webhook: {
          config: {
            accessTokenSecretRef: {
              key: "access-token"
              name: "alidns-token-secret"
            }
            secretKeySecretRef: {
              key: "secret-key"
              name: "alidns-token-secret"
            }
            regionId: parameter.dns01.alidns.regionId
          }
					groupName: parameter.dns01.alidns.groupName
          solverName: "alidns-solver"
				}
			}]
		}
	}
}