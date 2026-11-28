"issuer": {
	type:        "component"
	description: "A cert-manager issuer: an ACME account (Let's Encrypt by default), a self-signed issuer, or a CA signing with a key pair from a Secret."
	annotations: {}
	labels: {}
	attributes: {
		workload: type: "autodetects.core.oam.dev"
		status: {
			healthPolicy: #"""
				_ready: [if context.output.status.conditions != _|_ for c in context.output.status.conditions if c.type == "Ready" {c}]
				isHealth: len([for c in _ready if c.status == "True" {c}]) > 0
				"""#
			customStatus: #"""
				_ready: [if context.output.status.conditions != _|_ for c in context.output.status.conditions if c.type == "Ready" {c}]
				message: [
					for c in _ready if c.message != _|_ if c.message != "" {c.message},
					for c in _ready if c.status == "True" {"Ready"},
					for c in _ready if c.reason != _|_ {c.reason},
					"Waiting for cert-manager",
				][0]
				"""#
		}
	}
}

template: {
	_servers: {
		production: "https://acme-v02.api.letsencrypt.org/directory"
		staging:    "https://acme-staging-v02.api.letsencrypt.org/directory"
	}
	_types: [for k in ["acme", "selfSigned", "ca"] if parameter[k] != _|_ {k}]

	errs: [
		if len(_types) != 1 {"an issuer is exactly one of acme, selfSigned or ca"},
		if parameter.acme != _|_ if parameter.acme.http01 == _|_ if parameter.acme.dns01 == _|_ {
			"an ACME issuer needs http01 or dns01 to solve its challenges"
		},
		if parameter.acme != _|_ if parameter.acme.http01 != _|_ if len([for k in ["ingressClassName", "gateway"] if parameter.acme.http01[k] != _|_ {k}]) != 1 {
			"http01 solves through exactly one of ingressClassName or gateway"
		},
		if parameter.acme != _|_ if parameter.acme.dns01 != _|_ if len([for k in ["cloudflare", "route53"] if parameter.acme.dns01[k] != _|_ {k}]) != 1 {
			"dns01 solves through exactly one of cloudflare or route53"
		},
	]

	output: {
		apiVersion: "cert-manager.io/v1"
		kind: [if parameter.scope == "cluster" {"ClusterIssuer"}, "Issuer"][0]
		metadata: {
			name: context.name
			if parameter.scope == "namespace" {namespace: context.namespace}
		}
		spec: {
			if parameter.acme != _|_ {
				acme: {
					server: [if _servers[parameter.acme.server] != _|_ {_servers[parameter.acme.server]}, parameter.acme.server][0]
					email: parameter.acme.email
					privateKeySecretRef: name: *"\(context.name)-account-key" | string
					if parameter.acme.privateKeySecretName != _|_ {privateKeySecretRef: name: parameter.acme.privateKeySecretName}
					solvers: [
						if parameter.acme.http01 != _|_ {
							http01: {
								if parameter.acme.http01.ingressClassName != _|_ {
									ingress: ingressClassName: parameter.acme.http01.ingressClassName
								}
								if parameter.acme.http01.gateway != _|_ {
									gatewayHTTPRoute: parentRefs: [parameter.acme.http01.gateway & {kind: "Gateway"}]
								}
							}
						},
						if parameter.acme.dns01 != _|_ {
							dns01: parameter.acme.dns01
						},
					]
				}
			}
			if parameter.selfSigned != _|_ {selfSigned: {}}
			if parameter.ca != _|_ {ca: secretName: parameter.ca.secretName}
		}
	}

	#SecretKeyRef: {
		// +usage=Name of the Secret. For a ClusterIssuer it is read from cert-manager's namespace
		name: string
		// +usage=Key in the Secret
		key: string
	}

	parameter: {
		// +usage=cluster makes a ClusterIssuer any namespace can use; namespace makes an Issuer in the Application's namespace
		// +ui:label=Scope
		scope: *"cluster" | "namespace"
		// +usage=Issue from an ACME server, such as Let's Encrypt
		// +ui:label=ACME
		acme?: {
			// +usage=production or staging for Let's Encrypt, or the directory URL of another ACME server
			// +ui:label=Server
			server: *"production" | string
			// +usage=Email for the ACME account, which the server uses for expiry notices
			// +ui:label=Email
			email: string
			// +usage=Secret the ACME account's private key is stored in. Defaults to <name>-account-key
			// +ui:label=Private Key Secret Name
			privateKeySecretName?: string
			// +usage=Solve HTTP-01 challenges through an ingress class or a Gateway
			// +ui:label=HTTP01
			http01?: {
				// +usage=Ingress class that routes the challenge
				// +ui:label=Ingress Class Name
				ingressClassName?: string
				// +usage=Gateway that routes the challenge
				// +ui:label=Gateway
				gateway?: {
					// +ui:label=Name
					name: string
					// +ui:label=Namespace
					namespace?: string
				}
			}
			// +usage=Solve DNS-01 challenges, needed for wildcard certificates. Credentials are read from Secrets you create
			// +ui:label=DNS01
			dns01?: {
				// +usage=Cloudflare, with an API token that can edit the zone
				// +ui:label=Cloudflare
				cloudflare?: apiTokenSecretRef: #SecretKeyRef
				// +usage=Route53. Leave the key refs out to use the pod's ambient credentials (IRSA, Pod Identity)
				// +ui:label=Route53
				route53?: {
					// +ui:label=Region
					region: string
					// +ui:label=Hosted Zone ID
					hostedZoneID?: string
					// +ui:label=Role
					role?: string
					// +ui:label=Access Key ID Secret Ref
					accessKeyIDSecretRef?: #SecretKeyRef
					// +ui:label=Secret Access Key Secret Ref
					secretAccessKeySecretRef?: #SecretKeyRef
				}
			}
		}
		// +usage=Sign certificates with their own key
		// +ui:label=Self Signed
		selfSigned?: {}
		// +usage=Sign certificates with a CA key pair
		// +ui:label=CA
		ca?: {
			// +usage=Secret holding the CA's tls.crt and tls.key
			// +ui:label=Secret Name
			secretName: string
		}
	}
}
