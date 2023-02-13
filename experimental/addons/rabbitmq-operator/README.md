# rabbitmq-operator

Kubernetes operator to deploy and manage RabbitMQ clusters for more https://www.rabbitmq.com/.

## Install

Add experimental registry
```
vela addon registry add experimental --type=helm --endpoint=https://addons.kubevela.net/experimental/
```

Enable this addon
```
vela addon enable rabbitmq-operator
```

```shell
$ vela ls -A | grep rabbitmq
vela-system     addon-rabbitmq-operator         ns-rabbitmq-operator                    k8s-objects                                             running         healthy
vela-system     └─                              rabbitmq-operator                       helm                                                    running         healthy Fetch repository successfully, Create helm release
```

Disable this addon
```
vela addon disable rabbitmq-operator
```

## Use
## rabbitmq-operator

After you enable this addon, create a namespace `prod`:

```shell
$ kubectl create namespace prod
```

Then apply this Application yaml to create a rabbitmq cluster:

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: rabbitmq-operator-sample
spec:
  components:
    - type: "rabbitmq-operator"
      name: "rabbitmq"
      properties:
        replicas: 2
```

```shell
$ kubectl get po  -n prod  -o wide
NAME                READY   STATUS    RESTARTS      AGE   IP            NODE       NOMINATED NODE   READINESS GATES
rabbitmq-server-0   1/1     Running   0          2m55s   10.244.0.173   minikube   <none>           <none>
rabbitmq-server-1   1/1     Running   0          2m55s   10.244.0.174   minikube   <none>           <none>
```
