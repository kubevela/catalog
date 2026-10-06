import "encoding/json"

// The render Job's sandbox: a namespace of its own, and an account that may
// write ConfigMaps there and nothing else.
output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	spec: workflow: steps: [{
		name: "namespace"
		type: "apply-component"
		properties: component: "defkit-namespace"
	}, {
		name: "sandbox"
		type: "apply-component"
		properties: component: "defkit-render-sandbox"
	}]
	spec: components: [{
		name: "defkit-namespace"
		type: "k8s-objects"
		properties: objects: [{
			apiVersion: "v1"
			kind:       "Namespace"
			metadata: name: "vela-defkit"
		}]
	}, {
		name: "defkit-render-sandbox"
		type: "k8s-objects"
		properties: objects: [{
			apiVersion: "v1"
			kind:       "ServiceAccount"
			metadata: {name: "defkit-render", namespace: "vela-defkit"}
		}, {
			apiVersion: "rbac.authorization.k8s.io/v1"
			kind:       "Role"
			metadata: {name: "defkit-render", namespace: "vela-defkit"}
			rules: [{apiGroups: [""], resources: ["configmaps"], verbs: ["get", "list", "create", "update", "delete"]}]
		}, {
			apiVersion: "rbac.authorization.k8s.io/v1"
			kind:       "RoleBinding"
			metadata: {name: "defkit-render", namespace: "vela-defkit"}
			roleRef: {apiGroup: "rbac.authorization.k8s.io", kind: "Role", name: "defkit-render"}
			subjects: [{kind: "ServiceAccount", name: "defkit-render", namespace: "vela-defkit"}]
		}, {
			apiVersion: "v1"
			kind:       "ConfigMap"
			metadata: {name: "defkit-settings", namespace: "vela-defkit"}
			data: {
				image:          parameter.image
				"repositories": json.Marshal(parameter.repositories)
			}
		}]
	}]
}
