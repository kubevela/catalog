
# MongoDB

[MongoDB](http://www.mongodb.com/) is a relational open source NoSQL database. Easy to use, it stores data in JSON-like documents. Automated scalability and high-performance. Ideal for developing cloud native applications.

This addon based on the [MongoDB](https://github.com/mongodb/mongo). The addon itself will deploy mongodb cluster for every application.


## Install

Add experimental registry
```
vela addon registry add experimental --type=helm --endpoint=https://addons.kubevela.net/experimental/
```

Enable this addon
```
vela addon enable mongodb
```

Disable this addon
```
vela addon disable mongodb
```

## Use
```shell
$ vela ls -A | grep mongodb
vela-system     addon-mongodb           mongodb-ns              k8s-objects                     running healthy                                                               2022-09-11 18:58:00 +0800 CST
vela-system     └─                      mongodb-helm            helm                            running healthy Fetch repository successfully, Create helm release            2022-09-11 18:58:00 +0800 CST
```

```shell
Please access addon-mongodb from the following endpoints:
+---------+--------------+--------------------------------------+------------------------------------+-------+
| CLUSTER |  COMPONENT   |       REF(KIND/NAMESPACE/NAME)       |              ENDPOINT              | INNER |
+---------+--------------+--------------------------------------+------------------------------------+-------+
| local   | mongodb-helm | Service/mongodb/mongodb-mongodb-helm | mongodb-mongodb-helm.mongodb:27017 | true  |
+---------+--------------+--------------------------------------+------------------------------------+-------+
```

```shell
$ kubectl run --namespace mongodb  mongodb-client --rm --tty -i --restart='Never' --env="MONGODB_ROOT_PASSWORD=$MONGODB_ROOT_PASSWORD" --image docker.io/bitnami/mongodb:6.0.1-debian-11-r1 --command -- bash
If you don't see a command prompt, try pressing enter.

I have no name!@mongodb-client:/$ mongosh admin --host "mongodb-mongodb-helm" --authenticationDatabase admin -u root -p $MONGODB_ROOT_PASSWORD
Current Mongosh Log ID: 631dc377ba1deb5f3945f2f3
Connecting to:          mongodb://<credentials>@mongodb-mongodb-helm:27017/admin?directConnection=true&authSource=admin&appName=mongosh+1.5.4
Using MongoDB:          6.0.1
Using Mongosh:          1.5.4

For mongosh info see: https://docs.mongodb.com/mongodb-shell/


To help improve our products, anonymous usage data is collected and sent to MongoDB periodically (https://www.mongodb.com/legal/privacy-policy).
You can opt-out by running the disableTelemetry() command.

------
   The server generated these startup warnings when booting
   2022-09-11T10:58:12.257+00:00: Using the XFS filesystem is strongly recommended with the WiredTiger storage engine. See http://dochub.mongodb.org/core/prodnotes-filesystem
   2022-09-11T10:58:12.543+00:00: /sys/kernel/mm/transparent_hugepage/enabled is 'always'. We suggest setting it to 'never'
   2022-09-11T10:58:12.543+00:00: vm.max_map_count is too low
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

admin> show dbs
admin   100.00 KiB
config   60.00 KiB
local    72.00 KiB
admin>



```