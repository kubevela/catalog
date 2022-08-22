import "strings"

output: {
	type: "k8s-objects"
	properties: {
		objects: [{
			apiVersion: "v1"
			kind:       "Secret"
			metadata: {
				name:      "ec-account-creds"
				namespace: "vela-system"
			}
			type: "Opaque"
					stringData: credentials: strings.Join([
							"ecApiKey: " + parameter.EC_API_KEY,
						], "\n")
		}]
	}
}
