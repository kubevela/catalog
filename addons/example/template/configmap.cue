// `exampleinput` will be used as the Component name
exampleinput: {
  apiVersion: "v1"
  kind:       "ConfigMap"
  metadata: {
    name: "exampleinput"
    namespace: "default"
  }
  data: input: parameter.example
}
