# IngressTrait
You can use IngressTrait to create a ingress for the workload on a Kubernetes cluster.

# Getting started
- At first, you should follow [addon-oam-kubernetes-local](https://github.com/crossplane/addon-oam-kubernetes-local). And install OAM Application Controller and OAM Core workload and trait controller.
- Then you should deploy StatefulSetWorkload controller and ServiceTrait controller by following [StatefulSetWorkload](https://github.com/My-pleasure/statefulsetworkload#getting-started)、[ServiceTrait](https://github.com/My-pleasure/servicetrait/blob/v1alpha2/README.md#getting-started).
- Get the IngressTrait project to your GOPATH
```
git clone https://github.com/My-pleasure/ingresstrait.git
```
- Fetch the IngressTrait image
```
docker pull chienwong/ingresstrait:v0.7
```
- Deploy the IngressTrait controller
```
cd ingresstrait/

make deploy IMG=chienwong/ingresstrait:v0.7
```
- Apply the sample application config
```
kubectl apply -f config/samples/
```
- Verify IngressTrait you should see a ingress looking like below
```
kubectl get ingress
NAME                              HOSTS              ADDRESS      PORTS   AGE
example-appconfig-trait-ingress   ingress.test.com   172.18.0.3   80      4m13s
```
