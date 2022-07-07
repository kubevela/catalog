import (
	"vela/ql"
	"encoding/yaml"
)

analytics: ql.#List & {
	resource: {
		apiVersion: "analysis.crane.io/v1alpha1"
		kind:       "Recommendation"
	}
	filter: {
		matchingLabels: {
			"analysis.crane.io/analytics-name": parameter.appName + "-" + parameter.componentName + "-resource"
		}
	}
}

parameter: {
	ns:            *"default" | string
	appName:       string
	componentName: string
}

status: {
	if len(analytics.list.items) > 0 {
		recommendedValues: [
			for _, r in analytics.list.items {
				yaml.Unmarshal(r.status.recommendedValue)
			},
		]
	}
	if len(analytics.list.items) == 0 {
		err: analytics.err
	}
}
