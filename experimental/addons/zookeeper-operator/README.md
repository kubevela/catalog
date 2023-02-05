# zookeeper-operator

This is an addon template. Check how to build your own addon: https://kubevela.net/docs/platform-engineers/addon/intro

## Install

Add experimental registry
```
vela addon registry add experimental --type=helm --endpoint=https://addons.kubevela.net/experimental/
```

Enable this addon
```
vela addon enable zookeeper-operator
```

```shell
$ vela ls -A | grep zookeeper
vela-system     addon-zookeeper-operator        ns-zookeeper-operator                   k8s-objects                                     running         healthy
vela-system     └─                              zookeeper-operator                      helm                                            running         healthy Fetch repository successfully, Create helm release
```

Disable this addon
```
vela addon disable zookeeper-operator
```

## Use
## zookeeper-operator

After you enable this addon, create a namespace `prod`:

```shell
$ kubectl create namespace prod
```

Then apply this Application yaml to create a zookeeper cluster:

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: zookeeper-operator-sample
spec:
  components:
    - type: "zookeeper-cluster"
      name: "zookeeper"
      properties:
        replicas: 3
```

```shell
$ kubectl get po  -n prod  -o wide
NAME          READY   STATUS    RESTARTS      AGE   IP            NODE       NOMINATED NODE   READINESS GATES
zookeeper-0   1/1     Running   0             81s   10.244.0.57   minikube   <none>           <none>
zookeeper-1   1/1     Running   2 (67s ago)   69s   10.244.0.58   minikube   <none>           <none>
zookeeper-2   1/1     Running   0             25s   10.244.0.59   minikube   <none>           <none>
```

## Run the operator locally

For debugging and development you might want to access the Zookeeper cluster directly. For example, if you created the cluster with name zookeeper, you can forward the Zookeeper port from any of the pods (e.g. zookeeper-0) as follows:

```shell
kubectl port-forward -n prod zookeeper-0 2181:2181
```
