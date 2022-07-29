package main

grafanaStorage: {
	name: "grafana-storage"
	type: "k8s-objects"
	properties: objects: [{
		apiVersion: "v1"
		kind:       "PersistentVolumeClaim"
		metadata: name: "grafana-storage"
		spec: {
			accessModes: ["ReadWriteOnce"]
			volumeMode: "Filesystem"
			resources: requests: storage: parameter["storage"]
		}
	}]
}
