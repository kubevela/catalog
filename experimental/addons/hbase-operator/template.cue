package main

output: {
  apiVersion: "core.oam.dev/v1beta1"
  kind:       "Application"
  spec: {
    components: [
      {
        name: "ns-zookeeper-operator"
        type: "k8s-objects"
        properties: objects: [{
          kind: "Namespace"
          apiVersion: "v1"
          metadata:
            name: "zookeeper-operator"
        }]
      },
      {
        name: "zookeeper-operator"
        type: "helm"
        properties: {
          repoType: "helm"
          url: "https://repo.stackable.tech/repository/helm-stable/"
          chart: "zookeeper-operator"
          version: "0.2.2"
        }
      },
      {
        name: "ns-kafka-operator"
        type: "k8s-objects"
        properties: objects: [{
          kind: "Namespace"
          apiVersion: "v1"
          metadata:
            name: "kafka-operator"
        }]
      },
      {
        name: "kafka-operator"
        type: "helm"
        properties: {
          repoType: "helm"
          url: "https://repo.stackable.tech/repository/helm-stable/"
          chart: "kafka-operator"
          version: "0.6.0"
        }
      },
      {
        name: "ns-secret-operator"
        type: "k8s-objects"
        properties: objects: [{
          kind: "Namespace"
          apiVersion: "v1"
          metadata:
            name: "secret-operator"
        }]
      },
      {
        name: "secret-operator"
        type: "helm"
        properties: {
          repoType: "helm"
          url: "https://repo.stackable.tech/repository/helm-stable/"
          chart: "secret-operator"
          version: "0.6.0"
        }
      },
      {
        name: "ns-nifi-operator"
        type: "k8s-objects"
        properties: objects: [{
          kind: "Namespace"
          apiVersion: "v1"
          metadata:
            name: "nifi-operator"
        }]
      },
      {
        name: "nifi-operator"
        type: "helm"
        properties: {
          repoType: "helm"
          url: "https://repo.stackable.tech/repository/helm-stable/"
          chart: "nifi-operator"
          version: "0.3.3"
        }
      },
    ]
    policies: [
      {
        type: "shared-resource"
        name: "zookeeper-operator-ns"
        properties: rules: [{
          selector: resourceTypes: ["Namespace"]
        }]
      },
      {
        type: "shared-resource"
        name: "kafka-operator-ns"
        properties: rules: [{
          selector: resourceTypes: ["Namespace"]
        }]
      },
      {
        type: "shared-resource"
        name: "secret-operator-ns"
        properties: rules: [{
          selector: resourceTypes: ["Namespace"]
        }]
      },
      {
        type: "shared-resource"
        name: "nifi-operator-ns"
        properties: rules: [{
          selector: resourceTypes: ["Namespace"]
        }]
      },
      {
        type: "topology"
        name: "deploy-operators"
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





