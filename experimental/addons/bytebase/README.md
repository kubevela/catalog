# bytebase

Bytebase is an open-source database DevOps tool, it's the GitLab for managing databases throughout the application development lifecycle. It offers a web-based workspace for DBAs and Developers to collaborate and manage the database change safely and efficiently.

## Install

Add experimental registry
```
vela addon registry add experimental --type=helm --endpoint=https://addons.kubevela.net/experimental/
```

Enable this addon
```
vela addon enable bytebase
```

```shell
$ vela ls -A | grep bytebase
vela-system     addon-bytebase  ns-bytebase                             k8s-objects                                     running  healthy
vela-system     ├─              bytebase                                helm                                            running  healthy       Fetch repository successfully, Create helm release
vela-system     └─              svc-bytebase                            k8s-objects                                     running  healthy
```

Disable this addon
```
vela addon disable bytebase
```

## Use bytebase

Verify Pods of the bytebase running or not.

```shell
$ kubectl get po  -n prod  -o wide
NAME         READY   STATUS    RESTARTS   AGE   IP             NODE       NOMINATED NODE   READINESS GATES
bytebase-0   1/1     Running   0          27m   10.244.3.148   minikube   <none>           <none>
```

### Run the bytebase UI locally

There is a NodePort service running in the namespace `bytebase`, So if you are using minikube follow the below steps to access UI

```shell
$ kubectl get svc -n bytebase
NAME                           TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
bytebase-entrypoint            LoadBalancer   10.96.143.226   <pending>     443:31537/TCP    40m
bytebase-nodeport-entrypoint   NodePort       10.104.52.56    <none>        8080:32363/TCP   80m

# Get url to access UI
$ minikube service -n bytebase --url bytebase-nodeport-entrypoint
http://192.168.49.2:32363
```

Visit on the obtained URL to access bytebase UI.

To know more about bytebase visit https://www.bytebase.com/docs/.