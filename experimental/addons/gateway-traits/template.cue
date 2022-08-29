output: {
  apiVersion: "core.oam.dev/v1beta1"
  kind: "Application"
  metadata:
    name: "gateway-traits"
    namespace: "vela-system"
  spec: {
    components:[{
        name: "ns-gateway-system"
        type: "k8s-objects"
        properties: objects: [{
          apiVersion: "v1"
          kind: "Namespace"
          metadata:
            name: "gateway-system"
      }]
    }]
  }
}   