// This will be rendered as an `eampleinput` component of the ConfigMap resource
exampleinput: {
  apiVersion: "v1"
  kind:       "ConfigMap"
  metadata: {
    name: "exampleinput"
    namespace: "default"
  }
  data: input: parameter.example
}
