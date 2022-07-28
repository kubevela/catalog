package main

_base: string
_rules: [...]
controllerArgs: [...]
_sourceControllerName: "fluxcd-source-controller"

sourceController: {
	// Change deployment name to make uograde possible.
	//
	// Reason:
	//     If we don't change the name, the upgrade *seems* fine, everything works,
	//     but the actual deployment is not upgraded, which is not what we want.
	//
	//     Background:
	//         The app.oam.dev/component is immutable, we cannot edit it.
	//
	//     The original fluxcd is in yaml, but the new ones are using webservice.
	//     It will try to edit app.oam.dev/component. 
	//     **This will fail.**
	//
	//     Instead, we change a name, to recreate pod. So that do don't modify the label.
	//
	//     This name-changing is only required once. After the user upgrades to webserive,
	//     later upgrades do *not* need to change the name.
	name: _sourceControllerName
	type: "webservice"
	dependsOn: ["fluxcd-ns"]
	properties: {
		imagePullPolicy: "IfNotPresent"
		image:           _base + "fluxcd/source-controller:v0.25.2"
		env: [
			{
				name:  "RUNTIME_NAMESPACE"
				value: parameter.namespace
			},
		]
		livenessProbe: {
			httpGet: {
				path: "/healthz"
				port: 9440
			}
			timeoutSeconds: 5
		}
		readinessProbe: {
			httpGet: {
				path: "/"
				port: 9090
			}
			timeoutSeconds: 5
		}
		volumeMounts: {
			emptyDir: [
				{
					name:      "temp"
					mountPath: "/tmp"
				},
				{
					name:      "data"
					mountPath: "/data"
				},
			]
		}
		ports: [
			{
				port:     9090
				name:     "http"
				protocol: "TCP"
				expose:   true
			},
		]
		exposeType: "ClusterIP"
	}
	traits: [
		{
			type: "service-account"
			properties: {
				name:       "sa-source-controller"
				create:     true
				privileges: _rules
			}
		},
		{
			type: "labels"
			properties: {
				"control-plane": "controller"
				// This label is kept to avoid breaking existing 
				// KubeVela e2e tests (makefile e2e-setup).
				"app": "source-controller"
			}
		},
		{
			type: "command"
			properties: {
				args: controllerArgs + [
					"--storage-path=/data",
					"--storage-adv-addr=http://" + _sourceControllerName + "." + parameter.namespace + ".svc:9090",
				]
			}
		},
	]
}
