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

The Collector can be deployed as one of four modes: `Deployment`, `DaemonSet`, `StatefulSet` and `Sidecar`. The default mode is `Deployment`. We will introduce the benefits and use cases of each mode as well as giving an example for each.

**Deployment Mode**

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
                grpc:
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

**DaemonSet Mode**

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
                grpc:
          processors:

          exporters:
            logging:
              loglevel: debug

          service:
            pipelines:
              traces:
                receivers: [jaeger]
                processors: []
                exporters: [logging]
```

**StatefulSet Mode**

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
        replicas: 3
        config: |
          receivers:
            jaeger:
              protocols:
                grpc:
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

**Sidecar Mode**

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
$ kubectl port-forward -n prod myapp 8888

# Access prometheus metrics.
$ curl http://localhost:8888
```

### Instrumentation

The OpenTelemetry Operator supports injecting and configuring auto-instrumentation libraries for .NET, Java, NodeJS and Python services.

**Create an OpenTelemetry Collector (Optional)**

It is a best practice to send telemetry from containers to an [OpenTelemetry Collector](https://opentelemetry.io/docs/collector/) instead of directly to a backend. The Collector helps simplify secret management, decouples data export problems (such as a need to do retries) from your apps, and lets you add additional data to your telemetry, such as with the [k8sattributesprocessor](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/processor/k8sattributesprocessor) component. If you chose not to use a Collector, you can skip to the next section.

When using the Deployment mode the operator will also create a Service that can be used to interact with the Collector. The name of the service is the name of the `OpenTelemetryCollector` resource prepended to -collector. For our example that will be `demo-collector`.

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: otel-collector-sample
spec:
  components:
    - type: "opentelemetry-collector"
      name: "demo"
      properties:
        config: |
          receivers:
            otlp:
              protocols:
                grpc:
                http:
          processors:
            memory_limiter:
              check_interval: 1s
              limit_percentage: 75
              spike_limit_percentage: 15
            batch:
              send_batch_size: 10000
              timeout: 10s

          exporters:
            logging:

          service:
            pipelines:
              traces:
                receivers: [otlp]
                processors: [memory_limiter, batch]
                exporters: [logging]
              metrics:
                receivers: [otlp]
                processors: [memory_limiter, batch]
                exporters: [logging]
              logs:
                receivers: [otlp]
                processors: [memory_limiter, batch]
                exporters: [logging]
```

The above YAML results in a deployment of the Collector that you can use as an endpoint for auto-instrumentation in your pods.

**Configure Autoinstrumentation**

To be able to manage autoinstrumentation, the Operator needs to be configured to know what pods to instrument and which autoinstrumentation to use for those pods. This is done via the [Instrumentation CRD](https://github.com/open-telemetry/opentelemetry-operator/blob/main/docs/api.md#instrumentation).

Creating the Instrumentation resource correctly is paramount to getting auto-instrumentation working. Making sure all endpoints and env vars are correct is required for auto-instrumentation to work properly.

*.NET*

The following YAML will create a basic Instrumentation resource that is configured specifically for instrumenting .NET services.

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: otel-instrumentation-sample
spec:
  components:
    - type: "opentelemetry-instrumentation"
      name: "opentelemetry-instrumentation"
      properties:
        exporter:
          endpoint: http://demo-collector:4318
        propagators:
          - tracecontext
          - baggage
        sampler:
          type: parentbased_traceidratio
          argument: "1"
```

By default, the Instrumentation resource that auto-instruments .NET services uses otlp with the http/protobuf protocol. This means that the configured endpoint must be able to receive OTLP over http/protobuf. Therefore, the example uses http://demo-collector:4318, which will connect to the http port of the otlpreceiver of the Collector created in the previous step.

By default, the .NET auto-instrumentation ships with many instrumentation libraries. This makes instrumentation easy, but could result in too much or unwanted data. If there are any libraries you do not want to use you can set the OTEL_DOTNET_AUTO_[SIGNAL]_[NAME]_INSTRUMENTATION_ENABLED=false where [SIGNAL] is the type of the signal and [NAME] is the case-sensitive name of the library.

```YAML
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: otel-instrumentation-sample
spec:
  components:
    - type: "opentelemetry-instrumentation"
      name: "opentelemetry-instrumentation"
      properties:
        exporter:
          endpoint: http://demo-collector:4318
        propagators:
          - tracecontext
          - baggage
        sampler:
          type: parentbased_traceidratio
          argument: "1"
        dotnet:
          env:
            - name: OTEL_DOTNET_AUTO_TRACES_GRPCNETCLIENT_INSTRUMENTATION_ENABLED
              value: false
            - name: OTEL_DOTNET_AUTO_METRICS_PROCESS_INSTRUMENTATION_ENABLED
              value: false
```

For more details, see [.NET Auto Instrumentation docs](https://opentelemetry.io/docs/instrumentation/net/automatic/).

*JAVA*

The following command creates a basic Instrumentation resource that is configured for instrumenting Java services.

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: otel-instrumentation-sample
spec:
  components:
    - type: "opentelemetry-instrumentation"
      name: "opentelemetry-instrumentation"
      properties:
        exporter:
          endpoint: http://demo-collector:4317
        propagators:
          - tracecontext
          - baggage
        sampler:
          type: parentbased_traceidratio
          argument: "1"
```

By default, the Instrumentation resource that auto-instruments Java services uses otlp with the grpc protocol. This means that the configured endpoint must be able to receive OTLP over grpc. Therefore, the example uses http://demo-collector:4317, which connects to the grpc port of the otlpreceiver of the Collector created in the previous step.

By default, the Java auto-instrumentation ships with many instrumentation libraries. This makes instrumentation easy, but could result in too much or unwanted data. If there are any libraries you do not want to use you can set the OTEL_INSTRUMENTATION_[NAME]_ENABLED=false where [NAME] is the name of the library. If you know exactly which libraries you want to use, you can disable the default libraries by setting OTEL_INSTRUMENTATION_COMMON_DEFAULT_ENABLED=false and then use OTEL_INSTRUMENTATION_[NAME]_ENABLED=true where [NAME] is the name of the library. For more details, see [Suppressing specific auto-instrumentation](https://opentelemetry.io/docs/instrumentation/java/automatic/agent-config/#suppressing-specific-auto-instrumentation).

```YAML
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: otel-instrumentation-sample
spec:
  components:
    - type: "opentelemetry-instrumentation"
      name: "opentelemetry-instrumentation"
      properties:
        exporter:
          endpoint: http://demo-collector:4317
        propagators:
          - tracecontext
          - baggage
        sampler:
          type: parentbased_traceidratio
          argument: '1'
        java:
          env:
            - name: OTEL_INSTRUMENTATION_KAFKA_ENABLED
              value: false
            - name: OTEL_INSTRUMENTATION_REDISCALA_ENABLED
              value: false
```

For more details, see [Java Agent Configuration](https://opentelemetry.io/docs/instrumentation/java/automatic/agent-config/).

*Node.js*

The following command creates a basic Instrumentation resource that is configured for instrumenting Node.js services.

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: otel-instrumentation-sample
spec:
  components:
    - type: "opentelemetry-instrumentation"
      name: "opentelemetry-instrumentation"
      properties:
        exporter:
          endpoint: http://demo-collector:4317
        propagators:
          - tracecontext
          - baggage
        sampler:
          type: parentbased_traceidratio
          argument: "1"
```

By default, the Instrumentation resource that auto-instruments Node.js services uses otlp with the grpc protocol. This means that the configured endpoint must be able to receive OTLP over grpc. Therefore, the example uses http://demo-collector:4317, which connects to the grpc port of the otlpreceiver of the Collector created in the previous step.

By default, the Node.js auto-instrumentation ships with many instrumentation libraries. At the moment, there is no way to opt-in to only specific packages or disable specific packages. If you don’t want to use a package included by the default image you must either supply your own image that includes only the packages you want or use manual instrumentation.

For more details, see [Node.js auto-instrumentation](https://opentelemetry.io/docs/instrumentation/js/libraries/#node-autoinstrumentation-package).

*Python*

The following command will create a basic Instrumentation resource that is configured specifically for instrumenting Python services.

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: otel-instrumentation-sample
spec:
  components:
    - type: "opentelemetry-instrumentation"
      name: "opentelemetry-instrumentation"
      properties:
        exporter:
          endpoint: http://demo-collector:4318
        propagators:
          - tracecontext
          - baggage
        sampler:
          type: parentbased_traceidratio
          argument: "1"
```

By default, the Instrumentation resource that auto-instruments python services uses otlp with the http/protobuf protocol. This means that the configured endpoint must be able to receive OTLP over http/protobuf. Therefore, the example uses http://demo-collector:4318, which will connect to the http port of the otlpreceiver of the Collector created in the previous step.

By default the Python auto-instrumentation will detect the packages in your Python service and instrument anything it can. This makes instrumentation easy, but can result in too much or unwanted data. If there are any packages you do not want to instrument, you can set the OTEL_PYTHON_DISABLED_INSTRUMENTATIONS environment variable

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: otel-instrumentation-sample
spec:
  components:
    - type: "opentelemetry-instrumentation"
      name: "opentelemetry-instrumentation"
      properties:
        exporter:
          endpoint: http://demo-collector:4318
        propagators:
          - tracecontext
          - baggage
        sampler:
          type: parentbased_traceidratio
          argument: '1'
        python:
          env:
            - name: OTEL_PYTHON_DISABLED_INSTRUMENTATIONS
              value:
                <comma-separated list of package names to exclude from
                instrumentation>
```

Then add an annotation to a pod to enable injection. The annotation can be added to a namespace, so that all pods within that namespace wil get instrumentation, or by adding the annotation to individual PodSpec objects, available as part of Deployment, Statefulset, and other resources.

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

**For Multi-container pods**

If nothing else is specified, instrumentation is performed on the first container available in the pod spec. In some cases (for example in the case of the injection of an Istio sidecar) it becomes necessary to specify on which container(s) this injection must be performed.

For this, it is possible to fine-tune the pod(s) on which the injection will be carried out.

For this, we will use the instrumentation.opentelemetry.io/container-names annotation for which we will indicate one or more pod names (.spec.containers.name) on which the injection must be made:

Template:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-deployment-with-multiple-containers
spec:
  selector:
    matchLabels:
      app: my-pod-with-multiple-containers
  replicas: 1
  template:
    metadata:
      labels:
        app: my-pod-with-multiple-containers
      annotations:
        instrumentation.opentelemetry.io/inject-java: "true"
        instrumentation.opentelemetry.io/container-names: "myapp,myapp2"
    spec:
      containers:
      - name: myapp
        image: myImage1
      - name: myapp2
        image: myImage2
      - name: myapp3
        image: myImage3
```

In the above case, `myapp` and `myapp2` containers will be instrumented, `myapp3` will not.

For more visit https://opentelemetry.io/docs/k8s-operator/.
