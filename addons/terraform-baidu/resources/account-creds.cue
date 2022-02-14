import "strings"

output: {
	type: "raw"
	properties: {
		apiVersion: "v1"
		kind:       "Secret"
		metadata: {
			name:      "baidu-account-creds"
			namespace: "vela-system"
		}
		type: "Opaque"
		stringData: credentials: strings.Join([
							"accessKey: " + parameter.BAIDUCLOUD_ACCESS_KEY,
						
							"secretKey: " + parameter.BAIDUCLOUD_SECRET_KEY,
						], "\n")
	}
}

