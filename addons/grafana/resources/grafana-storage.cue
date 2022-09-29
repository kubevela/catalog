package main

grafanaStorage: {
	name: "grafana-storage"
	type: "k8s-objects"
	properties: objects: [{
		apiVersion: "v1"
		kind:       "PersistentVolumeClaim"
		metadata: name: "grafana-storage"
		spec: {
			if parameter.storageClassName != _|_ {
				storageClassName: parameter.storageClassName
			}
			accessModes: ["ReadWriteOnce"]
			volumeMode: "Filesystem"
			if parameter.storage != _|_ {
				resources: requests: storage: parameter["storage"]
			}
		}
	}]
}
