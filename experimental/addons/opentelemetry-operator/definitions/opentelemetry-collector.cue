"opentelemetry-collector": {
	alias: ""
	annotations: {}
	attributes: workload: type: "autodetects.core.oam.dev"
	description: "opentelemetry collector component"
	labels: {}
	type: "component"
}

template: {
	output: {
		kind:       "OpenTelemetryCollector"
		apiVersion: "opentelemetry.io/v1alpha1"
		metadata: {
			name: context.name
		}
		spec: {
			affinity:           parameter.affinity
			args:               parameter.args
			autoscaler:         parameter.autoscaler
			config:             parameter.config
			env:                parameter.env
			envFrom:            parameter.envFrom
			hostNetwork:        parameter.hostNetwork
			image:              parameter.image
			imagePullPolicy:    parameter.imagePullPolicy
			ingress:            parameter.ingress
			maxReplicas:        parameter.maxReplicas
			minReplicas:        parameter.minReplicas
			mode:               parameter.mode
			nodeSelector:       parameter.nodeSelector
			podAnnotations:     parameter.podAnnotations
			podSecurityContext: parameter.podSecurityContext
			ports:              parameter.ports
			priorityClassName:  parameter.priorityClassName
			replicas:           parameter.replicas
			resources:          parameter.resources
			securityContext:    parameter.securityContext
		}
	}
	parameter: {
		//+usage=If specified, indicates the pod's scheduling constraints.
		affinity: *null | {...}
		//+usage=Args is the set of arguments to pass to the OpenTelemetry Collector binary.
		args: *null | {...}
		//+usage=Autoscaler specifies the pod autoscaling configuration to use for the OpenTelemetryCollector workload.
		autoscaler: *null | {...}
		//+usage=Config is the raw JSON to be used as the collector's configuration. Refer to the OpenTelemetry Collector documentation for details.
		config: *null | string
		//+usage=ENV vars to set on the OpenTelemetry Collector's Pods. These can then in certain cases be consumed in the config file for the Collector.
		env: *null | [...]
		//+usage=List of sources to populate environment variables on the OpenTelemetry Collector's Pods. These can then in certain cases be consumed in the config file for the Collector.
		envFrom: *null | [...]
		//+usage=HostNetwork indicates if the pod should run in the host networking namespace.
		hostNetwork: *null | bool
		//+usage=Image indicates the container image to use for the OpenTelemetry Collector.
		image: *null | string
		//+usage=ImagePullPolicy indicates the pull policy to be used for retrieving the container image (Always, Never, IfNotPresent)
		imagePullPolicy: *null | string
		//+usage=Ingress is used to specify how OpenTelemetry Collector is exposed. This functionality is only available if one of the valid modes is set. Valid modes are: deployment, daemonset and statefulset.
		ingress: *null | {...}
		//+usage=MaxReplicas sets an upper bound to the autoscaling feature. If MaxReplicas is set autoscaling is enabled. Deprecated: use "OpenTelemetryCollector.Spec.Autoscaler.MaxReplicas" instead.
		maxReplicas: *null | int
		//+usage=MinReplicas sets a lower bound to the autoscaling feature. Set this if your are using autoscaling. It must be at least 1. Deprecated: use "OpenTelemetryCollector.Spec.Autoscaler.MinReplicas" instead.
		minReplicas: *null | int
		//+usage=Mode represents how the collector should be deployed (deployment, daemonset, statefulset or sidecar).
		mode: *"deployment" | string
		//+usage=NodeSelector to schedule OpenTelemetry Collector pods. This is only relevant to daemonset, statefulset, and deployment mode.
		nodeSelector: *null | {...}
		//+usage=PodAnnotations is the set of annotations that will be attached to Collector and Target Allocator pods.
		podAnnotations: *null | {...}
		//+usage=PodSecurityContext holds pod-level security attributes and common container settings. Some fields are also present in container.securityContext.  Field values of container.securityContext take precedence over field values of PodSecurityContext.
		podSecurityContext: *null | {...}
		//+usage=Ports allows a set of ports to be exposed by the underlying v1.Service. By default, the operator will attempt to infer the required ports by parsing the .Spec.Config property but this property can be used to open additional ports that can't be inferred by the operator, like for custom receivers.
		ports: *null | [...]
		//+usage=If specified, indicates the pod's priority. If not specified, the pod priority will be default or zero if there is no default.
		priorityClassName: *null | string
		//+usage=Replicas is the number of pod instances for the underlying OpenTelemetry Collector. Set this if your are not using autoscaling.
		replicas: *null | int
		//+usage=Resources to set on the OpenTelemetry Collector pods.
		resources: *null | {...}
		//+usage=SecurityContext will be set as the container security context.
		securityContext: *null | {...}
		//+usage=ServiceAccount indicates the name of an existing service account to use with this instance. When set, the operator will not automatically create a ServiceAccount for the collector.
		serviceAccount: *null | string
		//+usage=TargetAllocator indicates a value which determines whether to spawn a target allocation resource or not.
		targetAllocator: *null | {...}
		//+usage=Toleration to schedule OpenTelemetry Collector pods. This is only relevant to daemonset, statefulset, and deployment mode.
		tolerations: *null | [...]
		//+usage=UpgradeStrategy represents how the operator will handle upgrades to the CR when a newer version of the operator is deployed.
		upgradeStrategy: *null | string
		//+usage=VolumeClaimTemplates will provide stable storage using PersistentVolumes. Only available when the mode=statefulset.
		volumeClaimTemplates: *null | [...]
		//+usage=VolumeMounts represents the mount points to use in the underlying collector deployment(s).
		volumeMounts: *null | [...]
		//+usage=Volumes represents which volumes to use in the underlying collector deployment(s).
		volumes: *null | [...]
	}
}
