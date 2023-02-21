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

### Access The Management UI

Next, let's access the Management UI.

- First, Have username and password default set by rabbitmq.

```shell
# For Username
$ username="$(kubectl get secret rabbitmq-default-user -n prod -o jsonpath='{.data.username}' | base64 --decode)"
$ echo "username: $username"
# For Password
$ password="$(kubectl get secret rabbitmq-default-user -n prod -o jsonpath='{.data.password}' | base64 --decode)"
$ echo "password: $password"
```

- Create a new NodePort service from existing Cluster-Ip service of Rabbitmq to login

```shell
$ kubectl expose service -n prod rabbitmq --name=rabbitmq-svc --port=15672 --target-port=15672 --type=NodePort
# Check nodeport
$ nodeport="$(kubectl get svc rabbitmq-svc -n prod -o jsonpath='{.spec.ports[0].nodePort}')"
$ echo "nodeport: $nodeport"
# Run, If you're using minikube
$ minikube service rabbitmq-svc -n prod
```

Now, Open localhost:15672 in the browser and see the Management UI. The credentials are as printed in the commands above. Alternatively, you can run a curl command to verify access:

```shell
$ curl -u$username:$password localhost:15672/api/overview
{"management_version":"3.8.9","rates_mode":"basic", ...}
```

### Connect An Application To The Cluster

The next step would be to connect an application to the RabbitMQ Cluster in order to use its messaging capabilities. The perf-test application is frequently used within the RabbitMQ community for load testing RabbitMQ Clusters.

Here, we will be using the `rabbitmq` service to find the connection address, and the `rabbitmq-default-user` secret to find connection credentials.

```shell
$ username="$(kubectl get secret rabbitmq-default-user -n prod -o jsonpath='{.data.username}' | base64 --decode)"
$ password="$(kubectl get secret rabbitmq-default-user -n prod -o jsonpath='{.data.password}' | base64 --decode)"
$ service="$(kubectl get service rabbitmq -n prod -o jsonpath='{.spec.clusterIP}')"
$ kubectl run -n prod perf-test --image=pivotalrabbitmq/perf-test -- --uri amqp://$username:$password@$service
```

We can now view the perf-test logs by running:

```shell
$ kubectl logs --follow perf-test
...
id: test-091358-453, time 179.000 s, sent: 28414 msg/s, received: 41854 msg/s, min/median/75th/95th/99th consumer latency: 1216994/1422871/1497904/1599079/1639804 µs
id: test-091358-453, time 180.000 s, sent: 46588 msg/s, received: 46452 msg/s, min/median/75th/95th/99th consumer latency: 1279743/1500840/1582015/1653522/1670623 µs
id: test-091358-453, time 181.000 s, sent: 58617 msg/s, received: 47680 msg/s, min/median/75th/95th/99th consumer latency: 1109417/1292603/1390255/1499449/1549674 µs
id: test-091358-453, time 182.000 s, sent: 43870 msg/s, received: 43945 msg/s, min/median/75th/95th/99th consumer latency: 1232016/1398920/1461345/1549776/1576026 µs
id: test-091358-453, time 183.000 s, sent: 46497 msg/s, received: 49503 msg/s, min/median/75th/95th/99th consumer latency: 1187173/1387125/1464131/1558092/1589045 µs
id: test-091358-453, time 184.000 s, sent: 47096 msg/s, received: 42800 msg/s, min/median/75th/95th/99th consumer latency: 1147471/1377476/1442525/1513697/1556645 µs
id: test-091358-453, time 185.000 s, sent: 43268 msg/s, received: 51552 msg/s, min/median/75th/95th/99th consumer latency: 1071535/1334735/1429098/1514509/1541408 µs
...
```

### Next Steps

Now that you are up and running with the basics, you can explore what the Cluster Operator can do for you!

You can do so by:

- Looking at more examples https://github.com/rabbitmq/cluster-operator/tree/main/docs/examples/ such as monitoring the deployed RabbitMQ Cluster using Prometheus,    enabling TLS, etc https://www.rabbitmq.com/prometheus.html.
- Looking at the API reference documentation.
- Checking out our GitHub repository and contributing to this guide, other docs, and the codebase!
