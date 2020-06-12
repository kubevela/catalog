# IngressTrait
You can use IngressTrait to create a ingress for the workload on a Kubernetes cluster.

Supported workloads:
- ContainerizedWorkload
- StatefulSet
- Deployment

# Getting started
- At first, you should follow [addon-oam-kubernetes-local](https://github.com/crossplane/addon-oam-kubernetes-local). And install OAM Application Controller and OAM Core workload and trait controller.
- Then you should deploy ServiceTrait controller by following [ServiceTrait](../servicetrait).
- Get the IngressTrait project to your GOPATH
```
git clone https://github.com/oam-dev/catalog.git
```
- Fetch the IngressTrait image
```
docker pull chienwong/ingresstrait:v1.1
```
- Deploy the IngressTrait controller
```
cd catalog/traits/ingresstrait/

make deploy IMG=chienwong/ingresstrait:v1.1
```
- Apply the sample application config
```
kubectl apply -f config/samples/
```
- Verify IngressTrait you should see a statefulset looking like below
```
kubectl get statefulset
NAME   READY   AGE
web    1/1     9s
```
And a service looking like below
```
kubectl get service
NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
test         ClusterIP   10.105.129.64   <none>        80/TCP    12s
```
And a ingress looking like below
```
kubectl get ingress
NAME                    HOSTS           ADDRESS      PORTS   AGE
example-ingress-trait   nginx.oam.com   172.18.0.2   80      63s
```
