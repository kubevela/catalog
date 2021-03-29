# KubeVela Metrics Trait
This trait is designed to provide an easy way for an OAM application operator to collect metrics from any workload
that emits metrics through an endpoint reachable from within the cluster. 
The metrics traits relies on [Prometheus operator](https://github.com/coreos/prometheus-operator) and
[Prometheus helm chart](https://github.com/helm/charts/tree/master/stable/prometheus-operator). 

## Install
Make sure [KubeVela](https://kubevela.io/docs/install) is installed in your cluster

Install metrics trait controller with helm

1. Add helm chart repo for metrics trait
    ```shell script
    helm repo add oam.catalog  http://oam.dev/catalog/
    ```

2. Update the chart repo
    ```shell script
    helm repo update
    ```

3. Install metrics trait controller
    ```shell script
    helm install --create-namespace -n vela-system metricstrait oam.catalog/metricstrait

4. Apply [definition yaml](../../registry/metrics.yaml) in registry.

## Setting metrics policy
With this trait, an application operator only needs to specify a few fields to extract metrics from the workloads the trait attached to.
Here are the brief descriptions of each field and its usage.

| Name | Optional | Default | Description |
| ---- | ----------- | -------- | --------- |
| format            | Yes  | "prometheus" | The format of the data. The only format we support now is prometheus|
| port              | Yes  | N/A  | The pod port that exposes the metrics data. We use this to locate either a service or a pod   |
| selector          | Yes  | N/A | The selector that can be used to label select target pods. The default uses the labels on the workload.|
| path              | Yes  | "/metrics" | path to scrape for metrics from the end point.  |
| scheme            | Yes  | "http"  | The scrap scheme that we support. We only support http for now.  |
| enabled           | Yes  | "true"  | Switch for the trait to be turned on or off. |

There are two major scenarios when the metrics trait work.   
## Collect metrics through an existing service
One is that the workload it associated with already has a service exposes the metrics endpoints. 
The workload owner has to use `workloadDefinition` to indicate that in its `ChildResourceKinds` fields. 
In this case, the trait controller uses the `portName` field to locate the matching service.   
Here is an example metrics trait CR that will create a `servcieMonitor` object to collect metrics through the matching service. 
Please note that this means the `portName` needs to be **unique** among the services that expose the workload.
```yaml
 apiVersion: standard.oam.dev/v1alpha1
 kind: MetricsTrait
 metadata:
   name: metricstrait-sample-with-service
 spec:
   scrapeService:
     portName: http
```
For details, please refer to an application [example](config/samples/application/README.md) using deployment as a workload.


## Collect metrics without an existing service
The metrics trait controller will create a service when the workload doesn't come with a service. 
It relies on the `targetPort` and `targetSelector` field to locate the pod and its port that exposes the metrics.  
Here is an example metrics trait CR that will create a `service` to expose the pod port.

```yaml
 apiVersion: standard.oam.dev/v1alpha1
 kind: MetricsTrait
 metadata:
   name: metricstrait-sample-without-service
 spec:
   scrapeService:
     format: "prometheus"
     targetPort: 8080
     targetSelector:
       app: sample-app
     path: "/anypath"
     scheme:  "http"
     enabled: true
```
For details, please refer to an application [example](config/samples/application/README.md) using deployment as a workload.


## License
By contributing to the OAM category repository, you agree that your contributions will be licensed under its [Apache 2.0
 License](https://github.com/oam-dev/catalog/blob/master/LICENSE).