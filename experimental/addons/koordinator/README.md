# koordinator

Koordinator is a QoS based scheduling system for hybrid workloads orchestration on Kubernetes. It aims to improve the runtime efficiency and reliability of both latency sensitive workloads and batch jobs, simplify the complexity of resource-related configuration tuning, and increase pod deployment density to improve resource utilizations.

## Install

Add experimental registry
```
vela addon registry add experimental --type=helm --endpoint=https://addons.kubevela.net/experimental/
```

Enable this addon
```
vela addon enable koordinator
```

```shell
$ vela ls -A | grep koordinator
prod            koordinator-reservation-sample  koordinator-reservation                 koordinator-reservation                                 running healthy
vela-system     addon-koordinator               koordinator                             helm                                                    running healthy Fetch repository successfully, Create helm release
```

Disable this addon
```
vela addon disable koordinator
```

## Use
### koordinator

After you enable this addon, create a namespace `prod` with the below YAML:

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: prod
  labels:
    koordinator.sh/enable-colocation: "true"
```

**Note: Make sure created namespace `prod` must have label `koordinator.sh/enable-colocation: "true"` to follow this README**

Then apply the below yaml to create ClusterColocationProfile:

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: colocation-profile-sample
spec:
  components:
    - type: "koordinator-colocation-profile"
      name: "koordinator-colocation-profile"
      properties:
        namespaceSelector:
            matchLabels:
              koordinator.sh/enable-colocation: "true"
        selector:
            matchLabels:
              koordinator.sh/enable-colocation: "true"
        qosClass: BE
        priorityClassName: koord-batch
        koordinatorPriority: 1000
        schedulerName: koord-scheduler
        labels:
            koordinator.sh/mutated: "true"
        annotations: 
            koordinator.sh/intercepted: "true"
        patch:
            spec:
                terminationGracePeriodSeconds: 30
```

```shell
$ kubectl get ClusterColocationProfile  -n prod
NAME                             AGE
koordinator-colocation-profile   9m52s
```

### Verify ClusterColocationProfile works

Create this pod and now you will find it's injected with Koordinator QoS, Koordinator Priority etc:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-pod
  namespace: prod
  labels:
    koordinator.sh/enable-colocation: "true"
spec:
  containers:
  - name: app
    image: nginx:1.15.1"
```

Check injected pod with Koordinator QoS, Koordinator Priority etc:

```shell
$ kubectl get pod test-pod -n prod -o yaml
apiVersion: v1
kind: Pod
metadata:
  annotations:
    koordinator.sh/intercepted: true
  labels:
    koordinator.sh/qosClass: BE
    koordinator.sh/priority: 1000
    koordinator.sh/mutated: true
  ...
spec:
  terminationGracePeriodSeconds: 30
  priority: 5000
  priorityClassName: koord-batch
  schedulerName: koord-scheduler
  containers:
  - name: app
    image: nginx:1.15.1
    ...
