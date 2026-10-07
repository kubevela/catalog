import (
	"strings"
	"vela/builtin"
	"vela/kube"
)

"defkit-render": {
	type: "workflow-step"
	annotations: category: "DefKit"
	labels: "defkit.oam.dev/step": "render"
	description: "Render a DefKit module in a Job into a ConfigMap of definitions (experimental)"
}
template: {
	// One render per run: the step's session is new each time the workflow
	// runs, so a moving branch is fetched again, and steady within a run.
	_name: "\(context.name)-\(strings.ToLower(context.stepSessionID))"

	settings: kube.#Read & {
		$params: value: {
			apiVersion: "v1"
			kind:       "ConfigMap"
			metadata: {name: "defkit-settings", namespace: "vela-defkit"}
		}
	}

	job: kube.#Apply & {
		$params: value: {
			apiVersion: "batch/v1"
			kind:       "Job"
			metadata: {
				name:      _name
				namespace: "vela-defkit"
				labels: "defkit.oam.dev/module": context.name
			}
			spec: {
				backoffLimit: 1
				// The module re-renders on its interval, so a Job outlasting one
				// is stale: it is stopped, then deleted shortly after it ends.
				activeDeadlineSeconds:   600
				ttlSecondsAfterFinished: 300
				template: spec: {
					serviceAccountName: "defkit-render"
					restartPolicy:      "Never"
					securityContext: {runAsNonRoot: true, runAsUser: 65532}
					containers: [{
						name:  "render"
						image: settings.$returns.value.data.image
						imagePullPolicy: "IfNotPresent"
						args: [
							if parameter.git != "" {"--git=\(parameter.git)"},
							if parameter.git == "" {"--ref=\(parameter.ref)"},
							"--version=\(parameter.version)",
							"--prefix=\(parameter.prefix)",
							"--types=\(strings.Join(parameter.types, ","))",
							"--configmap=vela-defkit/\(_name)",
							"--module=\(context.name)",
						]
						// Without requests the limits are requested too, and a render
						// waits for two free CPUs.
						resources: {
							requests: {cpu: "100m", memory: "256Mi"}
							limits: {cpu: "2", memory: "2Gi"}
						}
					}]
				}
			}
		}
	}

	_status: *{} | {...}
	if job.$returns.value.status != _|_ {
		_status: job.$returns.value.status
	}
	_succeeded: (_status.succeeded & >0) != _|_
	// Failed covers retries exhausted and the deadline passed alike.
	_failed: len([for c in *_status.conditions | [] if c.type == "Failed" && c.status == "True" {c}]) > 0

	wait: builtin.#ConditionalWait & {
		$params: {
			continue: _succeeded || _failed
			message:  "rendering \(parameter.ref)\(parameter.git) \(parameter.version)"
		}
	}
	if _failed {
		fail: builtin.#Fail & {
			$params: message: "render Job vela-defkit/\(_name) failed; see its logs"
		}
	}

	// The ConfigMap the apply step and VelaUX's preview read.
	configMap: _name

	parameter: {
		// +usage=Go module path of the module; or set git
		ref: *"" | string
		// +usage=Git repository of the module, in place of ref
		git: *"" | string
		// +usage=Module version; with git, a branch, tag or commit
		version: *"" | string
		// +usage=Prefix for every definition name
		prefix: *"" | string
		// +usage=Definition types to render; all when empty
		types: *[] | [...("component" | "trait" | "policy" | "workflow-step")]
	}
}
