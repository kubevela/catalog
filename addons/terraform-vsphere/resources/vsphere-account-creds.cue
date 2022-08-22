import "strings"

output: {
	type: "k8s-objects"
	properties: {
		objects: [{
			apiVersion: "v1"
			kind:       "Secret"
			metadata: {
				name:      "vsphere-account-creds"
				namespace: "vela-system"
			}
			type: "Opaque"
					stringData: credentials: strings.Join([
							"vSphereUser: " + parameter.VSPHERE_USER,
						
							"vSpherePassword: " + parameter.VSPHERE_PASSWORD,
						
							"vSphereServer: " + parameter.VSPHERE_SERVER,
						
							"vSphereAllowUnverifiedSSL: " + parameter.VSPHERE_ALLOW_UNVERIFIED_SSL,
						], "\n")
		}]
	}
}
