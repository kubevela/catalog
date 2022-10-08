
# mongodb-operator

MongoDB Operator is an operator created in Golang to create, update, and manage MongoDB standalone, replicated, and arbiter replicated setup on Kubernetes and Openshift clusters. This operator is capable of doing the setup for MongoDB with all the required best practices.

This addon based on the [mongodb-operator](https://github.com/OT-CONTAINER-KIT/mongodb-operator). The addon itself will deploy mongodb-cluster or mongodb-standalone for every application.


## Install

Add experimental registry
```
vela addon registry add experimental --type=helm --endpoint=https://addons.kubevela.net/experimental/
```

Enable this addon
```
vela addon enable mongodb-operator
```

```shell
$ vela ls -A | grep mongo
vela-system     addon-mongodb-operator          mongodb-operator-ns     k8s-objects                             running healthy                                                               
vela-system     └─                              mongodb-operator-helm   helm                                    running healthy Fetch repository successfully, Create helm release
```

Disable this addon
```
vela addon disable mongodb-operator
```

## Use
## mongodb-standalone
After you enable this addon, apply this Application yaml to create a standalone mongodb:

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: standalone-mongodb-sample
spec:
  components:
    - type: mongodb-standalone
      name: standalone-mongodb
      properties:
        mongoDBAdminUser: admin
        password: abc123456
        storageClass: nfs-client
        storageSize: 1Gi
```

```shell
$ kubectl get po   -n mongodb -o wide
NAME                   READY   STATUS    RESTARTS   AGE   IP             NODE                    NOMINATED NODE   READINESS GATES
standalone-mongodb-standalone-0   1/1     Running   0          56s   172.29.32.17   cn-chengdu.10.0.0.195   <none>           <none>


$ kubectl run --namespace mongodb  mongodb-client --rm --tty -i --restart='Never' --env="MONGODB_ROOT_PASSWORD=abc123456" --image docker.io/bitnami/mongodb:6.0.1-debian-11-r1 --command -- bash
If you don't see a command prompt, try pressing enter.
I have no name!@mongodb-client:/$
I have no name!@mongodb-client:/$ mongosh admin --host 172.29.32.10 --authenticationDatabase admin -u admin -p abc123456
Current Mongosh Log ID: 632f2981e0e417de6c523278
Connecting to:          mongodb://<credentials>@172.29.32.10:27017/admin?directConnection=true&authSource=admin&appName=mongosh+1.5.4
Using MongoDB:          5.0.6
Using Mongosh:          1.5.4

For mongosh info see: https://docs.mongodb.com/mongodb-shell/


To help improve our products, anonymous usage data is collected and sent to MongoDB periodically (https://www.mongodb.com/legal/privacy-policy).
You can opt-out by running the disableTelemetry() command.

------
   The server generated these startup warnings when booting
   2022-09-24T15:51:39.063+00:00: /sys/kernel/mm/transparent_hugepage/enabled is 'always'. We suggest setting it to 'never'
------

------
   Enable MongoDB's free cloud-based monitoring service, which will then receive and display
   metrics about your deployment (disk utilization, CPU, operation statistics, etc).

   The monitoring data will be available on a MongoDB website with a unique URL accessible to you
   and anyone you share the URL with. MongoDB may use this information to make product
   improvements and to suggest MongoDB products and deployment options to you.

   To enable free monitoring, run the following command: db.enableFreeMonitoring()
   To permanently disable this reminder, run the following command: db.disableFreeMonitoring()
------

admin>
```

## mongodb-cluster
After you enable this addon, apply this Application yaml to create a mongodb cluster:

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: cluster-mongodb-sample
spec:
  components:
    - type: mongodb-cluster
      name: cluster-mongodb
      properties:
        clusterSize: 3
        mongoDBAdminUser: admin
        password: abc123456
        storageClass: nfs-client
        storageSize: 1Gi
```
```shell
$ kubectl get po  -n mongodb-cluster  -o wide
NAME                READY   STATUS        RESTARTS   AGE   IP             NODE                    NOMINATED NODE   READINESS GATES
cluster-mongodb-cluster-0   1/1     Running       0          33m   172.29.32.12   cn-chengdu.10.0.0.195   <none>           <none>
cluster-mongodb-cluster-1   1/1     Running       0          32m   172.29.32.13   cn-chengdu.10.0.0.195   <none>           <none>
cluster-mongodb-cluster-2   1/1     Running       0          32m   172.29.32.14   cn-chengdu.10.0.0.195   <none>           <none>


$ kubectl run --namespace mongodb-cluster   mongodb-client  --rm --tty -i --restart='Never' --env="MONGODB_ROOT_PASSWORD=abc123456" --image docker.io/bitnami/mongodb:6.0.1-debian-11-r1 --command -- bash

I have no name!@mongodb-client-2:/$ mongosh admin --host 172.29.32.14 --authenticationDatabase admin -u admin -p abc123456
Current Mongosh Log ID: 632f355b45505f8a1e384a35
Connecting to:          mongodb://<credentials>@172.29.32.14:27017/admin?directConnection=true&authSource=admin&appName=mongosh+1.5.4
Using MongoDB:          5.0.6
Using Mongosh:          1.5.4

For mongosh info see: https://docs.mongodb.com/mongodb-shell/

------
   The server generated these startup warnings when booting
   2022-09-24T16:21:29.318+00:00: /sys/kernel/mm/transparent_hugepage/enabled is 'always'. We suggest setting it to 'never'
------

------
   Enable MongoDB's free cloud-based monitoring service, which will then receive and display
   metrics about your deployment (disk utilization, CPU, operation statistics, etc).

   The monitoring data will be available on a MongoDB website with a unique URL accessible to you
   and anyone you share the URL with. MongoDB may use this information to make product
   improvements and to suggest MongoDB products and deployment options to you.

   To enable free monitoring, run the following command: db.enableFreeMonitoring()
   To permanently disable this reminder, run the following command: db.disableFreeMonitoring()
------

admin>
```