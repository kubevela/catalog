import (
	"encoding/json"
	"list"
	"strings"
	"vela/builtin"
	"vela/kube"
)

"defkit-apply": {
	type: "workflow-step"
	annotations: category: "DefKit"
	labels: "defkit.oam.dev/step": "apply"
	description: "Apply the definitions a defkit-render step produced, as this Application's resources (experimental)"
}
template: {
	rendered: kube.#Read & {
		$params: value: {
			apiVersion: "v1"
			kind:       "ConfigMap"
			metadata: {name: parameter.configMap, namespace: "vela-defkit"}
		}
	}
	// A render that cannot be read, or has no definitions.json, fails the step.
	if rendered.$returns.err != _|_ {
		renderUnreadable: builtin.#Fail & {
			$params: message: "read render vela-defkit/\(parameter.configMap): \(rendered.$returns.err)"
		}
	}
	if rendered.$returns.err == _|_
	if rendered.$returns.value != _|_
	if rendered.$returns.value.data["definitions.json"] == _|_ {
		renderIncomplete: builtin.#Fail & {
			$params: message: "render vela-defkit/\(parameter.configMap) has no definitions.json"
		}
	}
	_data: *{} | {...}
	if rendered.$returns.err == _|_
	if rendered.$returns.value.data != _|_ {
		_data: rendered.$returns.value.data
	}
	// A render with errors fails the step and applies none of its definitions.
	_errs: *[] | [...string]
	if _data["errors.json"] != _|_ {
		_errs: json.Unmarshal(_data["errors.json"])
	}
	if len(_errs) > 0 {
		renderFailed: builtin.#Fail & {
			$params: message: "render vela-defkit/\(parameter.configMap) failed for \(len(_errs)) definitions: \(strings.Join(list.Take(_errs, 3), "; "))"
		}
	}
	_defs: *[] | [...{...}]
	if len(_errs) == 0
	if _data["definitions.json"] != _|_ {
		_defs: json.Unmarshal(_data["definitions.json"])
	}

	// Each rendered definition as the cluster has it, if it does.
	existing: {
		for d in _defs {
			"\(d.kind)-\(d.metadata.name)": kube.#Read & {
				$params: value: {
					apiVersion: d.apiVersion
					kind:       d.kind
					metadata: {name: d.metadata.name, namespace: context.namespace}
				}
			}
		}
	}
	_me: "\(context.namespace)/\(context.name)"

	// writable are the definitions this module may write: those not there yet
	// and those it already owns. Anything else, owned by another or by nobody,
	// is never applied. Membership is tested positively, and the clauses are
	// chained so each is read only where the one before holds: a read that
	// does not evaluate fails the step rather than reading as writable.
	_new: [
		for d in _defs
		let r = existing["\(d.kind)-\(d.metadata.name)"].$returns
		if r.err != _|_
		if strings.Contains(r.err, "not found") {"\(d.kind)/\(d.metadata.name)"},
	]
	_owned: [
		for d in _defs
		let r = existing["\(d.kind)-\(d.metadata.name)"].$returns
		if r.err == _|_
		let labels = *r.value.metadata.labels | {}
		if (*labels["app.oam.dev/namespace"] | "") + "/" + (*labels["app.oam.dev/name"] | "") == _me {"\(d.kind)/\(d.metadata.name)"},
	]
	_writable: list.Concat([_new, _owned])
	readFailed: {
		for d in _defs
		let r = existing["\(d.kind)-\(d.metadata.name)"].$returns
		if r.err != _|_
		if !strings.Contains(r.err, "not found") {
			"\(d.kind)-\(d.metadata.name)": builtin.#Fail & {
				$params: message: "read \(d.kind) \(d.metadata.name): \(r.err)"
			}
		}
	}

	apply: {
		for d in _defs
		let id = "\(d.kind)/\(d.metadata.name)"
		if list.Contains(_writable, id)
		if !list.Contains(parameter.skip, id) {
			"\(strings.Replace(id, "/", "-", -1))": kube.#Apply & {
				$params: value: d & {metadata: namespace: context.namespace}
			}
		}
	}

	parameter: {
		// +usage=The ConfigMap in vela-defkit the render step wrote
		configMap: string
		// +usage=Definitions to leave alone, as Kind/name
		skip: *[] | [...string]
	}
}
