# ServiceTrait
You can use ServiceTrait to create a service for the workload on a Kubernetes cluster, like [ManualScalerTrait](https://github.com/oam-dev/spec/blob/master/core/traits/manual_scaler_trait.md).
# Getting started
- At first, you should follow [addon-oam-kubernetes-local](https://github.com/crossplane/addon-oam-kubernetes-local). And install OAM Application Controller and OAM Core workload and trait controller.
- Then, you should deploy a StatefulSetWorkload controller by following [statefulsetworkload](https://github.com/My-pleasure/statefulsetworkload#getting-started).
- Get the Servicetrait project to your GOPATH
```
git clone https://github.com/My-pleasure/statefulsetworkload.git
```
- Fetch the servicetrait image
```
docker pull chienwong/servicetrait:v0.6
```
- Deploy the servicetrait controller.
```
cd servicetrait/

make deploy IMG=chienwong/servicetrait:v0.6
```
- Apply the sample application config
```
kubectl apply -f config/samples/
```
- Verify ServiceTrait you should see a statefulset looking like below
```
kubectl get statefulset
NAME                         READY   AGE
example-appconfig-workload   1/1     19s
```
  And a service looking like below
```
kubectl get service
NAME                             TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
example-appconfig-workload-svc   ClusterIP   10.107.41.172   <none>        80/TCP    23s
```
# Future work
Now the ServiceTrait can only create a service for the StatefulSetWorkload, and it will support more workloads like ContainerizedWorkload in the future.