...
```

### Fine-grained CPU Orchestration

Fine-grained CPU Orchestration is an ability of koord-scheduler for improving the performance of CPU-sensitive workloads.

Fine-grained CPU orchestration is Enabled by default. You can use it without any modification on the koord-scheduler config.

For users who need deep insight, please visit https://koordinator.sh/docs/user-manuals/fine-grained-cpu-orchestration/#global-configuration-via-plugin-args

**Use Fine-grained CPU Orchestration**

- Create an `nginx` deployment with the YAML file below.

  Fine-grained CPU Orchestration allows pods to bind CPUs exclusively. To use fine-grained CPU orchestration, pods should set a label of QoS Class and specify the cpu binding policy.

  ```yaml
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: nginx-lsr
    namespace: prod
    labels:
      app: nginx-lsr
  spec:
    replicas: 3
    selector:
      matchLabels:
        app: nginx-lsr
    template:
      metadata:
        name: nginx-lsr
        labels:
          app: nginx-lsr
          koordinator.sh/qosClass: LSR # set the QoS class as LSR, the binding policy is FullPCPUs by default
          # in v0.5, binding policy should be specified.
          # e.g. to set binding policy as FullPCPUs (prefer allocating full physical CPUs of the same core):
          #annotations:
            #scheduling.koordinator.sh/resource-spec: '{"preferredCPUBindPolicy": "FullPCPUs"}'
      spec:
        schedulerName: koord-scheduler # use the koord-scheduler
        containers:
        - name: nginx
          image: nginx
          resources:
            limits:
              cpu: '2'
              memory: '1G'
            requests:
              cpu: '2'
              memory: '1G'
        priorityClassName: koord-prod
  ```

- Deploy the nginx deployment and check the scheduling result.

  ```shell
  $ kubectl create -f nginx-deployment.yaml
  deployment/nginx-lsr created
  $ kubectl get -n prod pods -o wide | grep nginx
  nginx-lsr-59cf487d4b-jwwjv   1/1     Running   0       21s     172.20.101.35    node-0   <none>         <none>
  nginx-lsr-59cf487d4b-4l7r4   1/1     Running   0       21s     172.20.101.79    node-1   <none>         <none>
  nginx-lsr-59cf487d4b-nrb7f   1/1     Running   0       21s     172.20.106.119   node-2   <none>         <none>
  ```

- Check the CPU binding results of pods on `scheduling.koordinator.sh/resource-status` annotations.

  ```shell
  $ kubectl get pod -n prod nginx-lsr-59cf487d4b-jwwjv -o jsonpath='{.metadata.annotations.scheduling\.koordinator\.sh/resource-status}'
  {"cpuset":"2,54"}
  ```

  We can see that the pod `nginx-lsr-59cf487d4b-jwwjv` binds 2 CPUs, and the IDs are 2,54, which are the logical processors of the same core, But could be illogical for other processors.

- So change the binding policy in the nginx deployment with the YAML file below.

  ```yaml
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: nginx-lsr
    labels:
      app: nginx-lsr
  spec:
    replicas: 3
    selector:
      matchLabels:
        app: nginx-lsr
    template:
      metadata:
        name: nginx-lsr
        labels:
          app: nginx-lsr
          koordinator.sh/qosClass: LSR # set the QoS class as LSR
        annotations:
          # set binding policy as SpreadByPCPUs (prefer allocating physical CPUs of different cores)
          scheduling.koordinator.sh/resource-spec: '{"preferredCPUBindPolicy": "SpreadByPCPUs"}'
      spec:
        schedulerName: koord-scheduler # use the koord-scheduler
        containers:
        - name: nginx
          image: nginx
          resources:
            limits:
              cpu: '2'
            requests:
              cpu: '2'
        priorityClassName: koord-prod
  ```

- Update the `nginx` deployment and check the scheduling result.

  ```shell
  $ kubectl apply -f nginx-deployment.yaml
  deployment/nginx-lsr created
  $ kubectl get pods -n prod -o wide | grep nginx
  nginx-lsr-7fcbcf89b4-rkrgg   1/1     Running   0       49s     172.20.101.35    node-0   <none>         <none>
  nginx-lsr-7fcbcf89b4-ndbks   1/1     Running   0       49s     172.20.101.79    node-1   <none>         <none>
  nginx-lsr-7fcbcf89b4-9v8b8   1/1     Running   0       49s     172.20.106.119   node-2   <none>         <none>
  ```

- Check the new CPU binding results of pods on `scheduling.koordinator.sh/resource-status` annotations.

  ```shell
  $ kubectl get pod nginx-lsr-7fcbcf89b4-rkrgg -o jsonpath='{.metadata.annotations.scheduling\.koordinator\.sh/resource-status}'
  {"cpuset":"2-3"}
  ```

  Now we can see that the pod `nginx-lsr-59cf487d4b-jwwjv` binds 2 CPUs, and the IDs are 2,3, which are the logical processors of the different core.

For more visit to https://koordinator.sh/.
