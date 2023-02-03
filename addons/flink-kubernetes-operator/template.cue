package main


output: {
        apiVersion: "core.oam.dev/v1beta1"
        kind:       "Application"
        spec: {
                components: [
                        {
                                type: "k8s-objects"
                                name: "flink-operator-ns"
                                properties: objects: [{
                                        apiVersion: "v1"
                                        kind:       "Namespace"
                                        metadata: name: parameter.namespace
                                }]
                        },
                        {
                            name: "flink-operator-helm"
                            type: "helm"
                            dependsOn: ["flink-operator-ns"]
                            type: "helm"
                            properties: {
                                    repoType: "helm"
                                    url:      "https://downloads.apache.org/flink/flink-kubernetes-operator-1.3.1/"
                                    chart:    "flink-kubernetes-operator"
                                    targetNamespace: parameter["namespace"]
                                    version:  "1.3.1"
                                    values: {
                                            webhook: {
                                                create: parameter["createWebhook"]
                                            }

                                            image: {
                                                repository: parameter["imageRepository"]
                                                tag: parameter["imageTag"]
                                            }

                                            jobServiceAccount: {
                                                create: parameter["createJobServiceAccount"]
                                            }
                                            operatorServiceAccount: {
                                                name: "flink-kubernetes-operator"
                                            }
                                    }
                            }
                        },
                ]
                policies: [
                    {
                            type: "shared-resource"
                            name: "namespace"
                            properties: rules: [{
                                    selector: resourceTypes: ["Namespace"]
                            }]
                    },
                    {
                            type: "topology"
                            name: "deploy-cert-manager-ns"
                            properties: {
                                    namespace: parameter.namespace
                                    if parameter.clusters != _|_ {
                                            clusters: parameter.clusters
                                    }
                                    if parameter.clusters == _|_ {
                                            clusterLabelSelector: {}
                                    }
                            }
                    },
                ]
        }
}
