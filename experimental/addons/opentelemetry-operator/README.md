# opentelemetry-operator

This is an addon template. Check how to build your own addon: https://kubevela.net/docs/platform-engineers/addon/intro

## Install

Add experimental registry
```
vela addon registry add experimental --type=helm --endpoint=https://addons.kubevela.net/experimental/
```

Enable this addon
```
vela addon enable opentelemetry-operator
```

```shell
$ vela ls -A | grep opentelemetry
vela-system     addon-opentelemetry-operator    ns-opentelemetry-operator               k8s-objects                                     running healthy
vela-system     └─                              opentelemetry-operator                  helm                                            running healthy Fetch repository successfully, Create helm release
```

Disable this addon
```
vela addon disable opentelemetry-operator
```

## Use opentelemetry-operator

### Opentelemetry Collector

Once the opentelemetry-operator addon enabled successfully, you can deploy OpenTelemetry Collector in your Kubernetes cluster.

The Collector can be deployed as one of four modes: `Deployment`, `DaemonSet`, `StatefulSet` and `Sidecar`. The default mode is `Deployment`.

**Collector as sidecar**

The following YAML creates a pod with a sidecar collector trait:

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: otel-sidecar-collector-sample
spec:
  components:
    - type: "k8s-objects"
      name: "otel-deploy"
      properties:
        objects:
          - apiVersion: apps/v1
            kind: Deployment
            metadata:
              name: my-app
              labels:
                app: my-app
            spec:
              selector:
                matchLabels:
                  app: my-app
              replicas: 1
              template:
                metadata:
                  labels:
                    app: my-app
                  annotations:
                    sidecar.opentelemetry.io/inject: "true" # CORRECT
                spec:
                  containers:
                    - name: myapp
                      image: jaegertracing/vertx-create-span:operator-e2e-tests
                      ports:
                        - containerPort: 8080
                          protocol: TCP
      traits:
        - type: opentelemetry-collector
          properties:
            mode: sidecar
            config: |
              receivers:
                jaeger:
                  protocols:
                    thrift_compact:
              processors:

              exporters:
                logging:

              service:
                pipelines:
                  traces:
                    receivers: [jaeger]
                    processors: []
                    exporters: [logging]
```

After applying the above YAML an application container gets created with a collector container in the same pod because of collector type `sidecar`, Where Collector collects all the traces created by the application as logs as specified in the YAML.

```shell
# Access the logs of otc-container created by collector.
$ kubectl logs myapp-1 -n prod -c otc-container
```

If you want to access prometheus metrics data :

```shell
# Port-forward the port.
$ kubectl port-forward -n prod myapp 8888

# Access prometheus metrics.
$ curl http://localhost:8888
```

There are also other types of collector besides `sidecar`, like `deployment`(By default), `DaemonSet`, `StatefulSet` which is set in trait type `opentelemetry-collector` by the `mode` attribute, So annotations to add to pod templates varies as per Collector type.

**Deployment Mode**

```yaml
deployment.opentelemetry.io/inject: "true"
```

**DaemonSet Mode**

```yaml
daemonset.opentelemetry.io/inject: "true"
```

**StatefulSet Mode**

```yaml
statefulset.opentelemetry.io/inject: "true"
```

For more about Opentelemetry Collector visit https://opentelemetry.io/docs/collector/.

### Instrumentation

The OpenTelemetry Operator supports injecting and configuring auto-instrumentation libraries for `.NET`, `Java`, `NodeJS` and `Python` services.

**Configure Autoinstrumentation**

To be able to manage autoinstrumentation, the Operator needs to be configured to know what pods to instrument and which autoinstrumentation to use for those pods. This is done via the [Instrumentation CRD](https://github.com/open-telemetry/opentelemetry-operator/blob/main/docs/api.md#instrumentation).

Creating the Instrumentation resource correctly is paramount to getting auto-instrumentation working. Making sure all endpoints and env vars are correct is required for auto-instrumentation to work properly.

*JAVA*

The following YAML creates a basic Instrumentation resource that is configured for instrumenting Java services.

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: otel-instrumentation-sample
spec:
  components:
    - type: "k8s-objects"
      name: "otel-deploy"
      properties:
        objects:
          - apiVersion: apps/v1
            kind: Deployment
            metadata:
              name: my-app
              labels:
                app: my-app
            spec:
              selector:
                matchLabels:
                  app: my-app
              replicas: 1
              template:
                metadata:
                  labels:
                    app: my-app
                  annotations:
                    instrumentation.opentelemetry.io/inject-java: "true"
                spec:
                  containers:
                    - name: myapp
                      image: jaegertracing/vertx-create-span:operator-e2e-tests
                      ports:
                        - containerPort: 8080
                          protocol: TCP
      traits:
        - type: opentelemetry-instrumentation
          properties:
            exporter:
              # endpoint: ""      // Collector endpoint url here, if configured collector is availble.
            propagators:
              - tracecontext
              - baggage
            sampler:
              type: parentbased_traceidratio
              argument: "1"
```

For more details, see [Java Agent Configuration](https://opentelemetry.io/docs/instrumentation/java/automatic/agent-config/).

For other language support information visit https://opentelemetry.io/docs/collector/.

Add language suitable annotation in pod templates to configure auto-instrumentation:

Java:

```yaml
instrumentation.opentelemetry.io/inject-java: "true"
```

NodeJS:

```yaml
instrumentation.opentelemetry.io/inject-nodejs: "true"
```

Python:

```yaml
instrumentation.opentelemetry.io/inject-python: "true"
```

DotNet:

```yaml
instrumentation.opentelemetry.io/inject-dotnet: "true"
```

The possible values for the annotation can be

- `"true"` - inject and `Instrumentation` resource from the namespace.
- `"my-instrumentation"` - name of `Instrumentation` CR instance in the current namespace.
- `"my-other-namespace/my-instrumentation"` - name and namespace of `Instrumentation` CR instance in another namespace.
- `"false"` - do not inject.

For more visit https://opentelemetry.io/docs/k8s-operator/.
