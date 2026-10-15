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
				labels: {
					"defkit.oam.dev/module":           context.name
					"defkit.oam.dev/module-namespace": context.namespace
				}
			}
			spec: {
				backoffLimit: 1
				// The module re-renders on its interval, so a Job outlasting one
				// is stale: it is stopped, then deleted shortly after it ends.
				activeDeadlineSeconds:   600
				ttlSecondsAfterFinished: 300
				template: spec: {
					serviceAccountName: "defkit-render"
					// The module's code runs in the render container, which has no
					// token; only the write container mounts the account's.
					automountServiceAccountToken: false
					restartPolicy:                "Never"
					securityContext: {runAsNonRoot: true, runAsUser: 65532}
					volumes: [{
						name: "work"
						emptyDir: {}
					}, {
						name: "token"
						projected: sources: [{
							serviceAccountToken: path: "token"
						}, {
							configMap: {name: "kube-root-ca.crt", items: [{key: "ca.crt", path: "ca.crt"}]}
						}, {
							downwardAPI: items: [{path: "namespace", fieldRef: fieldPath: "metadata.namespace"}]
						}]
					}]
					initContainers: [{
						name:            "render"
						image:           settings.$returns.value.data.image
						imagePullPolicy: "IfNotPresent"
						args: [
							if parameter.git != "" {"--git=\(parameter.git)"},
							if parameter.git == "" {"--ref=\(parameter.ref)"},
							"--version=\(parameter.version)",
							"--prefix=\(parameter.prefix)",
							"--types=\(strings.Join(parameter.types, ","))",
							"--out=/work/result.json",
						]
						// Without requests the limits are requested too, and a render
						// waits for two free CPUs.
						resources: {
							requests: {cpu: "100m", memory: "256Mi"}
							limits: {cpu: "2", memory: "2Gi"}
						}
						volumeMounts: [{name: "work", mountPath: "/work"}]
					}]
					containers: [{
						name:            "write"
						image:           settings.$returns.value.data.image
						imagePullPolicy: "IfNotPresent"
						args: [
							"--from=/work/result.json",
							"--configmap=vela-defkit/\(_name)",
							"--module=\(context.name)",
							"--module-namespace=\(context.namespace)",
						]
						resources: {
							requests: {cpu: "10m", memory: "32Mi"}
							limits: {cpu: "200m", memory: "128Mi"}
						}
						volumeMounts: [{
							name:      "work"
							mountPath: "/work"
							readOnly:  true
						}, {
							name:      "token"
							mountPath: "/var/run/secrets/kubernetes.io/serviceaccount"
							readOnly:  true
						}]
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
			// The git URL is left out: it may carry credentials.
			message: strings.Join([for w in ["rendering DefKit module", parameter.ref, parameter.version] if w != "" {w}], " ")
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
