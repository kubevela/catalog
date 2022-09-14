package main


output: {
        apiVersion: "core.oam.dev/v1beta1"
        kind:       "Application"
        spec: {
                components: [
                        {
                                type: "k8s-objects"
                                name: "blade-ns"
                                properties: objects: [{
                                        apiVersion: "v1"
                                        kind:       "Namespace"
                                        metadata: name: parameter.namespace
                                }]
                        },
                        {
                            name: "blade-helm"
                            type: "helm"
                            dependsOn: ["blade-ns"]
                            properties: {
                                    repoType: "helm"
                                    url:      "https://oeular.github.io/chaosblade-operator/"
                                    chart:    "chaosblade-operator"
                                    targetNamespace: parameter["namespace"]
                                    version:  "1.7.0"
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
                            name: "blade-ns"
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
