output: {
    type: "k8s-objects"
    properties: {
        objects: [{
            apiVersion: "v1"
            kind:       "ConfigMap"
            metadata: {
                name:      "component-pod-view"
                namespace: "vela-system"
            }
            data: {
                template: ##"""
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
                                    podsWithCluster: [ for pods in collectedPods if pods.list != _|_ for podObj in pods.list {
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
                    """##
            }
        }, {
            apiVersion: "v1"
            kind:       "ConfigMap"
            metadata: {
                name:      "pod-view"
                namespace: "vela-system"
            }
            data: {
                template: ##"""
                            import (
                                "vela/ql"
                            )

                            parameter: {
                                name:      string
                                namespace: string
                                cluster:   *"" | string
                            }

                            pod: ql.#Read & {
                                value: {
                                    apiVersion: "v1"
                                    kind:       "Pod"
                                    metadata: {
                                        name:      parameter.name
                                        namespace: parameter.namespace
                                    }
                                }
                                cluster: parameter.cluster
                            }

                            eventList: ql.#SearchEvents & {
                                value: {
                                    apiVersion: "v1"
                                    kind:       "Pod"
                                    metadata:   pod.value.metadata
                                }
                                cluster: parameter.cluster
                            }

                            podMetrics: ql.#Read & {
                                cluster: parameter.cluster
                                value: {
                                    apiVersion: "metrics.k8s.io/v1beta1"
                                    kind:       "PodMetrics"
                                    metadata: {
                                        name:      parameter.name
                                        namespace: parameter.namespace
                                    }
                                }
                            }

                            status: {
                                if pod.err == _|_ {
                                    containers: [ for container in pod.value.spec.containers {
                                        name:  container.name
                                        image: container.image
                                        resources: {
                                            if container.resources.limits != _|_ {
                                                limits: container.resources.limits
                                            }
                                            if container.resources.requests != _|_ {
                                                requests: container.resources.requests
                                            }
                                            if podMetrics.err == _|_ {
                                                usage: {for containerUsage in podMetrics.value.containers {
                                                    if containerUsage.name == container.name {
                                                        cpu:    containerUsage.usage.cpu
                                                        memory: containerUsage.usage.memory
                                                    }
                                                }}
                                            }
                                        }
                                        if pod.value.status.containerStatuses != _|_ {
                                            status: {for containerStatus in pod.value.status.containerStatuses if containerStatus.name == container.name {
                                                state:        containerStatus.state
                                                restartCount: containerStatus.restartCount
                                            }}
                                        }
                                    }]
                                    if eventList.err == _|_ {
                                        events: eventList.list
                                    }
                                }
                                if pod.err != _|_ {
                                    error: pod.err
                                }
                            }
                    """##
            }
        }, {
            apiVersion: "v1"
            kind:       "ConfigMap"
            metadata: {
                name:      "cloud-resource-view"
                namespace: "vela-system"
            }
            data: {
                template: ##"""
                            import (
                                    "vela/ql"
                            )

                            parameter: {
                                    appName: string
                                    appNs:   string
                            }

                            apiVersion: "terraform.core.oam.dev/v1beta1"
                            kind:       "Configuration"

                            resources: ql.#ListResourcesInApp & {
                                    app: {
                                            name:      parameter.appName
                                            namespace: parameter.appNs
                                    }
                            }
                            status: {
                                    if resources.err == _|_ {
                                            "cloud-resources": [ for i, resource in resources.list if resource.object.apiVersion == apiVersion && resource.object.kind == kind {
                                                    resource.object
                                            }]
                                    }
                                    if resources.err != _|_ {
                                            error: resources.err
                                    }
                            }
                    """##
            }
        }, {
            apiVersion: "v1"
            kind:       "ConfigMap"
            metadata: {
                name:      "cloud-resource-secret-view"
                namespace: "vela-system"
            }
            data: {
                template: ##"""
                            import (
                                    "vela/ql"
                            )

                            parameter: {
                                    appName?: string
                                    appNs?:   string
                            }

                            secretList: ql.#List & {
                                    resource: {
                                            apiVersion: "v1"
                                            kind:       "Secret"
                                    }
                                    filter: {
                                            matchingLabels: {
                                                    "created-by": "terraform-controller"
                                                    if parameter.appName != _|_ && parameter.appNs != _|_ {
                                                            "app.oam.dev/name":      parameter.appName
                                                            "app.oam.dev/namespace": parameter.appNs
                                                    }
                                            }
                                    }
                            }

                            status: {
                                    if secretList.err == _|_ {
                                            secrets: secretList.list.items
                                    }
                                    if secretList.err != _|_ {
                                            error: secretList.err
                                    }
                            }
                    """##
            }
        }, {
            apiVersion: "v1"
            kind:       "ConfigMap"
            metadata: {
                name:      "resource-view"
                namespace: "vela-system"
            }
            data: {
                template: ##"""
                            import (
                                "vela/ql"
                            )

                            parameter: {
                                type:      string
                                namespace: *"" | string
                                cluster:   *"" | string
                            }

                            schema: {
                                "secret": {
                                    apiVersion: "v1"
                                    kind:       "Secret"
                                }
                                "configMap": {
                                    apiVersion: "v1"
                                    kind:       "ConfigMap"
                                }
                                "pvc": {
                                    apiVersion: "v1"
                                    kind:       "PersistentVolumeClaim"
                                }
                                "storageClass": {
                                    apiVersion: "storage.k8s.io/v1"
                                    kind:       "StorageClass"
                                }
                                "ns": {
                                    apiVersion: "v1"
                                    kind:       "Namespace"
                                }
                                "provider": {
                                    apiVersion: "terraform.core.oam.dev/v1beta1"
                                    kind:       "Provider"
                                }
                            }

                            List: ql.#List & {
                                resource: schema[parameter.type]
                                filter: {
                                    namespace: parameter.namespace
                                }
                                cluster: parameter.cluster
                            }

                            status: {
                                if List.err == _|_ {
                                    if len(List.list.items) == 0 {
                                        error: "failed to list \(parameter.type) in namespace \(parameter.namespace)"
                                    }
                                    if len(List.list.items) != 0 {
                                        list: List.list.items
                                    }
                                }

                                if List.err != _|_ {
                                    error: List.err
                                }
                            }
                    """##
            }
        }, {
            apiVersion: "v1"
            kind:       "ConfigMap"
            metadata: {
                name:      "service-view"
                namespace: "vela-system"
            }
            data: {
                template: ##"""
                          import (
                            "vela/ql"
                          )

                          parameter: {
                            appName:    string
                            appNs:      string
                            cluster?:   string
                            clusterNs?: string
                          }

                          apiVersion: "v1"
                          kind:       "Service"

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
                              }
                            }
                          }
                          status: {
                            if resources.err == _|_ {
                              services: [ for i, resource in resources.list if resource.object.apiVersion == apiVersion && resource.object.kind == kind {
                                resource.object
                              }]
                            }
                            if resources.err != _|_ {
                              error: resources.err
                            }
                          }
                    """##
            }
        }, {
            apiVersion: "v1"
            kind:       "ConfigMap"
            metadata: {
                name:      "collect-logs"
                namespace: "vela-system"
            }
            data: {
                template: ##"""
                            import (
                              "vela/ql"
                            )

                            collectLogs: ql.#CollectLogsInPod & {
                              cluster: parameter.cluster
                              namespace: parameter.namespace
                              pod: parameter.pod
                              options: {
                                container: parameter.container
                                previous?: parameter.previous
                                sinceSeconds?: parameter.sinceSeconds
                                sinceTime?: parameter.sinceTime
                                timestamps?: parameter.timestamps
                                tailLines?: parameter.tailLines
                                limitBytes?: parameter.limitBytes
                              }
                            }
                            status: collectLogs.outputs

                            parameter: {
                              // +usage=Specify the cluster of the pod
                              cluster: string
                              // +usage=Specify the namespace of the pod
                              namespace: string
                              // +usage=Specify the name of the pod
                              pod: string

                              // +usage=Specify the name of the container
                              container: string
                              // +usage=If true, return previous terminated container logs
                              previous: *false | bool
                              // +usage=If set, show logs in relative times
                              sinceSeconds: *null | int
                              // +usage=RFC3339 timestamp, if set, show logs since this time
                              sinceTime: *null | string
                              // +usage=If true, add timestamp at the beginning of every line
                              timestamps: *false | bool
                              // +usage=If set, return the number of lines from the end of logs
                              tailLines: *null | int
                              // +usage=If set, limit the size of returned bytes
                              limitBytes: *null | int
                            }
                    """##
            }
        }]
    }
}
