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

kubectl create ns flink
declare -x DEFAULT_VELA_NS=flink
vela addon enable fluxcd
vela addon enable cert-manager
vela addon enable flink-kubernetes-operator
# set back to the DEFAULT_VELA_NS
declare -x DEFAULT_VELA_NS=vela-system
```

## Uninstall

```shell
# set the DEFAULT_VELA_NS for disabling addons
declare -x DEFAULT_VELA_NS=flink
vela addon disable flink-kubernetes-operator
vela addon disable cert-manager
vela addon disable fluxcd
# set back to the DEFAULT_VELA_NS
declare -x DEFAULT_VELA_NS=vela-system
# kubectl delete -f https://github.com/jetstack/cert-manager/releases/download/v1.7.1/cert-manager.yaml
kubectl delete ns flink
```

## To check the flink-kubernetes-operator running status

- Firstly, check the flink-kubernetes-operator (and the fluxcd and cert-manager we need to deploy by helm) running status
```shell
kubectl get application -n flink
NAME                              COMPONENT               TYPE   PHASE     HEALTHY   STATUS                                                            AGE
addon-cert-manager                cert-manager            helm   running   true      Fetch repository successfully, Create helm release successfully   25m
addon-flink-kubernetes-operator   flink-operator          helm   running   true      Fetch repository successfully, Create helm release successfully   22m
addon-fluxcd                      flux-system-namespace   raw    running   true                                                                       26h
```

- Secondly, check the cert-manager running status
```shell
kubectl get deploy -n flink | grep cert-manager
NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
cert-manager              1/1     1            1           2d22h
cert-manager-cainjector   1/1     1            1           2d22h
cert-manager-webhook      1/1     1            1           2d22h
```

```shell
kubectl get deploy  -n flink | grep flink
NAME                        READY   UP-TO-DATE   AVAILABLE   AGE
flink-kubernetes-operator   1/1     1            1           6h19m 
```

```shell
kubectl get pod   -n flink | grep flink
NAME                                        READY   STATUS    RESTARTS   AGE
flink-kubernetes-operator-9f5546947-2j7x4   2/2     Running   0          6h19m
```

```shell
kubectl logs  flink-kubernetes-operator-9f5546947-2j7x4   -n flink
Starting Operator
WARNING: sun.reflect.Reflection.getCallerClass is not supported. This will impact performance.
ESC[33m2022-04-22 03:29:28,138ESC[m ESC[36mo.a.f.c.GlobalConfiguration   ESC[m ESC[32m[INFO ] Loading configuration property: metrics.reporter.slf4j.factory.class, org.apache.flink.metrics.slf4j.Slf4jReporterFactory
ESC[mESC[33m2022-04-22 03:29:28,142ESC[m ESC[36mo.a.f.c.GlobalConfiguration   ESC[m ESC[32m[INFO ] Loading configuration property: metrics.reporter.slf4j.interval, 5 MINUTE
ESC[mESC[33m2022-04-22 03:29:28,142ESC[m ESC[36mo.a.f.c.GlobalConfiguration   ESC[m ESC[32m[INFO ] Loading configuration property: operator.reconciler.reschedule.interval, 15 s
ESC[mESC[33m2022-04-22 03:29:28,142ESC[m ESC[36mo.a.f.c.GlobalConfiguration   ESC[m ESC[32m[INFO ] Loading configuration property: operator.observer.progress-check.interval, 5 s
ESC[mESC[33m2022-04-22 03:29:28,152ESC[m ESC[36mo.a.f.c.GlobalConfiguration   ESC[m ESC[32m[INFO ] Loading configuration property: taskmanager.numberOfTaskSlots, 2
ESC[mESC[33m2022-04-22 03:29:28,152ESC[m ESC[36mo.a.f.c.GlobalConfiguration   ESC[m ESC[32m[INFO ] Loading configuration property: blob.server.port, 6124
ESC[mESC[33m2022-04-22 03:29:28,152ESC[m ESC[36mo.a.f.c.GlobalConfiguration   ESC[m ESC[32m[INFO ] Loading configuration property: jobmanager.rpc.port, 6123
ESC[mESC[33m2022-04-22 03:29:28,152ESC[m ESC[36mo.a.f.c.GlobalConfiguration   ESC[m ESC[32m[INFO ] Loading configuration property: taskmanager.rpc.port, 6122
ESC[mESC[33m2022-04-22 03:29:28,152ESC[m ESC[36mo.a.f.c.GlobalConfiguration   ESC[m ESC[32m[INFO ] Loading configuration property: queryable-state.proxy.ports, 6125
ESC[mESC[33m2022-04-22 03:29:28,153ESC[m ESC[36mo.a.f.c.GlobalConfiguration   ESC[m ESC[32m[INFO ] Loading configuration property: jobmanager.memory.process.size, 1600m
ESC[mESC[33m2022-04-22 03:29:28,153ESC[m ESC[36mo.a.f.c.GlobalConfiguration   ESC[m ESC[32m[INFO ] Loading configuration property: taskmanager.memory.process.size, 1728m
ESC[mESC[33m2022-04-22 03:29:28,153ESC[m ESC[36mo.a.f.c.GlobalConfiguration   ESC[m ESC[32m[INFO ] Loading configuration property: parallelism.default, 2
ESC[mESC[33m2022-04-22 03:29:28,154ESC[m ESC[36mo.a.f.k.o.FlinkOperator       ESC[m ESC[32m[INFO ] Starting Flink Kubernetes Operator
ESC[mESC[33m2022-04-22 03:29:28,297ESC[m ESC[36mo.a.f.r.m.MetricRegistryImpl  ESC[m ESC[32m[INFO ] Periodically reporting metrics in intervals of 5 min for reporter slf4j of type org.apache.flink.metrics.slf4j.Slf4jReporter.
ESC[mESC[33m2022-04-22 03:29:28,920ESC[m ESC[36mo.a.f.k.o.FlinkOperator       ESC[m ESC[32m[INFO ] Configuring operator with 5 reconciliation threads.
ESC[mESC[33m2022-04-22 03:29:28,958ESC[m ESC[36mi.j.o.Operator                ESC[m ESC[32m[INFO ] Registered reconciler: 'flinkdeploymentcontroller' for resource: 'class org.apache.flink.kubernetes.operator.crd.FlinkDeployment' for namespace(s): [all namespaces]
ESC[mESC[33m2022-04-22 03:29:28,960ESC[m ESC[36mi.j.o.Operator                ESC[m ESC[32m[INFO ] Operator SDK 2.1.2 (commit: a3a81ef) built on 2022-03-15T09:59:42.000+0000 starting...
ESC[mESC[33m2022-04-22 03:29:28,960ESC[m ESC[36mi.j.o.Operator                ESC[m ESC[32m[INFO ] Client version: 5.12.1
ESC[mESC[33m2022-04-22 03:29:29,088ESC[m ESC[36mi.f.k.c.i.VersionUsageUtils   ESC[m ESC[33m[WARN ] The client is using resource type 'flinkdeployments' with unstable version 'v1alpha1'
ESC[mESC[33m2022-04-22 03:34:28,307ESC[m ESC[36mo.a.f.m.s.Slf4jReporter       ESC[m ESC[32m[INFO ]
```

- Thirdly, show the component type flink-cluster, so we know how to use it in one application
   - As a flink user, you can choose the parameter to set for your flink cluster
```shell
vela show flink-cluster
# Properties
+--------------+-------------+--------+----------+---------------------------------------------------------------+
|     NAME     | DESCRIPTION |  TYPE  | REQUIRED |                            DEFAULT                            |
+--------------+-------------+--------+----------+---------------------------------------------------------------+
| name         |             | string | true     |                                                               |
| namespace    |             | string | true     |                                                               |
| nots         |             | string | true     |                                                             2 |
| flinkVersion |             | string | true     | v1_14                                                         |
| image        |             | string | true     | flink:latest                                                  |
| jarURI       |             | string | true     | local:///opt/flink/examples/streaming/StateMachineExample.jar |
| parallelism  |             | int    | true     |                                                             2 |
| upgradeMode  |             | string | true     | stateless                                                     |
| replicas     |             | int    | true     |                                                             1 |
| jmcpu        |             | int    | true     |                                                             1 |
| jmmem        |             | string | true     | 1024m                                                         |
| tmcpu        |             | int    | true     |                                                             1 |
| tmmem        |             | string | true     | 1024m                                                         |
+--------------+-------------+--------+----------+---------------------------------------------------------------+
```

## Example for how to run a component typed flink-cluster in application
- Firstly, new a namespace
```shell
kubectl create ns flink-home
```
- Secondly, copy the following example to "flink-app-v1.yaml"
```shell
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
name: flink-app-v1
namespace: my-project
spec:
components:
  - name: my-flink-component
  type: flink-cluster
  properties:
  name: my-flink-cluster
  namespace: flink-home
```
- Thirdly, use "vela up -f flink-app-v1.yaml" to publish
```shell
vela up -f flink-app-v1.yaml
```

- Fourthly, check all the related resources
```shell
vela status flink-app-v1 -n my-project
About:

Name:         flink-app-v1
Namespace:    my-project
Created at:   2022-04-22 17:33:51 +0800 CST
Status:       running

Workflow:

mode: DAG
finished: true
Suspend: false
Terminated: false
Steps
- id:n6na24x6dr
  name:my-flink-component
  type:apply-component
  phase:succeeded
  message:

Services:

- Name: my-flink-component
  Cluster: local  Namespace: my-project
  Type: flink-cluster
  Healthy
  No trait applied
```

```shell
kubectl get flinkdeployments -n flink-home
NAME               AGE
my-flink-cluster   2m36s
```

```shell
kubectl get deploy   -n flink-home
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
my-flink-cluster   1/1     1            1           5m28s
```

```shell
kubectl get pod    -n flink-home
NAME                                READY   STATUS    RESTARTS   AGE
my-flink-cluster-6bc5c45487-xmjrv   1/1     Running   0          5m36s
my-flink-cluster-taskmanager-1-1    1/1     Running   0          5m24s
```

- Fifthly, check the flink cluster taskmanager logs
```shell
kubectl logs my-flink-cluster-taskmanager-1-1   -n flink-home
2022-04-22 09:39:28,190 INFO  org.apache.flink.runtime.state.heap.HeapKeyedStateBackend    [] - Initializing heap keyed state backend with stream factory.
2022-04-22 09:39:28,190 INFO  org.apache.flink.runtime.state.heap.HeapKeyedStateBackend    [] - Initializing heap keyed state backend with stream factory.
2022-04-22 09:39:28,379 INFO  org.apache.flink.runtime.taskmanager.Task                    [] - Flat Map -> Sink: Print to Std. Out (1/2)#1 (194ab4f8b6ee3f4c4e9451969a1427cb) switched from INITIALIZING to RUNNING.
2022-04-22 09:39:28,375 INFO  org.apache.flink.runtime.taskmanager.Task                    [] - Flat Map -> Sink: Print to Std. Out (2/2)#1 (d4658ec698ee73018d401fc2611f3a39) switched from INITIALIZING to RUNNING.
```
- The last, check the flink cluster taskmanager logs
```shell
kubectl logs my-flink-cluster-6bc5c45487-xmjrv   -n flink-home
2022-04-22 09:44:34,204 INFO  org.apache.flink.runtime.checkpoint.CheckpointCoordinator    [] - Triggering checkpoint 153 (type=CHECKPOINT) @ 1650620674204 for job 0406090c0104896a06b51d70a1886a1f.
2022-04-22 09:44:34,209 INFO  org.apache.flink.runtime.checkpoint.CheckpointCoordinator    [] - Completed checkpoint 153 for job 0406090c0104896a06b51d70a1886a1f (15072 bytes, checkpointDuration=5 ms, finalizationTime=0 ms).
2022-04-22 09:44:36,204 INFO  org.apache.flink.runtime.checkpoint.CheckpointCoordinator    [] - Triggering checkpoint 154 (type=CHECKPOINT) @ 1650620676204 for job 0406090c0104896a06b51d70a1886a1f.
2022-04-22 09:44:36,210 INFO  org.apache.flink.runtime.checkpoint.CheckpointCoordinator    [] - Completed checkpoint 154 for job 0406090c0104896a06b51d70a1886a1f (15603 bytes, checkpointDuration=5 ms, finalizationTime=1 ms).
```

