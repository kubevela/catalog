package main


output: {
        apiVersion: "core.oam.dev/v1beta1"
        kind:       "Application"
        spec: {
                components: [
                        {
                                type: "k8s-objects"
                                name: "cert-manager-ns"
                                properties: objects: [{
                                        apiVersion: "v1"
                                        kind:       "Namespace"
                                        metadata: name: parameter.namespace
                                }]
                        },
                        {
                        name: "cert-manager-helm"
                        type: "helm"
                        dependsOn: ["cert-manager-ns"]
                        properties: {
                                repoType: "helm"
                                url:      "https://charts.jetstack.io"
                                chart:    "cert-manager"
                                targetNamespace: parameter.namespace
                                version:  "v1.7.1"
                                values: {
                                        installCRDs: parameter.installCRDs
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
