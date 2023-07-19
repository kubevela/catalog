"mysql-storage": {
	alias: ""
	annotations: {}
	attributes: {
		appliesToWorkloads: ["mysqlclusters.mysql.presslabs.org"]
		podDisruptive: false
	}
	description: ""
	labels: {}
	type: "trait"
}

template: {
	patch: spec: {
		volumeSpec: {
			if parameter.emptyDir != _|_ {
				emptyDir: parameter.emptyDir
			}
			if parameter.hostPath != _|_ {
				hostPath: parameter.hostPath
			}
			if parameter.pvc != _|_ {
				persistentVolumeClaim: {
					resources:        parameter.pvc.resources
					accessModes:      parameter.pvc.accessModes
					storageClassName: _storageClassName
					if parameter.pvc.volumeMode != _|_ {
						volumeMode: parameter.pvc.volumeMode
					}
					if parameter.pvc.volumeName != _|_ {
						volumeName: parameter.pvc.volumeName
					}
					if parameter.pvc.dataSource != _|_ {
						dataSource: parameter.pvc.dataSource
					}
					if parameter.pvc.selector != _|_ {
						selector: parameter.pvc.selector
					}
				}
			}
		}
	}

	patchOutputs: {
		if parameter.pvc != _|_ && parameter.pvc.provisioner != _|_ {
			"mysql-sc": {
				apiVersion: "storage.k8s.io/v1"
				kind:       "StorageClass"
				metadata: name: _storageClassName
				provisioner:          parameter.pvc.provisioner.name
				reclaimPolicy:        parameter.pvc.provisioner.reclaimPolicy
				volumeBindingMode:    "WaitForFirstConsumer"
				allowVolumeExpansion: true
				if parameter.pvc.provisioner.parameters != _|_ {
					parameters: parameter.pvc.provisioner.parameters
				}
			}
		}
	}

	_storageClassName: string
	if parameter.pvc != _|_ && parameter.pvc.provisioner == _|_ {
		_storageClassName: parameter.pvc.storageClassName
	}
	if parameter.pvc != _|_ && parameter.pvc.provisioner != _|_ {
		if parameter.pvc.storageClassName != _|_ {
			_storageClassName: parameter.pvc.storageClassName
		}
		if parameter.pvc.storageClassName == _|_ {
			_storageClassName: "mysql-" + context.namespace + "-" + context.name
		}
	}

	parameter: {
		type: *"emptyDir" | "hostPath" | "pvc"
		// +usage=EmptyDir to use as data volume for mysql
		emptyDir?: {
			//+usage=What type of storage medium should back this directory
			medium?: *"" | "Memory"
			//+usage=Total amount of local storage required for this EmptyDir volume
			sizeLimit?: =~"^([1-9][0-9]{0,63})(E|P|T|G|M|K|Ei|Pi|Ti|Gi|Mi|Ki)$"
		}

		// +usage=HostPath to use as data volume for mysql
		hostPath?: {
			//+usage=Path of the directory on the host
			path: string
			//+usage=Type for HostPath Volume defaults to ""
			type?: "Directory" | "DirectoryOrCreate" | "FileOrCreate" | "File" | "Socket" | "CharDevice" | "BlockDevice"
		}
		// +usage=PersistentVolumeClaim to specify PVC spec for the volume for mysql data
		pvc?: {
			//+usage=Represents the minimum resources the volume should have
			resources: {
				requests: storage: "1Gi" | =~"^([1-9][0-9]{0,63})(E|P|T|G|M|K|Ei|Pi|Ti|Gi|Mi|Ki)$"
				limits?: storage:  =~"^([1-9][0-9]{0,63})(E|P|T|G|M|K|Ei|Pi|Ti|Gi|Mi|Ki)$"
			}
			//+usage=AccessModes contains the desired access modes the volume should have
			accessModes: *["ReadWriteOnce"] | [...string]
			//+usage=What type of volume is required by the claim, defaults to Filesystem
			volumeMode?: string
			//+usage=Binding reference to the PersistentVolume backing this claim
			volumeName?: string
			//+usage=Name of the StorageClass required by the claim
			storageClassName?: string
			//+usage=Create a separate storage class
			provisioner?: {
				name:          string
				reclaimPolicy: *"Delete" | "Retain"
				parameters?: [string]: string
			}
			//+usage=Create a new volume based on the contents of the specified data source
			dataSource?: {
				name:     string
				kind:     string
				apiGroup: string
			}
			//+usage=A label query over volumes to consider for binding
			selector?: {
				matchLabels?: [string]: string
				matchExpressions?: {
					key: string
					values: [...string]
					operator: string
				}
			}
		}
	}
}
