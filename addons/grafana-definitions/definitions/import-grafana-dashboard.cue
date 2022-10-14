import (
	"encoding/json"
	"vela/op"
)

"import-grafana-dashboard": {
	alias: ""
	annotations: {}
	description: "Import dashboard to grafana."
	type:        "workflow-step"
}

template: {

	loadData: op.#Steps & {
		data: string
		if parameter.data != _|_ {
			data: parameter.data
		}
		if parameter.data == _|_ && parameter.url != _|_ {
			r: op.#HTTPGet & {
				url: parameter.url
			}     @step(1)
			data: r.response.body @step(2)
		}
	} @step(1)

	source: json.Unmarshal(loadData.data) @step(2)

	overrides: {
		uid: string
		if parameter.uid != _|_ {
			uid: parameter.uid
		}
		if parameter.uid == _|_ {
			uid: source.uid
		}

        title: string
		if parameter.title != _|_ {
			title: parameter.title
		}
		if parameter.title == _|_ {
			title: source.title
		}

		varList: *[] | [...{...}]
		varMap:  *{} | {...}
		if source.templating != _|_ && source.templating.list != _|_ {
			varList: source.templating.list
			varMap: {for v in source.templating.list {
				"\(v.name)": v
			}}
		}

		extList: *[] | [...{...}]
		if source["__inputs"] != _|_ {
			extList: [ for input in source["__inputs"] if input.type == "datasource" && varMap[input.name] == _|_ {
				name:    input.name
				type:    input.type
				label:   input.label
				query:   input.pluginId
				refresh: 1
				hide:    0
			}]
		}

		templating: list: varList + extList
	} @step(3)

	model: {
		for k, v in source {
			if k != "uid" && k != "title" && k != "__inputs" && k != "__requires" && k != "templating" && k != "__elements" {
				"\(k)": v
			}
		}
		uid:        overrides.uid
        title:      overrides.title
		templating: overrides.templating
	} @step(4)

	apply: op.#Apply & {
		value: {
			apiVersion: "o11y.prism.oam.dev/v1alpha1"
			kind:       "GrafanaDashboard"
			metadata: name: "\(model.uid)@\(parameter.grafana)"
			spec: model
		}
	} @step(5)

	parameter: {
		// +usage=The name of the grafana instance.
		grafana: *"default" | string
		// +usage=The json model of the grafana dashboard.
		data?: string
		// +usage=The url link of the grafana dashboard.
		url?: string
		// +usage=The uid of the grafana dashboard, if not specified, the default uid will be used.
		uid?: string
        // +usage=The title of the grafana dashboard, if not specified, the default title will be used.
        title?: string
	}
}
