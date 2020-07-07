# MetricHPATrait

Metric HorizontalPodAutoscaler Trait is used to sep up autoscaling based on any custom metrics from Prometheus.

The trait is going to setup an external metrics to auto-scale a K8s application. Instead of using native HPA directly, just like what we do in [oam-dev/HPATrait](https://github.com/oam-dev/catalog/tree/master/traits/hpatrait), MetricHPATrait will leverage Kubernetes Event Driven Autoscaling (KEDA) - an open source K8s operator which integrates natively with the HPA to provide fine-grained autoscaling for event-driven workloads. Prometheus can be used one of KEDA's autoscaling trigger. MetricHPATrait integrates Prometheus and KEDA to set up autoscaling based on Prometheus metrics. 

## Support workloads:
- ContainerizedWorkload
- Deployment

## Prerequisites
- Please follow [common prerequisites](../../README.md) to setup OAM runtime and make sure [HPA  is enabled](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/#before-you-begin) on your Kubernetes cluster, since this trait depends on Kubernetes native HPA. 

- Make sure your application is enabled to be monitored by Prometheus

- [Deploy KEDA](https://keda.sh/docs/1.4/deploy/#helm) on your Kubernetes cluster


## Demo

Here's a brief of the demo. 
- We add one MetricHPATrait to a component whose workload is ContainerizedWorkload. 
```yaml
apiVersion: core.oam.dev/v1alpha2
kind: ApplicationConfiguration
metadata:
  name: example-appconfig
spec:
  components:
    - componentName: example-component-mhpa
      parameterValues:
        - name: instance-name
          value: example-component-cw 
      traits:
        - trait:
            apiVersion: extend.oam.dev/v1alpha2
            kind: MetricHPATrait
            metadata:
              name:  example-mhpatrait
            spec:
              pollingInterval: 15
              cooldownPeriod: 30
              minReplicaCount: 1
              maxReplicaCount: 10
              promQuery: sum(rate(http_requests[2m])) # custom Prometheus query
              promThreshold: 3 # custom scaling threshold
```
- The component contains an application that can interact with Prometheus server. More detail, the app exposes HTTP access count metrics in Prometheus format. The trait will set up a Prometheus server to scrape the metrics from the app. 
- Then the metrics from Prometheus will be used as scale criteria of one HPA created by KEAD and targeting the deployment of the componenone. 
- When increase access workload of the component, scaling out occurs according to the threshold specified in the trait config. After trafic peak, it will scale down after specified cool-down interval time.

## Get started
- Clone the project into your $GOPATH
```shell
git clone https://github.com/oam-dev/catalog.git
```
-  Load the CRD
```shell
cd catalog/traits/metrichpatrait
make install
``` 
- Run the controller locally
```shell
go run main.go
```
- Apply the sample OAM/ApplicationConfiguration
```shell
kubectl apply -f ./config/samples
```

## Verify generated resources

## Trigger scaling up/down
