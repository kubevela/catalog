package main


output: {
        apiVersion: "core.oam.dev/v1beta1"
        kind:       "Application"
        spec: {
                components: [
                        {
                                type: "k8s-objects"
                                name: "mongodb-operator-ns"
                                properties: objects: [{
                                        apiVersion: "v1"
                                        kind:       "Namespace"
                                        metadata: name: parameter.namespace
                                }]
                        },
                        {
                            name: "mongodb-operator-helm"
                            dependsOn: ["mongodb-operator-ns"]
                            type: "helm"
                            properties: {
                                    repoType: "helm"
                                    url:      "https://ot-container-kit.github.io/helm-charts/"
                                    chart:    "mongodb-operator"
                                    targetNamespace: parameter["namespace"]
                                    version:  "v0.3.0"
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
                            name: "mongodb-operator-ns"
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
