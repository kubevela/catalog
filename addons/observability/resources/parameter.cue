parameter: {
	"grafana-domain":           *"" | string

	"alertmanager-pvc-enabled": *true | bool
	"alertmanager-pvc-class":   *"" | string
	"alertmanager-pvc-size":    *"20Gi" | string

	"server-pvc-enabled": *true | bool
	"server-pvc-class":   *"" | string
	"server-pvc-size":    *"20Gi" | string
}
