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

Let's have a look at the scaling rule used in the demo. It means that, if the aggregated value of the per-second rate of HTTP requests as measured ove the last 2 minutes is or less than 3, then there will be one Pod. If it goes up, autoscaler will create more Pods, e.g. if the value turns into 12 to 14, the number of Pods will be 4.


```yaml
promQuery: sum(rate(http_requests[2m])) # custom Prometheus query
promThreshold: 3 # custom scaling threshold
```
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

Besides resources generated for ContainerizedWorkload, you may pay attention to autoscaling related resources, HPA and deployment&service for Prometheus.
```shell
kubectl get deployments
NAME                                         READY   UP-TO-DATE   AVAILABLE   AGE
example-component-cw                         1/1     1            1           65m
prometheus-deployment-example-component-cw   1/1     1            1           65m
```

```shell
kubectl get services
NAME                                      TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
example-component-cw                      NodePort    10.103.250.144   <none>        8080:31219/TCP   66m
prometheus-service-example-component-cw   ClusterIP   10.98.88.11      <none>        9090/TCP         66m
```

```shell
kubectl get hpa

NAME                            REFERENCE                         TARGETS     MINPODS   MAXPODS   REPLICAS   AGE
keda-hpa-example-component-cw   Deployment/example-component-cw   0/3 (avg)   1         10        1          67m
```

## Trigger scaling up/down
Before trigger scaling, let's have a look at the scaling rule used in the demo.

The demo component exposes two endpoints, `/metrics` and `/test`, the former one is used for Prometheus and the latter one is used for calling to increase workload. 

Here's the scaling rule. It means that, if the aggregated value of the per-second rate of HTTP requests as measured ove the last 2 minutes is or less than 3, then there will be one Pod. If it goes up, autoscaler will create more Pods, e.g. if the value turns into 12 to 14, the number of Pods will be 4.


```yaml
promQuery: sum(rate(http_requests[2m])) # custom Prometheus query
promThreshold: 3 # custom scaling threshold
```

Let's increase workload to trigger scaling up. 

- First, forward target service to localhost. After that you should be able to access the endpoints.
```shell
kubectl port-forward service/example-component-cw  8080
curl http://localhost:8080/test

##output
Accessed on 2020-07-07 09:29:27.394112421 +0000 UTC m=+5068.136043767
Access count +1
```

- Then, increase the workload ...
```shell
while true; do curl http://localhost:8080/test; done
```

- Check the HPA target metrics and you will find it starts to scale up. Like below shows, `TARGETS` comes into `5/3`, which means one more pod being created.
```shell
kubectl get hpa
##output
NAME                            REFERENCE                         TARGETS     MINPODS   MAXPODS   REPLICAS   AGE
keda-hpa-example-component-cw   Deployment/example-component-cw   5/3 (avg)   1         10        1          89m
```

```shell
kubectl get pods 
##output
NAME                                                         READY   STATUS    RESTARTS   AGE
example-component-cw-5569bf6fd-5dkdc                         1/1     Running   0          91m
example-component-cw-5569bf6fd-mxl7m                         1/1     Running   0          86s
```
- Shut down the calling loop and wait for minutes. Then scaling down occurs.
```shell
kubectl get hpa
##output
NAME                            REFERENCE                         TARGETS     MINPODS   MAXPODS   REPLICAS   AGE
keda-hpa-example-component-cw   Deployment/example-component-cw   0/3 (avg)   1         10        2          95m
```

## What happened behind the scenes

After deploying the ApplicationConfiguration, OAM runtime creates a service & a deployment for the component as well as one MetricHPATrait object. Then the MetriHPATrait controller can fetch the information of the deployment and create a KEDA `scaledobject` CR object whose "scale target" is the deployment. 

Meanwhile, MetricHPATrait controller creates a new Prometheus server and set the component service's endpoints as its monitoring target. This Prometheus's infor is also fulfilled into newly created KEDA `scaledobject` CR object. 

> 💥 Please note that, `MetricHPATrait` CR provides an optional field `promServerAddress` to accept any Prometheus address. If it's fulfilled, MetricHPATrait controller will use the Prometheus provided instead of creating new one. It's highly recommeded to use your own Prometheus.  

After that, KEDA operator will take over everything left.

At first, KEDA will create a k8s native HPA for the target deployment. The HPA has an external metrics source assigned by KEDA. Significantly, KEDA operator plays a role as metric server providing metrics registered for all `scaledobject` CR objects, e.g. in this demo, metrics from Prometheus. 

The real scaling works are handled by native HPA. It will scrape metrics fro KEDA metris server periodically. When flucuation beyond the threshold detected, HPA will trigger scaling operation. Overall pic shows as below. 

![image](./assets/MetricHPATrait.png)
