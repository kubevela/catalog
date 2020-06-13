# HorizontalPodAutoscalerTrait

HorizontalPodAutoscalerTrait (HPATrait) is used to create Kubernetes HorizontalPodAutoscaler for workloads on Kubernetes clusters.

## Support workloads:
- ContainerizedWorkload
- Stateful
- Deployment

## Prerequisites
Please follow [addon-oam-kubernetes-local](https://github.com/crossplane/addon-oam-kubernetes-local) to setup oam runtime and make sure [HPA  is enabled](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/#before-you-begin) on your kubernetes cluster. 

If you are using minikube kubernetes, please enable `mertics-server` addon.
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

## Get started
- Clone the project into your $GOPATH
```
https://github.com/captainroy-hy/hpatrait.git
```
-  Load the CRD
```
cd hpatrait
make install
``` 
- Run the controller locally
```
go run main.go
```
- Apply the sample OAM/ApplicationConfiguration
```
kubectl apply -f hpatrait/config/samples
```

- Verify
In this sample, below resources are created.

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
kubectl get deployments
NAME                         READY   UP-TO-DATE   AVAILABLE   AGE
example-appconfig-workload   1/1     1            1           58m
```
And the `HorizontalPodAutoscaler` created by the HPATrait
```
kubectl get hpa
NAME                     REFERENCE                               TARGETS         MINPODS   MAXPODS   REPLICAS   AGE
example-hpa-trait        Deployment/example-appconfig-workload   0%/30%   1         3         1          61m
```
