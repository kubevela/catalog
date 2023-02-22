package main

apiService: {
    type: "k8s-objects"
    name: "\(const.name)-apiservices"
    properties: objects: [{
        apiVersion: "apiregistration.k8s.io/v1"
        kind:       "APIService"
        metadata: name: "v1alpha1.sae.alibaba-cloud.oam.dev"
        spec: {
            version:              "v1alpha1"
            group:                "sae.alibaba-cloud.oam.dev"
            groupPriorityMinimum: 2000
            versionPriority:      10
            insecureSkipTLSVerify: true
            service: {
                name:      const.name
                namespace: parameter.namespace
                port:      9443
            }
        }
    }, {
        apiVersion: "rbac.authorization.k8s.io/v1"
        kind: "RoleBinding"
        metadata: {
            name: const.name
            namespace: "kube-system"
        }
        labels: app: const.name
        subjects: [{
            kind: "ServiceAccount"
            name: const.name
            namespace: parameter.namespace
        }]
        roleRef: {
            apiGroup: "rbac.authorization.k8s.io"
            kind: "Role"
            name: "extension-apiserver-authentication-reader"
        }
    }]
}