# StatefulSetWorkload
You can use StatefulSetWorkload to render a StatefulSet on a Kubernetes cluster, like [ContainerizedWorkload](https://github.com/oam-dev/spec/blob/master/core/workloads/containerized_workload/containerized_workload.md).

# Getting started
- At first, you should follow [addon-oam-kubernetes-local](https://github.com/crossplane/addon-oam-kubernetes-local#getting-started). And install OAM Application Controller and OAM Core workload and trait controller.
- Get the project statefulsetworkload to your GOPATH
```
git clone https://github.com/My-pleasure/statefulsetworkload.git
```
- Fetch the statefulsetworkload image
```
docker pull chienwong/statefulsetworkload:v0.5
```
- Deploy the statefulsetworkload controller
```
cd statefulsetworkload

make deploy IMG=statefulsetworkload:v0.5
```
- Apply the sample application config
```
kubectl apply -f config/samples/statefulsetworkload-test.yaml
```
- Verify it you should see a statefulset looking like below
```
kubectl get statefulset
NAME                                     READY   AGE
example-appconfig-statefulset-workload   1/1     13s
```
