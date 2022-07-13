import (
	"encoding/base64"
)

// if parameter.google != _|_ {
//   -> This if-statement requires CLI v1.5 or later. (#4347)
//   -> And it is commented-out because v1.5 is not available yet.
//   -> TODO(charlie0129): uncomment it once v1.5 is widely available.
output: {
	type: "k8s-objects"
	properties: {
		objects: [{
			apiVersion: "v1"
			kind:       "Secret"
			metadata: {
				name:      "chartmuseum-gcs-credential"
				namespace: "vela-system"
			}
			type: "Opaque"
			data: {
				// Remove this if-statement, if the outer one is used.
				if parameter.google != _|_ {
					json: base64.Encode(null, parameter.google.googleCredentialsJSON)
				}
			}
		}]
	}
}
// }
