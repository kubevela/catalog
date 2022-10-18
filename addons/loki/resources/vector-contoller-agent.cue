package main

agentServiceAccount: {...}

vectorControllerAgent: {
	name: "vector"
	type: "daemon"
	properties: {
		image:           parameter.vectorImage
		imagePullPolicy: parameter.imagePullPolicy
		labels: {
			 "vector.oam.dev/agent": "true"
		}
		env: [{
			name: "VECTOR_SELF_NODE_NAME"
			valueFrom: fieldRef: fieldPath: "spec.nodeName"
		}, {
			name: "VECTOR_SELF_POD_NAME"
			valueFrom: fieldRef: fieldPath: "metadata.name"
		}, {
			name: "VECTOR_SELF_POD_NAMESPACE"
			valueFrom: fieldRef: fieldPath: "metadata.namespace"
		}, {
			name:  "PROCFS_ROOT"
			value: "/host/proc"
		}, {
			name:  "SYSFS_ROOT"
			value: "/host/sys"
		}]
		volumeMounts: {
			configMap: [{
				name:      "config"
				mountPath: "/etc/config"
				cmName:    "vector"
			}]
			hostPath: [{
				name:      "data"
				path:      "/var/lib/vector"
				mountPath: "/vector-data-dir"
			}, {
				name:      "var-log"
				path:      "/var/log/"
				mountPath: "/var/log/"
				readOnly:  true
			}, {
				name:      "var-lib"
				path:      "/var/lib/"
				mountPath: "/var/lib/"
				readOnly:  true
			}, {
				name:      "procfs"
				path:      "/proc"
				mountPath: "/host/proc"
				readOnly:  true
			}, {
				name:      "sysfs"
				path:      "/sys"
				mountPath: "/host/sys"
				readOnly:  true
			}]
		}
	}
	traits: [{
		type: "command"
		properties: args: ["--config-dir", "/etc/config/", "-w"]
	}] + [{
		agentServiceAccount
		properties: name: "vector"
	}]
}

vectorControllerAgentConfig: {
	name: "vector-config"
	type: "k8s-objects"
	properties: objects: [{
		apiVersion: "v1"
		kind:       "ConfigMap"
		metadata: name: "vector"
		data: {
			"agent.yaml": #"""
				data_dir: /vector-data-dir
				sources:
				  kubernetes-logs:
				    type: kubernetes_logs
				    extra_label_selector: "vector.oam.dev/agent!=true"
				sinks:
				  console:
				    type: console
				    inputs:
				      - kubernetes-logs
				    target: stdout
				    encoding:
				      codec: json
				"""#
		}
	}]
}

vectorCRDComponent: {
	name: "vector-crd"
  type: "k8s-objects"
  properties: objects: [
  	 vectorControllerCRD,
  ]
}


vectorControllerServiceAccount: {
	type: "service-account"
	properties: {
		name: "vector-controller"
		create: true
		privileges: [{
			scope: "cluster"
			apiGroups: ["vector.oam.dev"]
			resources: ["configs"]
			verbs: ["*"]
		}, {
			scope: "cluster"
			apiGroups: [""]
			resources: ["configmaps"]
			verbs: ["*"]
		}]
	}
}


vectorController: {
	 name: "vector-controller"
	 type: "webservice"
	 properties: {
	 	 image: parameter.vectorControllerImage
	 	 imagePullPolicy: parameter.imagePullPolicy
	 }
	 traits:[vectorControllerServiceAccount]
}