package main

certManager: {
	name: "cert-manager"
	type: "helm"
	dependsOn: ["cert-manager-ns"]
	properties: {
		repoType:        "helm"
		url:             "https://charts.jetstack.io"
		chart:           "cert-manager"
		targetNamespace: parameter.namespace
		version:         "v1.9.1"
		values: {
			installCRDs:  parameter.installCRDs
			replicaCount: parameter.replicas

			// These are all Cloudflare configs, since we only support
            // Cloudflare for now.
            // If you want to add your own DNS provider config, e.g. Aliyun DNS
            // you will need some if-conditions. For example, you will need
            // different name servers. Contact @charlie0129 if you have questions.
			if parameter.dns01 != _|_ {
				// Prevent KubeDNS interfering with our DNS01 Challenge if
				// local DNS have the same DNS record.
				// This will not affect cluster DNS resolution since cert-manager
				// is only for resolving certificates.
				extraArgs: [
					"--dns01-recursive-nameservers=1.1.1.1:53",
					"--dns01-recursive-nameservers-only",
				]
				podDnsPolicy: "None"
				podDnsConfig: nameservers: ["1.1.1.1"]
			}

		}
	}
}
