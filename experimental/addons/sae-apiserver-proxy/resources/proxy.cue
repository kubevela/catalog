package main

proxy: {
	name: const.name
	type: "webservice"
	properties: {
		image:           parameter.image
		imagePullPolicy: parameter.imagePullPolicy
	}
	traits: [{
		type: "expose"
		properties: port: [9443]
	}, {
		type: "service-account"
		properties: {
			name:   "sae-apiserver-proxy"
			create: true
			privileges: [ for p in _clusterPrivileges {
				scope: "cluster"
				{p}
			}] + [ for p in _namespacePrivileges {
				scope: "namespace"
				{p}
			}]
		}
	}, {
		type: "command"
		properties: command: [
			"sae-apiserver-proxy",
			"--secure-port=9443",
			"--feature-gates=APIPriorityAndFairness=false",
			"--storage-namespace=\(parameter.namespace)",
			"--server-address=https://\(const.name).\(parameter.namespace):9443"
		]
	}, {
		type: "resource"
		properties: {
			cpu:    parameter.cpu
			memory: parameter.memory
		}
	}]
}

_clusterPrivileges: [{
	apiGroups: [""]
	resources: ["namespaces"]
	verbs: ["get", "watch", "list"]
}, {
	apiGroups: ["admissionregistration.k8s.io"]
	resources: ["mutatingwebhookconfigurations", "validatingwebhookconfigurations"]
	verbs: ["get", "list", "watch"]
}, {
	apiGroups: ["flowcontrol.apiserver.k8s.io"]
	resources: ["prioritylevelconfigurations", "flowschemas"]
	verbs: ["get", "list", "watch"]
}, {
	apiGroups: ["authorization.k8s.io"]
	resources: ["subjectaccessreviews"]
	verbs: ["*"]
}, {
	apiGroups: ["authentication.k8s.io"]
	resources: ["tokenreviews"]
	verbs: ["*"]
}, {
	apiGroups: ["sae.alibaba-cloud.oam.dev"]
	resources: ["saeapiservers", "saeapiservers/proxy"]
	verbs: ["*"]
}]

_namespacePrivileges: [{
	apiGroups: [""]
	resources: ["secrets"]
	verbs: ["*"]
}]
