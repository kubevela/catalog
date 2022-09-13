package main


output: {
        apiVersion: "core.oam.dev/v1beta1"
        kind:       "Application"
        spec: {
                components: [
                        {
                                type: "k8s-objects"
                                name: "mongodb-ns"
                                properties: objects: [{
                                        apiVersion: "v1"
                                        kind:       "Namespace"
                                        metadata: name: parameter.namespace
                                }]
                        },
                        {
                            name: "mongodb-helm"
                            type: "helm"
                            dependsOn: ["mongodb-ns"]
                            type: "helm"
                            properties: {
                                    repoType: "helm"
                                    url:      "https://charts.bitnami.com/bitnami"
                                    chart:    "mongodb"
                                    targetNamespace: parameter["namespace"]
                                    version:  "13.1.2"
                                    values: {
                                            persistence: {
                                                enabled: parameter.persistenceEnabled
                                            }
                                            if parameter.persistenceEnabled {
                                                persistence: {
                                                    storageClass: parameter.persistenceStorageClass
                                                }
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
                            name: "mongodb-ns"
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
