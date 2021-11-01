controller: {
  apiVersion: "core.oam.dev/v1beta1"
  kind: "Application"
  metadata: {
    name: "example"
  }
  spec: {
    components: [{
      name: "example"
      type: "raw"
      properties: {
        secretKey: parameter.secretKey
      }
    }]
  }
}