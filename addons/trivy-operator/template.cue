package main

output: {
        apiVersion: "core.oam.dev/v1beta1"
        kind:       "Application"
        spec: {
                components: [
                        {
                                type: "k8s-objects"
                                name: "trivy-system-ns"
                                properties: objects: [{
                                        apiVersion: "v1"
                                        kind:       "Namespace"
                                        metadata: name: parameter.namespace
                                }]
                        },
                        {
                                name: "trivy-system-helm"
                                dependsOn: ["trivy-system-ns"]
                                type: "helm"

                                properties: {
                                        repoType: "helm"
                                        url:      "https://devopstales.github.io/helm-charts"
                                        chart:    "trivy-operator"
                                        version:  "2.3.2"
                                        targetNamespace: parameter.namespace
                                        values: {
                                            image:{
                                                repository: parameter["repository"]
                                                tag: parameter["tag"]
                                            }

                                            persistence:{
                                                enabled:parameter["enabled"]
                                            }

                                            namespaceScanner: {
                                                crontab: parameter["crontab"]
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
                                name: "deploy-trivy-system-ns"
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
