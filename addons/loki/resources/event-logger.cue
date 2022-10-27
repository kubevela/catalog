package main

eventLogger: {
	name: "event-log"
	type: "webservice"
	properties: {
		image: "maxrocketinternet/k8s-event-logger:1.7"
		labels: "kube-event-logger": "true"
	}
	traits: [eventLogServiceAccount]
}

eventLogServiceAccount: {
	type: "service-account"
	properties: {
		name:   "log-event"
		create: true
		privileges: [{
			scope: "cluster"
			apiGroups: [""]
			resources: ["events"]
			verbs: ["*"]
		}]
	}
}
