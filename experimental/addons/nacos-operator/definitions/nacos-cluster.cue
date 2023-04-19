"nacos-cluster": {
	alias: ""
	annotations: {}
	attributes: workload: type: "autodetects.core.oam.dev"
	description: "nacos cluster component"
	labels: {}
	type: "component"
}

template: {
	output: {
		kind:       "Nacos"
		apiVersion: "nacos.io/v1alpha1"
		metadata: {
			name: context.name
		}
		spec: {
			affinity:         parameter.affinity
			config:           parameter.config
			database:         parameter.database
			env:              parameter.env
			image:            parameter.image
			imagePullSecrets: parameter.imagePullSecrets
			k8sWrapper:       parameter.k8sWrapper
			livenessProbe:    parameter.livenessProbe
			mysqlInitImage:   parameter.mysqlInitImage
			nodeSelector:     parameter.nodeSelector
			readinessProbe:   parameter.readinessProbe
			replicas:         parameter.replicas
			resources:        parameter.resources
			tolerations:      parameter.tolerations
			type:             parameter.type
			volume:           parameter.volume
		}
	}
	parameter: {
		//+usage=Affinity is a group of affinity scheduling rules.
		affinity: *null | {...}
		//+usage=configuration.
		config: *null | string
		//+usage=Configure Database.
		database: *null | {...}
		//+usage=Configure Env.
		env: *null | [...]
		//+usage=Image name.
		image: *null | string
		//+usage=Configure imagePullSecret to pull image secrets.
		imagePullSecrets: *null | [...]
		//+usage=Configure k8sWrapper.
		k8sWrapper: *null | {...}
		//+usage=Probe describes a health check to be performed against a container to determine whether it is alive or ready to receive traffic.
		livenessProbe: *null | {...}
		//+usage=Name of the mysql init image.
		mysqlInitImage: *null | string
		//+usage=Configure nodeSelector.
		nodeSelector: *null | {...}
		//+usage=Probe describes a health check to be performed against a container to determine whether it is alive or ready to receive traffic.
		readinessProbe: *null | {...}
		//+usage=Number of replicas.
		replicas: *null | int
		//+usage=VolumeClaimTemplates []v1.PersistentVolumeClaim `json:"volumeClaimTemplates,omitempty" protobuf:"bytes,4,rep,name=volumeClaimTemplates"`.
		resources: *null | {...}
		//+usage=Configure tolerations.
		tolerations: *null | [...]
		//+usage=Type.
		type: *null | string
		//+usage=Configure volume.
		volume: *null | {...}
	}
}
