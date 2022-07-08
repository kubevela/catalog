import (
	"vela/ql"
	"encoding/yaml"
	"strings"
)

analytics: ql.#List & {
	resource: {
		apiVersion: "analysis.crane.io/v1alpha1"
		kind:       "Recommendation"
	}
	filter: {
		if parameter.ns != _|_ {
			namespace: parameter.ns
		}
		if parameter.componentName != _|_ && parameter.appName != _|_ {
			matchingLabels: {
				"analysis.crane.io/analytics-name": parameter.appName + "-" + parameter.componentName + "-resource"
			}
		}
	}
}

parameter: {
	ns?:            *"default" | string
	appName:        string
	componentName?: string
}

status: {
	if len(analytics.list.items) > 0 {
		recommendedValues: [
			for _, r in analytics.list.items if strings.HasPrefix(r.metadata.labels["analysis.crane.io/analytics-name"], parameter.appName) {
				yaml.Unmarshal(r.status.recommendedValue)
			},
		]
	}
	if len(analytics.list.items) == 0 {
		err: analytics.err
	}
}
