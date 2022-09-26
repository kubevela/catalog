
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
Check the chaosblade-operator status
```shell
$ vela ls -A | grep chaos
vela-system     addon-chaosblade-operator       blade-ns                k8s-objects             running healthy                                                               2022-09-14 13:50:16 +0800 CST

$ kubectl get po -A | grep chaos
blade                          chaosblade-operator-b6f48fdbc-m9ff9                 1/1     Running            0                 3m52s
blade                          chaosblade-tool-sq7pj                               1/1     Running            0                 3m52s
```

Check the one trait of chaosblade called delete-pod-by-names, it will be used to show demo
```shell
$ vela show delete-pod-by-names
# Specification
+-----------+------------------------------+----------+----------+---------+
|   NAME    |         DESCRIPTION          |   TYPE   | REQUIRED | DEFAULT |
+-----------+------------------------------+----------+----------+---------+
| bladeName | Specify the chaosblade name. | string   | true     |         |
| podName   | Specify the pod names.       | []string | true     |         |
| nsName    | Specify the ns names.        | []string | true     |         |
+-----------+------------------------------+----------+----------+---------+
```

Deploy an applicatin without chaosblade
```shell
cat <<EOF | vela up -f -
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: oeular-app
spec:
  components:
  - name: nginx-demo
    type: webservice
    properties:
      exposeType: ClusterIP
      image: nginx:latest
      ports:
      - expose: true
        port: 80
        protocol: TCP
        ports: 80
EOF
```

Get the pod name to make a chaosblade
```shell
$ kubectl get po -n default | grep nginx
nginx-demo-6cbfdc95df-q7vmn   1/1     Running   0                 33s
```

Deploy an applicatin with one chaosblade trait named delete-pod-by-names
```shell
cat <<EOF | vela up -f -
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: oeular-app
spec:
  components:
  - name: nginx-demo
    type: webservice
    properties:
      exposeType: ClusterIP
      image: nginx:latest
      ports:
      - expose: true
        port: 80
        protocol: TCP
        ports: 80
    traits:
    - type: delete-pod-by-names
      properties:
        bladeName: delete-po-chaos
        podName:
        - nginx-demo-6cbfdc95df-q7vmn
        nsName:
        - default

EOF
```

Check the chaosblade we applied to the webservice component
```shell
$ kubectl get blade delete-po-chaos
NAME              AGE
delete-po-chaos   47s
```

Check the the pod of the webservice component, one new pod is recreated
```shell
$ kubectl get po -n default | grep nginx
nginx-demo-6cbfdc95df-2dmjn   1/1     Running            0               67s
```
## Note
In this README.md, only one trait of the chaosblade is given with demo. There are many traits in definitions can be tried.