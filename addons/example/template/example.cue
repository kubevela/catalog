example: {
  apiVersion: "v1"
  kind:       "ConfigMap"
  metadata: {
    name: "example-input"
    namespace: "default"
  }
  data: input: parameters.example
}