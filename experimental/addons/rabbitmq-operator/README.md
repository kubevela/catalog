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

## Run the operator locally

To connect with management console of Rabbitmq follow the below steps:

- First, Have username and password default set by rabbitmq.

```shell
# For Username
kubectl get secret rabbitmq-default-user -n prod --template={{.data.username}} | base64 --decode
# For Password
kubectl get secret rabbitmq-default-user -n prod --template={{.data.password}} | base64 --decode
```

- Create a new service from existing Cluster-Ip service of Rabbitmq to login

```shell
kubectl expose service -n prod rabbitmq --name=rabbitmq-svc --port=15672 --target-port=15672 --type=NodePort
# Check nodeport
kubectl get svc -n prod
```

Now, Go on http://127.0.0.1:nodeport/ to login in management console.

For documentation, dubugging or configuration visit https://www.rabbitmq.com/.
