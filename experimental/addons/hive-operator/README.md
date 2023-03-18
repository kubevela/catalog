# hive-operator

Apache Hive is a distributed, fault-tolerant data warehouse system that enables analytics at a massive scale. Hive Metastore(HMS) provides a central repository of metadata that can easily be analyzed to make informed, data driven decisions, and therefore it is a critical component of many data lake architectures. Hive is built on top of Apache Hadoop and supports storage on S3, adls, gs etc though hdfs. Hive allows users to read, write, and manage petabytes of data using SQL.

This is an operator for Kubernetes that can manage Apache Hive. Currently, it only supports the Hive Metastore!

## Install Operator

Add experimental registry
```
vela addon registry add experimental --type=helm --endpoint=https://addons.kubevela.net/experimental/
```

Enable this addon
```
vela addon enable hive-operator
```

```shell
$ vela ls -A | grep hive
vela-system     addon-hive-operator     ns-hive-operator                        k8s-objects                                     running healthy
vela-system     └─                      hive-operator                           helm                                            running healthy Fetch repository successfully, Create helm release
```

Disable this addon
```
vela addon disable hive-operator
```

## Install Dependencies

In order to install the MinIO and PostgreSQL dependencies via Helm, you have to deploy two charts.

**Minio**

```shell
helm install minio \
--namespace prod \
--version 4.0.2 \
--set mode=standalone \
--set replicas=1 \
--set persistence.enabled=false \
--set buckets[0].name=hive,buckets[0].policy=none \
--set users[0].accessKey=hive,users[0].secretKey=hivehive,users[0].policy=readwrite \
--set resources.requests.memory=1Gi \
--set service.type=NodePort,service.nodePort=null \
--set consoleService.type=NodePort,consoleService.nodePort=null \
--repo https://charts.min.io/ minio
```

**PostgresSQL**

```shell
helm install postgresql \
--version=12.1.5 \
--namespace prod \
--set postgresqlUsername=hive \
--set postgresqlPassword=hive \
--set postgresqlDatabase=hive \
--repo https://charts.bitnami.com/bitnami postgresql
```

## Use

After going through the Installation section and having installed all the dependencies, you will now deploy a Hive metastore cluster and it’s dependencies. Afterwards you can verify that it works.

In order to connect Hive to MinIO we need to create several dependent components like S3Connection, Secret and a SecretClass

**s3-connection**

An S3Connection to connect to MinIO:

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: s3-connection-sample
spec:
  components:
    - type: s3-connection
      name: minio
      properties:
        host: minio
        port: 9000
        accessStyle: Path
        credentials:
          secretClass: hive-s3-secret-class
```

**secret**

Credentials for the S3Connection to log into MinIO:

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: hive-secret-sample
spec:
  components:
    - type: k8s-objects
      name: k8s-demo-secret
      properties:
        objects:
          - apiVersion: v1
            kind: Secret
            metadata:
              name: hive-s3-secret
              labels:
                secrets.stackable.tech/class: hive-s3-secret-class
            stringData:
              accessKey: hive
              secretKey: hivehive
```

**secret-class**

A SecretClass for the credentials to the Minio. The credentials were defined in the installation of Minio via helm:

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: secret-class-sample
spec:
  components:
    - type: secret-class
      name: hive-s3-secret-class
      properties:
        backend:
          k8sSearch:
            searchNamespace:
              pod: {}
```

**hive-cluster**

And lastly the actual Apache Hive cluster definition:

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: hive-postgres-cluster
spec:
  components:
    - type: hive-cluster
      name: hive-postgres-cluster
      properties:
        image:
          productVersion: 3.1.3
          stackableVersion: 23.1.0
        clusterConfig:
          database:
            connString: jdbc:postgresql://postgresql:5432/hive
            user: hive
            password: hive
            dbType: postgres
          s3:
            reference: minio
        metastore:
          roleGroups:
            default:
              replicas: 1

```

Verify that it works

```shell
$ kubectl get statefulset -n prod
NAME                                      READY   AGE
hive-postgres-cluster-metastore-default   1/1     76s
```

For more visit on the website https://docs.stackable.tech/home/stable/hive/index.html.
