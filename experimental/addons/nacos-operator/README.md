# nacos-operator

Nacos is an easy-to-use dynamic service discovery, configuration and service management platform for building cloud native applications. For more visit https://nacos.io/

## Install

Add experimental registry
```
vela addon registry add experimental --type=helm --endpoint=https://addons.kubevela.net/experimental/
```

Enable this addon
```
vela addon enable nacos-operator
```

```shell
$ vela ls -A | grep nacos
vela-system     addon-nacos-operator    ns-nacos-operator                       k8s-objects                                     running healthy
vela-system     └─                      nacos-operator                          helm                                            running healthy Fetch repository successfully, Create helm release
```

Disable this addon
```
vela addon disable nacos-operator
```

## Use nacos-operator

After you enable this addon, create a namespace `prod`:

```shell
$ kubectl create namespace prod
```

Then apply below yaml to create a nacos cluster with two replicas:

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: nacos-cluster-sample
spec:
  components:
    - type: nacos-cluster
      name: nacos-cluster
      properties:
        type: cluster
        image: nacos/nacos-server:1.4.1
        replicas: 2
```

```shell
$ kubectl get po  -n prod  -o wide
NAME              READY   STATUS    RESTARTS   AGE   IP             NODE       NOMINATED NODE   READINESS GATES
nacos-cluster-0   1/1     Running   0          22m   10.244.0.140   minikube   <none>           <none>
nacos-cluster-1   1/1     Running   0          22m   10.244.0.139   minikube   <none>           <none>
```

### Port forward the service

Port forward the service to access the nacos via HTTP requests.

```shell
kubectl port-forward -n prod svc/nacos-cluster-headless 8848:8848
```

### Service & Configuration Management

Follow below sequence of steps from registering of service to publishing & accessing config in nacos.

**Service registration**

```shell
curl -X POST 'http://127.0.0.1:8848/nacos/v1/ns/instance?serviceName=nacos.naming.serviceName&ip=20.18.7.10&port=8080'
```

**Service discovery**

```shell
curl -X GET 'http://127.0.0.1:8848/nacos/v1/ns/instance/list?serviceName=nacos.naming.serviceName'
```

**Publish config**

```shell
curl -X POST "http://127.0.0.1:8848/nacos/v1/cs/configs?dataId=nacos.cfg.dataId&group=test&content=helloWorld"
```

**Get config**

```shell
curl -X GET "http://127.0.0.1:8848/nacos/v1/cs/configs?dataId=nacos.cfg.dataId&group=test"
```

For more visit https://nacos.io/en-us/docs/v2/.