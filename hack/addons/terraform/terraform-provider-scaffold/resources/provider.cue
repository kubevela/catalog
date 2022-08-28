output: {
	type: "k8s-objects"
	properties: {
		objects: [
		{
			apiVersion: "terraform.core.oam.dev/v1beta1"
			kind:       "Provider"
			metadata: {
				name:      "{{ .Name }}"
				namespace: "default"
			}
			spec: {
				provider: "{{ .Name }}"

	        {{- with .Properties -}}
            {{- range . -}}
					{{- if eq .IsRegion true }}
				region:   parameter.{{ .Name}}
          	  {{- end -}}
        	{{- end -}}
	    	{{- end }}
				credentials: {
					source: "Secret"
					secretRef: {
						namespace: "vela-system"
						name:      "{{ .Name }}-account-creds"
						key:       "credentials"
					}
				}
			}
		}]
	}
}
