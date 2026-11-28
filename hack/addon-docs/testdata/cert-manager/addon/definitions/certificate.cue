"certificate": {
	type:        "trait"
	description: "Issues a TLS certificate for the component with cert-manager, into a Secret its gateway or ingress can serve."
	annotations: {}
	labels: {}
	attributes: {
		appliesToWorkloads: ["*"]
		podDisruptive: false
		status: {
			healthPolicy: #"""
				_ready: [if context.outputs.certificate.status.conditions != _|_ for c in context.outputs.certificate.status.conditions if c.type == "Ready" {c}]
				isHealth: len([for c in _ready if c.status == "True" {c}]) > 0
				"""#
			customStatus: #"""
				_ready: [if context.outputs.certificate.status.conditions != _|_ for c in context.outputs.certificate.status.conditions if c.type == "Ready" {c}]
				message: [
					for c in _ready if c.message != _|_ if c.message != "" {c.message},
					for c in _ready if c.status == "True" {"Ready"},
					for c in _ready if c.reason != _|_ {c.reason},
					"Waiting for cert-manager",
				][0]
				"""#
			details: #"""
				secretName: context.outputs.certificate.spec.secretName
				"""#
		}
	}
}

template: {
	// The namespace's issuer, when the cert-manager-default-issuer policy found one.
	_namespaceRef: *(context.custom.certManager.issuerRef & {kind: "ClusterIssuer" | "Issuer", name: string}) | null
	_issuerRef: [
		if parameter.issuerRef != _|_ {parameter.issuerRef},
		if _namespaceRef != null {_namespaceRef},
		{kind: "ClusterIssuer", name: "default"},
	][0]

	outputs: certificate: {
		apiVersion: "cert-manager.io/v1"
		kind:       "Certificate"
		metadata: name: context.name
		spec: {
			secretName: parameter.secretName
			dnsNames:   parameter.dnsNames
			issuerRef: {group: "cert-manager.io", kind: _issuerRef.kind, name: _issuerRef.name}
			if parameter.duration != _|_ {duration: parameter.duration}
			if parameter.renewBefore != _|_ {renewBefore: parameter.renewBefore}
		}
	}

	parameter: {
		// +usage=Host names the certificate covers
		// +ui:label=DNS Names
		dnsNames: [string, ...string]
		// +usage=Secret the certificate and key are written to
		// +ui:label=Secret Name
		secretName: *"\(context.name)-tls" | string
		// +usage=Issuer to use. Leave it out for the namespace's issuer, or else the ClusterIssuer named default
		// +ui:label=Issuer Ref
		issuerRef?: {
			// +ui:label=Name
			name: string
			// +ui:label=Kind
			kind: *"ClusterIssuer" | "Issuer"
		}
		// +usage=Lifetime to request, e.g. 2160h. The issuer may grant less
		// +ui:label=Duration
		duration?: string
		// +usage=How long before expiry to renew, e.g. 360h
		// +ui:label=Renew Before
		renewBefore?: string
	}
}
