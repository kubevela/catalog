# HorizontalPodAutoscalerTrait

HorizontalPodAutoscalerTrait (HPATrait) is used to create Kubernetes HorizontalPodAutoscaler for workloads on Kubernetes clusters.

## Support workloads:
- ContainerizedWorkload
- Stateful
- Deployment

## Prerequisites
- Please follow [common prerequisites](../../README.md) to setup OAM runtime and make sure [HPA  is enabled](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/#before-you-begin) on your Kubernetes cluster. 

- If you are using minikube Kubernetes, please enable `metrics-server` addon.
```shellscript
minukube addon enable metrics-server
minukube addons list

|-----------------------------|----------|--------------|
|         ADDON NAME          | PROFILE  |    STATUS    |
|-----------------------------|----------|--------------|
| ambassador                  | minikube | disabled     |
| dashboard                   | minikube | disabled     |
| default-storageclass        | minikube | enabled ✅   |
...
| metrics-server              | minikube | enabled ✅   |
...
| storage-provisioner         | minikube | enabled ✅   |
| storage-provisioner-gluster | minikube | disabled     |
|-----------------------------|----------|--------------|
```
- To observe the autoscale and downscale bit easier during verification, you can override the default values as below when launch Kubernetes.
```
minikube start \
--extra-config=controller-manager.horizontal-pod-autoscaler-upscale-delay=1m \
--extra-config=controller-manager.horizontal-pod-autoscaler-downscale-delay=1m \
--extra-config=controller-manager.horizontal-pod-autoscaler-sync-period=10s \
--extra-config=controller-manager.horizontal-pod-autoscaler-downscale-stabilization=1m
```

## Get started
- Clone the project into your $GOPATH
```
git clone https://github.com/oam-dev/catalog.git
```
-  Load the CRD
```
cd catalog/traits/hpatrait
make install
``` 
- Run the controller locally
```
go run main.go
```
- Apply the sample OAM/ApplicationConfiguration
```
kubectl apply -f ./config/samples
```

HPA trait supports `ContainerizedWorkload`, `Deployment` and `StatefulSet` workloads. In this example, we use `ContainerizedWorkload` to show how HPA trait works. Please notice that `spec.containers.resources` is indispensable for each container declared in the component, as it's required by [Kubernetes native HPA](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) but not HPA trait. HPA trait controller will raise an error for missing value of this field.
```
# ./config/samples/sample_component.yaml

...
    kind: ContainerizedWorkload
    spec:
      containers:
        - name: php-apache
          image: k8s.gcr.io/hpa-example
          ports:
            - containerPort: 80
              name: pa
          resources: # required for HPA
            cpu: 
              required: 100m
            memory:
              required: 200m
...
```

## Verify generated resources

Below OAM resources are created.

```
kubectl get ApplicationConfiguration
NAME                AGE
example-appconfig    2m
```
```
kubectl get Component
NAME                    WORKLOAD-KIND
example-component       ContainerizedWorkload
```
```
kubectl get horizontalpodautoscalertraits
NAME               AGE
example-hpatrait    2m
```

Correspondingly, below Kubernetes native resources are created.
```
kubectl get pods
NAME                          READY   STATUS    RESTARTS   AGE
php-apache-59864b9c8d-bfcrt   1/1     Running   0          2m
```
```
kubectl get deployments
NAME                         READY   UP-TO-DATE   AVAILABLE   AGE
php-apache                     1/1     1            1           2m
```
```
kubectl get hpa
NAME                     REFERENCE         TARGETS               MINPODS   MAXPODS   REPLICAS   AGE
example-hpatrait   Deployment/php-apache   <unknown>/30%          1         10        1          1m
```
About one minute later, it will turn out as below when HPA fetches metrics successfully.
```
kubectl get hpa
NAME                     REFERENCE         TARGETS         MINPODS   MAXPODS   REPLICAS   AGE
example-hpatrait   Deployment/php-apache   0%/30%          1         10        1          2m
```
Additionally, there's a `service` newly created with `ContainerizedWorkload` workload. 
```
kubectl get svc
NAME         TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE
php-apache   NodePort    10.109.18.92   <none>        80:32150/TCP   2m
```
## Verify HPA works
According to our HPA trait configuration, HPA is indicated auto-scale based on CPU Utilization of 30% and max replicas to be 10 pods and min to be 1 post downscale.
```
#./config/samples/sample_application_config.yaml

...
      traits:
        - trait:
            apiVersion: core.oam.dev/v1alpha2
            kind: HorizontalPodAutoscalerTrait
            metadata:
              name:  example-hpatrait
            spec:
              minReplicas: 1
              maxReplicas: 10
              targetCPUUtilizationPercentage: 30
...
```

### Increase load
Now, we will see how the autoscaler reacts to increased load. We will start a container, and send an infinite loop of queries to the php-apache service :
```
kubectl run -it --rm load-generator --image=busybox /bin/sh

Hit enter for command prompt

while true; do wget -q -O- http://php-apache; done
```
Within a minute or so, we should see the higher CPU load by executing:
```
kubectl get hpa
NAME               REFERENCE                     TARGET      MINPODS   MAXPODS   REPLICAS   AGE
example-hpatrait   Deployment/php-apache         381%/30%      1         10        1          5m
```
 As a result, the deployment was resized to 10 replicas:
 ```
kubectl get deployment php-apache
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
php-apache   10/10      10           10       8m
 ```
### Stop load
In the terminal where we created the container with busybox image, terminate the load generation by typing Ctrl + C.

Then we will verify the result state (after a minute or so):
```
kubectl get hpa
NAME               REFERENCE                     TARGET      MINPODS   MAXPODS   REPLICAS   AGE
example-hpatrait   Deployment/php-apache         0%/30%      1         10        1          10m
```
```
kubectl get deployment php-apache
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
php-apache   1/1     1            1           12m
```
