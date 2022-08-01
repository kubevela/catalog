# flink-kubernetes-operator

A Kubernetes operator for Apache Flink(https://github.com/apache/flink-kubernetes-operator), it allows users to manage Flink applications and their lifecycle through native k8s tooling like kubectl.

## Install

```shell
# The following steps are for enabling fluxcd and flink-kubernetes-operator in namespace called flink
# vela will support the ns setup for addon enable or disable in the future version

#Install the certificate manager on your Kubernetes cluster to enable adding the webhook component 
#(only needed once per Kubernetes cluster):
#The cert-manager can also install with pure k8s-object like this:
#kubectl create -f https://github.com/jetstack/cert-manager/releases/download/v1.7.1/cert-manager.yaml

vela addon enable fluxcd
vela addon enable cert-manager
vela addon enable flink-kubernetes-operator
```

## Uninstall

```shell
# set the DEFAULT_VELA_NS for disabling addons
vela addon disable flink-kubernetes-operator
vela addon disable cert-manager
vela addon disable fluxcd
```

## To check the flink-kubernetes-operator running status

- Firstly, check the flink-kubernetes-operator (and the fluxcd and cert-manager we need to deploy by helm) running status
```shell
vela ls -A | grep cert-
vela-system     addon-cert-manager              vela-system           helm                            running healthy Fetch repository successfully, Create helm release            2022-07-30 17:14:35 +0800 CST
vela ls -A | grep flink
vela-system     addon-flink-kubernetes-operator flink-namespace         raw                             running healthy                                                               2022-07-30 17:36:36 +0800 CST
vela-system     └─                              vela-system          helm                            running healthy Fetch repository successfully, Create helm release            2022-07-30 17:36:36 +0800 CST


```

- Secondly, show the component type flink-cluster, so we know how to use it in one application
   - As a flink user, you can choose the parameter to set for your flink cluster
```shell
vela show flink-cluster
# Specification
+--------------+------------------------------------------------------------------------------------------------------+--------+----------+---------+
|     NAME     |                                             DESCRIPTION                                              |  TYPE  | REQUIRED | DEFAULT |
+--------------+------------------------------------------------------------------------------------------------------+--------+----------+---------+
| name         | Specify the flink cluster name.                                                                      | string | true     |         |
| namespace    | Specify the namespace for flink cluster to install.                                                  | string | true     |         |
| nots         | Specify the taskmanager.numberOfTaskSlots, e.g "2".                                                  | string | true     |         |
| flinkVersion | Specify the flink cluster version, e.g "v1_14".                                                      | string | true     |         |
| image        | Specify the image for flink cluster to run, e.g "flink:latest".                                      | string | true     |         |
| jarURI       | Specify the uri for the jar of the flink cluster job, e.g                                            | string | true     |         |
|              | "local:///opt/flink/examples/streaming/StateMachineExample.jar".                                     |        |          |         |
| parallelism  | Specify the parallelism of the flink cluster job, e.g 2.                                             | int    | true     |         |
| upgradeMode  | Specify the upgradeMode of the flink cluster job, e.g "stateless".                                   | string | true     |         |
| replicas     | Specify the replicas of the flink cluster jobManager, e.g 1.                                         | int    | true     |         |
| jmcpu        | Specify the cpu of the flink cluster jobManager, e.g 1.                                              | int    | true     |         |
| jmmem        | Specify the memory of the flink cluster jobManager, e.g "1024m".                                     | string | true     |         |
| tmcpu        | Specify the cpu of the flink cluster taskManager, e.g 1.                                             | int    | true     |         |
| tmmem        | Specify the memory of the flink cluster taskManager, e.g "1024m".                                    | string | true     |         |
+--------------+------------------------------------------------------------------------------------------------------+--------+----------+---------+

```

## Example for how to run a component typed flink-cluster in application
- Firstly, new a namespace
```shell
kubectl create ns flink-cluster
```
- Secondly, copy the following example to "flink-app-v1.yaml"
```shell
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: flink-app-v1
  namespace: vela-system
spec:
  components:
  - name: my-flink-component
    type: flink-cluster
    properties:
      name: my-flink-cluster
      namespace: flink-cluster
      nots: '2'
      flinkVersion: v1_14
      image: flink:latest
      jarURI: local:///opt/flink/examples/streaming/StateMachineExample.jar
      parallelism: 2
      upgradeMode:  stateless
      replicas: 1
      jmcpu: 1
      jmmem: 1024m
      tmcpu: 1
      tmmem: 1024m

```
- Thirdly, use "vela up -f flink-app-v1.yaml" to publish
```shell
vela up -f flink-app-v1.yaml
```

- Fourthly, check the flink cluster
```shell
vela ls  -n vela-system | grep app
flink-app-v1                    my-flink-component      flink-cluster                   running healthy                                                               2022-07-30 18:53:34 +0800 CST


```

- The last, accesss the flink cluster by website using http://localhost:8888
```shell
kubectl get svc -n flink-cluster | grep rest
my-flink-cluster-rest   ClusterIP   192.168.149.175   <none>        8081/TCP            17m


kubectl port-forward service/my-flink-cluster-rest 8888:8081 -n flink-cluster
Forwarding from 127.0.0.1:8888 -> 8081


```

