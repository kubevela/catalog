# volcano

Volcano is a cloud native system for high-performance workloads, which has been accepted by Cloud Native Computing Foundation (CNCF) as its first and only official container batch scheduling project. Volcano supports popular computing frameworks such as Spark, TensorFlow, PyTorch, Flink, Argo, MindSpore, and PaddlePaddle. Volcano also supports scheduling of computing resources on different architecture, such as x86, Arm, and Kunpeng.

## Install

Add experimental registry
```
vela addon registry add experimental --type=helm --endpoint=https://addons.kubevela.net/experimental/
```

Enable this addon
```
vela addon enable volcano
```

```shell
$ vela ls -A | grep volcano
vela-system     addon-volcano   ns-volcano-system                       k8s-objects                                     running healthy                 2023-03-11
vela-system     └─              volcano-resources                       k8s-objects                                     running healthy                 2023-03-11
```

Disable this addon
```
vela addon disable volcano
```

## Use volcano

Here is a simple example of how to use Volcano with CRD resources.

**step 1:**

- Apply the below yaml to create a queue named `test`.

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: volcano-queue-sample
spec:
  components:
    - type: volcano-queue
      name: test
      properties:
        weight: 1
        reclaimable: false
        capability:
          cpu: 1
```

**step 2:**

- Apply the below yaml to create a VolcanoJob named `job-1`.

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: volcano-job-sample
spec:
  components:
    - type: volcano-job
      name: job-1
      properties:
        minAvailable: 1
        schedulerName: volcano
        queue: test
        policies:
          - event: PodEvicted
            action: RestartJob
        tasks:
          - replicas: 1
            name: nginx
            policies:
            - event: TaskCompleted
              action: CompleteJob
            template:
              spec:
                containers:
                  - command:
                    - sleep
                    - 10m
                    image: nginx:latest
                    name: nginx
                    resources:
                      requests:
                        cpu: 1
                      limits:
                        cpu: 1
                restartPolicy: Never
```

**step 3:**

- Now, Check the status of custom job and Queue.

```shell
$ kubectl get vcjob -n prod job-1
NAME    STATUS    MINAVAILABLE   RUNNINGS   AGE
job-1   Running   1              1          6m12s

# Now, Check queue status
$ kubectl get queue test -oyaml
apiVersion: scheduling.volcano.sh/v1beta1
kind: Queue
metadata:
  annotations:
    app.oam.dev/last-applied-configuration: >-
      {"apiVersion":"scheduling.volcano.sh/v1beta1","kind":"Queue","metadata":{"annotations":{"app.oam.dev/last-applied-time":"2023-03-11T18:33:54+05:30","oam.dev/kubevela-version":"v1.8.0-alpha.1"},"labels":{"app.oam.dev/app-revision-hash":"8b9252450c24948a","app.oam.dev/appRevision":"volcano-queue-sample-v1","app.oam.dev/cluster":"","app.oam.dev/component":"test","app.oam.dev/name":"volcano-queue-sample","app.oam.dev/namespace":"prod","app.oam.dev/resourceType":"WORKLOAD","app.oam.dev/revision":"","oam.dev/render-hash":"8f25d162409bb498","workload.oam.dev/type":"volcano-queue"},"name":"test"},"spec":{"capability":{"cpu":1},"reclaimable":false,"weight":1}}
    app.oam.dev/last-applied-time: '2023-03-11T18:33:54+05:30'
    oam.dev/kubevela-version: v1.8.0-alpha.1
  creationTimestamp: '2023-03-11T13:03:54Z'
  generation: 1
  labels:
    app.oam.dev/app-revision-hash: 8b9252450c24948a
    app.oam.dev/appRevision: volcano-queue-sample-v1
    app.oam.dev/cluster: ''
    app.oam.dev/component: test
    app.oam.dev/name: volcano-queue-sample
    app.oam.dev/namespace: prod
    app.oam.dev/resourceType: WORKLOAD
    app.oam.dev/revision: ''
    oam.dev/render-hash: 8f25d162409bb498
    workload.oam.dev/type: volcano-queue
  managedFields:
    - apiVersion: scheduling.volcano.sh/v1beta1
      fieldsType: FieldsV1
      fieldsV1:
        f:metadata:
          f:annotations:
            .: {}
            f:app.oam.dev/last-applied-configuration: {}
            f:app.oam.dev/last-applied-time: {}
            f:oam.dev/kubevela-version: {}
          f:labels:
            .: {}
            f:app.oam.dev/app-revision-hash: {}
            f:app.oam.dev/appRevision: {}
            f:app.oam.dev/cluster: {}
            f:app.oam.dev/component: {}
            f:app.oam.dev/name: {}
            f:app.oam.dev/namespace: {}
            f:app.oam.dev/resourceType: {}
            f:app.oam.dev/revision: {}
            f:oam.dev/render-hash: {}
            f:workload.oam.dev/type: {}
        f:spec:
          .: {}
          f:capability:
            .: {}
            f:cpu: {}
          f:reclaimable: {}
          f:weight: {}
      manager: kubevela
      operation: Update
      time: '2023-03-11T13:03:54Z'
    - apiVersion: scheduling.volcano.sh/v1beta1
      fieldsType: FieldsV1
      fieldsV1:
        f:status:
          .: {}
          f:allocated:
            .: {}
            f:cpu: {}
            f:memory: {}
          f:reservation: {}
          f:state: {}
      manager: Go-http-client
      operation: Update
      subresource: status
      time: '2023-03-11T13:06:46Z'
  name: test
  resourceVersion: '875230'
  uid: 6850a334-db4b-4d66-ae2c-acbea1db0849
  selfLink: /apis/scheduling.volcano.sh/v1beta1/queues/test
status:
  allocated:
    cpu: '0'
    memory: '0'
  reservation: {}
  state: Open
spec:
  capability:
    cpu: 1
  reclaimable: false
  weight: 1
```

For more visit on the volcano official website https://volcano.sh/.