# ServiceTrait
You can use ServiceTrait to create a k8s service for workload on a Kubernetes cluster.

Supported resources:
- ContainerizedWorkload
- StatefulSet
- Deployment
# Getting started
- At first, you should follow [addon-oam-kubernetes-local](https://github.com/crossplane/addon-oam-kubernetes-local). And install OAM Application Controller and OAM Core workload and trait controller.
- Get the Servicetrait project to your GOPATH
```
git clone https://github.com/oam-dev/catalog.git
```
- Fetch the servicetrait image
```
docker pull chienwong/servicetrait:v1.6
```
- Deploy the servicetrait controller.
```
cd catalog/traits/experimental/servicetrait

make deploy IMG=chienwong/servicetrait:v1.6
```
- Apply the sample application config
```
kubectl apply -f config/samples/
```
- Verify ServiceTrait you should see a statefulset looking like below
```
kubectl get statefulset
NAME  READY   AGE
web   1/1     19s
```
  And a service looking like below
```
kubectl get service
NAME   TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
test   NodePort    10.103.191.25   <none>        80:32502/TCP   15s
```
