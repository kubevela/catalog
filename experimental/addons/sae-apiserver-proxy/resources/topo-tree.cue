package main

topo: {
    type: "k8s-objects"
    name: "\(const.name)-topo"
    properties: objects: [{
        apiVersion: "v1"
        kind: "ConfigMap"
        metadata: {
            name: "deployment-pod-relation"
            namespace: "vela-system"
            labels: {
                "rules.oam.dev/resource-format": "yaml"
                "rules.oam.dev/resources": "true"
            }
        }
        data: rules: #"""
            - parentResourceType:
                group: apps
                kind: Deployment
              childrenResourceType:
                - apiVersion: v1
                  kind: Pod
        """#
    }]

}
