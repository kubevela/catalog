# solr-operator

This is an addon template. Check how to build your own addon: https://kubevela.net/docs/platform-engineers/addon/intro

## Install

Add experimental registry
```
vela addon registry add experimental --type=helm --endpoint=https://addons.kubevela.net/experimental/
```

Enable this addon
```
vela addon enable solr-operator
```

```shell
$ vela ls -A | grep solr
vela-system     addon-solr-operator        ns-solr-operator                   k8s-objects                                     running         healthy
vela-system     └─                              solr-operator                      helm                                            running         healthy Fetch repository successfully, Create helm release
```

Disable this addon
```
vela addon disable solr-operator
```

## Use
## solr-operator

After you enable this addon, create a namespace `prod`:

```shell
$ kubectl create namespace prod
```

Then apply this Application yaml to create a solr cluster:

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: solr-operator-sample
spec:
  components:
    - type: "solr-cloud"
      name: "solr"
      properties:
        replicas: 3
```

```shell
$ kubectl get po  -n prod  -o wide
NAME          READY   STATUS    RESTARTS      AGE   IP            NODE       NOMINATED NODE   READINESS GATES
solr-0   1/1     Running   0             81s   10.244.0.57   minikube   <none>           <none>
solr-1   1/1     Running   2 (67s ago)   69s   10.244.0.58   minikube   <none>           <none>
solr-2   1/1     Running   0             25s   10.244.0.59   minikube   <none>           <none>
```

## Run the operator locally

For debugging and development you might want to access the Solr cluster directly. For example, if you created the cluster with name solr, you can forward the Solr port from any of the pods (e.g. solr-0) as follows:

```shell
kubectl port-forward -n prod solr-0 8983:solr-client
```
