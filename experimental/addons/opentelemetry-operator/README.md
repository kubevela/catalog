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

Once the opentelemetry-operator addon enabled successfully, you can deploy OpenTelemetry Collector in your Kubernetes cluster.

The Collector can be deployed as one of four modes: `Deployment`, `DaemonSet`, `StatefulSet` and `Sidecar`. The default mode is `Deployment`. We will introduce the benefits and use cases of each mode as well as giving an example for each.

### Deployment Mode

If you want to get more control of the OpenTelemetry Collector and create a standalone application, Deployment would be your choice. With Deployment, you can relatively easily scale up the Collector to monitor more targets, roll back to an early version if anything unexpected happens, pause the Collector, etc. In general, you can manage your Collector instance just as an application.

The following example configuration deploys the Collector as Deployment resource. The receiver is Jaeger receiver and the exporter is logging exporter.

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: otel-collector-sample
spec:
  components:
    - type: "opentelemetry-collector"
      name: "otel-container"
      properties:
        mode: deployment       # This configuration is omittable.
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

### DaemonSet Mode

DaemonSet should satisfy your needs if you want the Collector run as an agent in your Kubernetes nodes. In this case, every Kubernetes node will have its own Collector copy which would monitor the pods in it.

The following example configuration deploys the Collector as DaemonSet resource. The receiver is Jaeger receiver and the exporter is logging exporter.

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: otel-collector-sample
spec:
  components:
    - type: "opentelemetry-collector"
      name: "otel-container"
      properties:
        mode: daemonset
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

### StatefulSet Mode

There are basically three main advantages to deploy the Collector as the StatefulSet:

- Predictable names of the Collector instance will be expected
  If you use above two approaches to deploy the Collector, the pod name of your Collector instance will be unique (its name plus random sequence). However, each Pod in a StatefulSet derives its hostname from the name of the StatefulSet and the ordinal of the Pod (my-col-0, my-col-1, my-col-2, etc.).

- Rescheduling will be arranged when a Collector replica fails
  If a Collector pod fails in the StatefulSet, Kubernetes will attempt to reschedule a new pod with the same name to the same node. Kubernetes will also attempt to attach the same sticky identity (e.g., volumes) to the new pod.

The following example configuration deploys the Collector as StatefulSet resource with three replicas. The receiver is Jaeger receiver and the exporter is logging exporter.

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: otel-collector-sample
spec:
  components:
    - type: "opentelemetry-collector"
      name: "otel-container"
      properties:
        mode: statefulset
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

### Sidecar Mode

The biggest advantage of the sidecar mode is that it allows people to offload their telemetry data as fast and reliable as possible from their applications. This Collector instance will work on the container level and no new pod will be created, which is perfect to keep your Kubernetes cluster clean and easily to be managed. Moreover, you can also use the sidecar mode when you want to use a different collect/export strategy, which just suits this application.

Once a Sidecar instance exists in a given namespace, you can have your deployments from that namespace to get a sidecar by either adding the annotation sidecar.opentelemetry.io/inject: true to the pod spec of your application, or to the namespace.

See the [OpenTelemetry Operator github repository](https://github.com/open-telemetry/opentelemetry-operator) for more detailed information.

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: otel-collector-sample
spec:
  components:
    - type: "opentelemetry-collector"
      name: "otel-container"
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

Now, Create a pod with below YAML and see an additional otc-container of opentelemetry-collector will be created in the pod.

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: otel-deploy-sample
spec:
  components:
    - type: "k8s-objects"
      name: "otel-pod"
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
                    sidecar.opentelemetry.io/inject: "true"
                spec:
                  containers:
                    - name: myapp
                      image: jaegertracing/vertx-create-span:operator-e2e-tests
                      ports:
                        - containerPort: 8080
                          protocol: TCP
```

Now, Access all the traces created by the running application container in the pod as the logs of the otc-container created in the same pod the metrics by port-forwarding technique

If you want to access prometheus metrics data :

```shell
# Port-forward the port.
kubectl port-forward -n prod myapp 8888

# Access prometheus metrics.
curl http://localhost:8888
```

For more visit https://opentelemetry.io/docs/k8s-operator/.
