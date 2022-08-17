import "strings"

output: {
	type: "k8s-objects"
	properties: {
		objects: [{
			apiVersion: "v1"
			kind:       "Secret"
			metadata: {
				name:      "{{ .Name }}-account-creds"
				namespace: "vela-system"
			}
			type: "Opaque"
					stringData: credentials: strings.Join([
				{{- with .Properties -}}
          {{- range . -}}
            {{- if ne .SecretKey "" }}
							"{{ .SecretKey}}: " + parameter.{{ .Name}},
						{{ end -}}
          {{- end -}}
        {{- end -}}
			], "\n")
		}]
	}
}
