# Mysql-operator

This addon is for mysql-operator, which is managing mysql-clusters on the kubernetes

## Install

```shell
vela addon enable mysql-operator
```

## Uninstall

```shell
vela addon disable mysql-operator
```

### Keep the following to mysql-cluster-app.yaml, then vela up -f mysql-cluster-app.yaml
```shell
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: mysql-cluster-app
  namespace: mysql
spec:
  components:
    - name: mysql-cluster-component
      type: mysql-cluster
      properties:
        scname: first-sc
        mysqlname: first-cluster
        namespace: oeular

```
### Check the application status within component typed mysql-cluster
```shell
kubectl get application -A  | grep app
mysql            mysql-cluster-app      mysql-cluster-component   mysql-cluster   running   true      12m
```
Check the storageclass status for mysql-cluster
```shell
kubectl get sc
NAME                       PROVISIONER                       RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
mysql-sc                   kubernetes.io/no-provisioner      Delete          WaitForFirstConsumer   false                  4h30m
```
### Check the pvc status for mysql-cluster
```shell
kubectl get pvc -n oeular
NAME                          STATUS   VOLUME       CAPACITY   ACCESS MODES   STORAGECLASS   AGE
data-first-cluster-mysql-0    Bound    mysql-pv     2Gi        RWO            first-sc       47s
```
### Check the pv status for mysql-cluster
```shell
kubectl get pv
NAME         CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                                STORAGECLASS   REASON   AGE
mysql-pv     2Gi        RWO            Retain           Bound    oeular/data-first-cluster-mysql-0    first-sc                55s
```
### Check the pod status for mysql-cluster
```shell
kubectl get pod -n oeular
NAME                     READY   STATUS    RESTARTS   AGE
first-cluster-mysql-0    4/4     Running   0          71s
```
### Check the mysql-cluster status
```shell
kubectl get mysqlcluster -n oeular
NAME             READY   REPLICAS   AGE
first-cluster    True               81s
```
### Check the svc for mysql-cluster
```shell
kubectl get svc  -n oeular
NAME                            TYPE        CLUSTER-IP        EXTERNAL-IP   PORT(S)             AGE
first-cluster-mysql             ClusterIP   192.168.111.159   <none>        3306/TCP            94s
first-cluster-mysql-master      ClusterIP   192.168.19.103    <none>        3306/TCP,8080/TCP   94s
first-cluster-mysql-replicas    ClusterIP   192.168.110.72    <none>        3306/TCP,8080/TCP   94s
```
### Choose the master for accessing
```shell
kubectl port-forward service/first-cluster-mysql-master  3306 -n oeular
Forwarding from 127.0.0.1:3306 -> 3306
Forwarding from [::1]:3306 -> 3306
Handling connection for 3306

```
### Open a new terminal to test the mysql-cluster instance
```shell
mysql -h127.0.0.1 -uroot -p
Enter password:
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MySQL connection id is 163
Server version: 5.7.31-34-log Percona Server (GPL), Release 34, Revision 2e68637

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MySQL [(none)]> select @@hostname;
+-----------------------+
| @@hostname            |
+-----------------------+
| first-cluster-mysql-0 |
+-----------------------+
1 row in set (0.04 sec)

MySQL [(none)]>

```
