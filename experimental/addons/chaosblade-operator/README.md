
# Chaosblade-operator: A Chaos Engineering Tool for Cloud-native

[Chaosblade-operator](https://github.com/chaosblade-io/chaosblade-operator) chaosblade operator for kubernetes experiments
                                  

This addon based on the [Chaosblade-operator](https://github.com/chaosblade-io/chaosblade-operator). The addon itself will deploy chaosblade-operator for every application.


## Install

Add experimental registry
```
vela addon registry add experimental --type=helm --endpoint=https://addons.kubevela.net/experimental/
```

Enable this addon
```
vela addon enable chaosblade-operator
```

Disable this addon
```
vela addon disable chaosblade-operator
```

## Use
```shell
$ vela ls -A | grep chaos
vela-system     addon-chaosblade-operator       blade-ns                k8s-objects             running healthy                                                               2022-09-14 13:50:16 +0800 CST

$ kubectl get po -A | grep chaos
blade                          chaosblade-operator-b6f48fdbc-m9ff9                 1/1     Running            0                 3m52s
blade                          chaosblade-tool-sq7pj                               1/1     Running            0                 3m52s
```

```shell
Please access addon-chaosblade-operator from the following endpoints:low (timeout 0/600 seconds)...
+---------+------------+-----------------------------------------+-----------------------------------------+-------+
| CLUSTER | COMPONENT  |        REF(KIND/NAMESPACE/NAME)         |                ENDPOINT                 | INNER |
+---------+------------+-----------------------------------------+-----------------------------------------+-------+
| local   | blade-helm | Service/blade/chaosblade-webhook-server | https://chaosblade-webhook-server.blade | true  |
+---------+------------+-----------------------------------------+-----------------------------------------+-------+

```

```shell
cat <<EOF | kubectl up -f -
apiVersion: chaosblade.io/v1alpha1
kind: ChaosBlade
metadata:
  name: delete-pod-by-names
spec:
  experiments:
  - scope: pod
    target: pod
    action: delete
    desc: "delete pod by names"
    matchers:
    - name: names
      value:
      - "kubevela-vela-core-8699fb6d68-mrfvv"
    - name: namespace
      value:
      - "vela-system"
EOF

$ kubectl get blade delete-pod-by-names  -o json
{
    "apiVersion": "chaosblade.io/v1alpha1",
    "kind": "ChaosBlade",
    "metadata": {
        "annotations": {
            "kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"chaosblade.io/v1alpha1\",\"kind\":\"ChaosBlade\",\"metadata\":{\"annotations\":{},\"name\":\"delete-pod-by-names\"},\"spec\":{\"experiments\":[{\"action\":\"delete\",\"desc\":\"delete pod by names\",\"matchers\":[{\"name\":\"names\",\"value\":[\"kubevela-vela-core-8699fb6d68-mrfvv\"]},{\"name\":\"namespace\",\"value\":[\"vela-system\"]}],\"scope\":\"pod\",\"target\":\"pod\"}]}}\n"
        },
        "creationTimestamp": "2022-09-12T11:52:44Z",
        "finalizers": [
            "finalizer.chaosblade.io"
        ],
        "generation": 1,
        "name": "delete-pod-by-names",
        "resourceVersion": "17742294",
        "uid": "ea4075cc-26a5-44ce-b20c-47b562975d84"
    },
    "spec": {
        "experiments": [
            {
                "action": "delete",
                "desc": "delete pod by names",
                "matchers": [
                    {
                        "name": "names",
                        "value": [
                            "kubevela-vela-core-8699fb6d68-mrfvv"
                        ]
                    },
                    {
                        "name": "namespace",
                        "value": [
                            "vela-system"
                        ]
                    }
                ],
                "scope": "pod",
                "target": "pod"
            }
        ]
    },
    "status": {
        "expStatuses": [
            {
                "action": "delete",
                "resStatuses": [
                    {
                        "identifier": "vela-system/cn-chengdu.10.0.0.195/kubevela-vela-core-8699fb6d68-mrfvv",
                        "kind": "pod",
                        "state": "Success",
                        "success": true
                    }
                ],
                "scope": "pod",
                "state": "Success",
                "success": true,
                "target": "pod"
            }
        ],
        "phase": "Running"
    }
}

$ kubectl get po -n vela-system
NAME                                        READY   STATUS    RESTARTS        AGE
kubevela-vela-core-8699fb6d68-mrfvv         1/1     Running   0               80s

$ kubectl get po -n vela-system
NAME                                        READY   STATUS    RESTARTS        AGE
kubevela-vela-core-8699fb6d68-58jrf         1/1     Running   0               37s

```