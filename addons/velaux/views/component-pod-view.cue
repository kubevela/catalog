import (
	"vela/ql"
	"vela/op"
	"strings"
)

parameter: {
	appName:    string
	appNs:      string
	name?:      string
	cluster?:   string
	clusterNs?: string
}

annotationDeployVersion:  "app.oam.dev/deployVersion"
annotationPublishVersion: "app.oam.dev/publishVersion"
labelComponentName:       "app.oam.dev/component"

ignoreCollectPodKindMap: {
	"ConfigMap":                 true
	"Endpoints":                 true
	"LimitRange":                true
	"Namespace":                 true
	"Node":                      true
	"PersistentVolumeClaim":     true
	"PersistentVolume":          true
	"ReplicationController":     true
	"ResourceQuota":             true
	"ServiceAccount":            true
	"Service":                   true
	"Event":                     true
	"Ingress":                   true
	"StorageClass":              true
	"NetworkPolicy":             true
	"PodDisruptionBudget":       true
	"PodSecurityPolicy":         true
	"PriorityClass":             true
	"CustomResourceDefinition":  true
	"HorizontalPodAutoscaler":   true
	"CertificateSigningRequest": true
	"ManagedCluster":            true
	"ManagedClusterSetBinding":  true
	"ManagedClusterSet":         true
	"ApplicationRevision":       true
	"ComponentDefinition":       true
	"DefinitionRevision":        true
	"EnvBinding":                true
	"PolicyDefinition":          true
	"ResourceTracker":           true
	"ScopeDefinition":           true
	"TraitDefinition":           true
	"WorkflowStepDefinition":    true
	"WorkloadDefinition":        true
	"GitRepository":             true
	"HelmRepository":            true
	"ComponentStatus":           true
}

resources: ql.#ListResourcesInApp & {
	app: {
		name:      parameter.appName
		namespace: parameter.appNs
		filter: {
			if parameter.cluster != _|_ {
				cluster: parameter.cluster
			}
			if parameter.clusterNs != _|_ {
				clusterNamespace: parameter.clusterNs
			}
			if parameter.name != _|_ {
				components: [parameter.name]
			}
		}
	}
}

if resources.err == _|_ {
	collectedPods: op.#Steps & {
		for i, resource in resources.list if ignoreCollectPodKindMap[resource.object.kind] == _|_ {
			"\(i)": ql.#CollectPods & {
				value:   resource.object
				cluster: resource.cluster
			}
		}
	}
	podsWithCluster: [ for pods in collectedPods if pods.list != _|_ && pods.list != null for podObj in pods.list {
		cluster: pods.cluster
		obj:     podObj
		workload: {
			apiVersion: pods.value.apiVersion
			kind:       pods.value.kind
			name:       pods.value.metadata.name
			namespace:  pods.value.metadata.namespace
		}
		if pods.value.metadata.labels[labelComponentName] != _|_ {
			component: pods.value.metadata.labels[labelComponentName]
		}
		if pods.value.metadata.annotations[annotationPublishVersion] != _|_ {
			publishVersion: pods.value.metadata.annotations[annotationPublishVersion]
		}
		if pods.value.metadata.annotations[annotationDeployVersion] != _|_ {
			deployVersion: pods.value.metadata.annotations[annotationDeployVersion]
		}
	}]
	podsError: [ for pods in collectedPods if pods.err != _|_ {pods.err}]
	status: {
		if len(podsError) == 0 {
			podList: [ for pod in podsWithCluster {
				cluster:   pod.cluster
				workload:  pod.workload
				component: pod.component
				metadata: {
					name:         pod.obj.metadata.name
					namespace:    pod.obj.metadata.namespace
					creationTime: pod.obj.metadata.creationTimestamp
					version: {
						if pod.publishVersion != _|_ {
							publishVersion: pod.publishVersion
						}
						if pod.deployVersion != _|_ {
							deployVersion: pod.deployVersion
						}
					}
				}
				status: {
					phase: pod.obj.status.phase
					// refer to https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#pod-phase
					if phase != "Pending" && phase != "Unknown" {
						podIP:    pod.obj.status.podIP
						hostIP:   pod.obj.status.hostIP
						nodeName: pod.obj.spec.nodeName
					}
				}
			}]
		}
		if len(podsError) != 0 {
			error: strings.Join(podsError, ",")
		}
	}
}

if resources.err != _|_ {
	status: {
		error: resources.err
	}
}
