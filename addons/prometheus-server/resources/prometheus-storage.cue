package main

prometheusStorage: {
	name: "prometheus-storage"
	type: "k8s-objects"
	dependsOn: [o11yNamespace.name]
	properties: objects: [{
		apiVersion: "v1"
		kind:       "PersistentVolumeClaim"
		metadata: name: "prometheus-server-storage"
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
