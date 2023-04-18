# kruise-game

OpenKruiseGame (OKG) is a multicloud-oriented, open source Kubernetes workload specialized for game servers. It is a sub-project of the open source workload project OpenKruise of the Cloud Native Computing Foundation (CNCF) in the gaming field. OpenKruiseGame makes the cloud-native transformation of game servers easier, faster, and stabler.

For more visit: https://openkruise.io/kruisegame/introduction

## Install

Add experimental registry
```
vela addon registry add experimental --type=helm --endpoint=https://addons.kubevela.net/experimental/
```

Enable this addon
```
vela addon enable kruise-game
```

```shell
$ vela ls -A | grep kruise
vela-system     addon-kruise-game       kruise                                  helm                                            running healthy Fetch repository successfully, Create helm release
vela-system     └─                      kruise-game                             helm                                            running healthy Fetch repository successfully, Create helm release
```

Disable this addon
```
vela addon disable kruise-game
```

## Use kruise-game

### Deploy Gameservers

After you enable this addon, create a namespace `prod`:

```shell
$ kubectl create namespace prod
```

You can use GameServerSet to deploy game servers. A simple deployment case is as follows:


```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: game-server-set-sample
spec:
  components:
    - type: game-server-set
      name: minecraft
      properties:
        replicas: 3
        updateStrategy:
          rollingUpdate:
            podUpdatePolicy: InPlaceIfPossible
        gameServerTemplate:
          spec:
            containers:
              - image: registry.cn-hangzhou.aliyuncs.com/acs/minecraft-demo:1.12.2
                name: minecraft
```

After the GameServerSet is created, three game servers and three corresponding pods appear in the cluster, because the specified number of replicas is 3.

```shell
$ kubectl get gss -n prod
NAME        AGE
minecraft   25m

$ kubectl get gs -n prod
NAME          STATE   OPSSTATE   DP    UP
minecraft-0   Ready   None       0     0
minecraft-1   Ready   None       0     0
minecraft-2   Ready   None       0     0

$ kubectl get pod -n prod
NAME          READY   STATUS    RESTARTS   AGE
minecraft-0   1/1     Running   0          25m
minecraft-1   1/1     Running   0          25m
minecraft-2   1/1     Running   0          25m
```
