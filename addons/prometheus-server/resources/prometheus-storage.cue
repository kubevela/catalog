package main

prometheusStorage: {
	name: "prometheus-storage"
	type: "k8s-objects"
	properties: objects: [{
		apiVersion: "v1"
		kind:       "PersistentVolumeClaim"
		metadata: name: "prometheus-server-storage"
		spec: {
			accessModes: ["ReadWriteOnce"]
			volumeMode: "Filesystem"
			resources: requests: storage: parameter["storage"]
		}
	}]
}
