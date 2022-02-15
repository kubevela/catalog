parameter: {
	{{- with .Properties -}}
          {{- range . }}
	//+usage={{ .Description }}
	{{ .Name }}: *"" | string
          {{- end -}}
        {{- end }}
}
