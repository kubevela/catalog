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

After you enable this addon, create a namespace `prod`:

```shell
$ kubectl create namespace prod
```

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
  labels:
    koordinator.sh/enable-colocation: "true"
  name: test-pod
spec:
  containers:
  - name: app
    image: nginx:1.15.1"
```

Check injected pod with Koordinator QoS, Koordinator Priority etc:

```shell
$ kubectl get pod test-pod -o yaml
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

For more visit to https://koordinator.sh/.
