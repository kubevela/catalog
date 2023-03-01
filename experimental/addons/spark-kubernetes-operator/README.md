# spark-kubernetes-operator

A kubernetes operator for Apache Spark(https://github.com/GoogleCloudPlatform/spark-on-k8s-operator), it allows users to manage Spark applications and their lifecycle through native K8S tooling like `kubectl`.

> Note: It's not provided by Apache Spark. But widely used by a large number of companies(https://github.com/GoogleCloudPlatform/spark-on-k8s-operator/blob/master/docs/who-is-using.md).

# Install

```
#The following steps are for enabling fluxcd and spark-kubernetes-operator in namespace called "spark-operator".

vela addon enable fluxcd
vela addon enable spark-kubernetes-operator
```

# Uninstall

```
vela addon disable spark-kubernetes-operator
vela addon disable fluxcd
```

# To check the spark-kubernetes-operator running status

* Firstly, check the spark-kubernetes-operator (and the fluxcd and we need to deploy by helm) running status

```
vela addon status spark-kubernetes-operator
vela ls -A | grep spark
```

* Secondly, show the component type `spark-workload`, so we know how to use it in one application. As a spark user, you can choose the parameter to set for your spark cluster.

```
vela show spark-workload
# Specification
+----------------------+------------------------------------------------------------------------------------------------------+-------------------------------------------------+----------+---------+
|         NAME         |                                             DESCRIPTION                                              |                      TYPE                       | REQUIRED | DEFAULT |
+----------------------+------------------------------------------------------------------------------------------------------+-------------------------------------------------+----------+---------+
| name                 | Specify the spark application name.                                                                  | string                                          | true     |         |
| namespace            | Specify the namespace for spark application to install.                                              | string                                          | true     |         |
| type                 | Specify the application language type, e.g. "Scala", "Python", "Java" or "R".                        | string                                          | true     |         |
| pythonVersion        | Specify the python version.                                                                          | string                                          | false    |         |
| mode                 | Specify the deploy mode, e.go "cluster", "client" or "in-cluster-client".                            | string                                          | true     |         |
| image                | Specify the container image for the driver, executor, and init-container.                            | string                                          | true     |         |
| imagePullPolicy      | Specify the image pull policy for the driver, executor, and init-container.                          | string                                          | true     |         |
| mainClass            | Specify the fully-qualified main class of the Spark application.                                     | string                                          | true     |         |
| mainApplicationFile  | Specify the path to a bundled JAR, Python, or R file of the application.                             | string                                          | true     |         |
| sparkVersion         | Specify the version of Spark the application uses.                                                   | string                                          | true     |         |
| driverCores          | Specify the number of CPU cores to request for the driver pod.                                       | int                                             | true     |         |
| executorCores        | Specify the number of CPU cores to request for the executor pod.                                     | int                                             | true     |         |
| arguments            | Specify a list of arguments to be passed to the application.                                         | []string                                        | false    |         |
| sparkConf            | Specify the config information carries user-specified Spark configuration properties as they would   | map[string]string                               | false    |         |
|                      | use the  "--conf" option in spark-submit.                                                            |                                                 |          |         |
| hadoopConf           | Specify the config information carries user-specified Hadoop configuration properties as they would  | map[string]string                               | false    |         |
|                      | use the  the "--conf" option in spark-submit.  The SparkApplication controller automatically adds    |                                                 |          |         |
|                      | prefix "spark.hadoop." to Hadoop configuration properties.                                           |                                                 |          |         |
| sparkConfigMap       | Specify the name of the ConfigMap containing Spark configuration files such as log4j.properties. The | string                                          | false    |         |
|                      | controller will add environment variable SPARK_CONF_DIR to the path where the ConfigMap is mounted   |                                                 |          |         |
|                      | to.                                                                                                  |                                                 |          |         |
| hadoopConfigMap      | Specify the name of the ConfigMap containing Hadoop configuration files such as core-site.xml. The   | string                                          | false    |         |
|                      | controller will add environment variable HADOOP_CONF_DIR to the path where the ConfigMap is mounted  |                                                 |          |         |
|                      | to.                                                                                                  |                                                 |          |         |
| volumes              | Specify the list of Kubernetes volumes that can be mounted by the driver and/or executors.           | [[]volumes](#volumes)                           | false    |         |
| driverVolumeMounts   | Specify the volumes listed in "parameter.volumes" to mount into the main container’s filesystem for  | [[]driverVolumeMounts](#drivervolumemounts)     | false    |         |
|                      | driver pod.                                                                                          |                                                 |          |         |
| executorVolumeMounts | Specify the volumes listed in "parameter.volumes" to mount into the main container’s filesystem for  | [[]executorVolumeMounts](#executorvolumemounts) | false    |         |
|                      | executor pod.                                                                                        |                                                 |          |         |
+----------------------+------------------------------------------------------------------------------------------------------+-------------------------------------------------+----------+---------+


## volumes
+----------+-------------+-----------------------+----------+---------+
|   NAME   | DESCRIPTION |         TYPE          | REQUIRED | DEFAULT |
+----------+-------------+-----------------------+----------+---------+
| name     |             | string                | true     |         |
| hostPath |             | [hostPath](#hostpath) | true     |         |
+----------+-------------+-----------------------+----------+---------+


### hostPath
+------+-------------+--------+----------+-----------+
| NAME | DESCRIPTION |  TYPE  | REQUIRED |  DEFAULT  |
+------+-------------+--------+----------+-----------+
| path |             | string | true     |           |
| type |             | string | false    | Directory |
+------+-------------+--------+----------+-----------+


## driverVolumeMounts
+-----------+-------------+--------+----------+---------+
|   NAME    | DESCRIPTION |  TYPE  | REQUIRED | DEFAULT |
+-----------+-------------+--------+----------+---------+
| name      |             | string | true     |         |
| mountPath |             | string | true     |         |
+-----------+-------------+--------+----------+---------+


## executorVolumeMounts
+-----------+-------------+--------+----------+---------+
|   NAME    | DESCRIPTION |  TYPE  | REQUIRED | DEFAULT |
+-----------+-------------+--------+----------+---------+
| name      |             | string | true     |         |
| mountPath |             | string | true     |         |
+-----------+-------------+--------+----------+---------+
```

# Example for how to run a component typed spark-cluster in application

**Note**: If we want to check and verify the mount volume, we need to specify `parameter.createWebhook` to be `true`. For more details, please check the [official documentation](https://github.com/GoogleCloudPlatform/spark-on-k8s-operator/blob/master/docs/user-guide.md#mounting-volumes).

1. Firstly, download or copy `catalog/examples/spark-kubernetes-operator/sparkapp.yaml`

2. Secondly, start the application:

```
vela up -f sparkapp.yaml
```

You will see the stdout like this:

```
Applying an application in vela K8s object format...
I0227 16:54:37.069480  361176 apply.go:121] "creating object" name="spark-app-v1" resource="core.oam.dev/v1beta1, Kind=Application"
✅ App has been deployed 🚀🚀🚀
    Port forward: vela port-forward spark-app-v1 -n spark-cluster
             SSH: vela exec spark-app-v1 -n spark-cluster
         Logging: vela logs spark-app-v1 -n spark-cluster
      App status: vela status spark-app-v1 -n spark-cluster
        Endpoint: vela status spark-app-v1 -n spark-cluster --endpoint
Application spark-cluster/spark-app-v1 applied.
```

3. Then, there are serval ways to check the status(or detail information) of the Spark applicaiton:

option 1:

```
vela status spark-app-v1 -n spark-cluster
About:

  Name:      	spark-app-v1
  Namespace: 	spark-cluster
  Created at:	2023-02-27 16:54:37 +0800 CST
  Status:    	running

Workflow:

  mode: DAG-DAG
  finished: true
  Suspend: false
  Terminated: false
  Steps
  - id: vfgjkrxvih
    name: spark-workload-component
    type: apply-component
    phase: succeeded

Services:

  - Name: spark-workload-component
    Cluster: local  Namespace: spark-cluster
    Type: spark-workload
    Healthy
    No trait applied
```

option 2:

```
kubectl get sparkapplications -n spark-cluster
NAME           STATUS    ATTEMPTS   START                  FINISH       AGE
my-spark-app   RUNNING   1          2023-02-27T08:54:40Z   <no value>   2m33s
```

option 3:

```
kubectl describe sparkapplication my-spark-app -n spark-cluster
Name:         my-spark-app
Namespace:    spark-cluster
Labels:       app.oam.dev/app-revision-hash=4e5592aea53a5961
              app.oam.dev/appRevision=spark-app-v1-v1
              app.oam.dev/cluster=local
              app.oam.dev/component=my-spark-application-component
              app.oam.dev/name=spark-app-v1
              app.oam.dev/namespace=spark-cluster
              app.oam.dev/resourceType=TRAIT
              app.oam.dev/revision=
              oam.dev/render-hash=640a3298d803274e
              trait.oam.dev/resource=spark
              trait.oam.dev/type=AuxiliaryWorkload
Annotations:  app.oam.dev/last-applied-configuration:
                {"apiVersion":"sparkoperator.k8s.io/v1beta2","kind":"SparkApplication","metadata":{"annotations":{"app.oam.dev/last-applied-time":"2023-02...
              app.oam.dev/last-applied-time: 2023-02-27T16:54:37+08:00
              oam.dev/kubevela-version: v1.7.0
API Version:  sparkoperator.k8s.io/v1beta2
Kind:         SparkApplication
Metadata:
......
```

option 4:

```
kubectl get app spark-app-v1 -n spark-cluster -oyaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
......
```

4. Show the service of spark application via this command:

```
kubectl get svc -n spark-cluster
NAME                                       TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                      AGE
my-spark-app-c58a1c869214bfe5-driver-svc   ClusterIP   None             <none>        7078/TCP,7079/TCP,4040/TCP   19m
my-spark-app-ui-svc                        ClusterIP   xx.xx.xx.xx      <none>        4040/TCP                     19m
```

# Architecture

> The following content is quoted from the [original design document](https://github.com/GoogleCloudPlatform/spark-on-k8s-operator/blob/master/docs/design.md).

The operator consists of:
* a `SparkApplication` controller that watches events of creation, updates, and deletion of
`SparkApplication` objects and acts on the watch events,
* a *submission runner* that runs `spark-submit` for submissions received from the controller,
* a *Spark pod monitor* that watches for Spark pods and sends pod status updates to the controller,
* a [Mutating Admission Webhook](https://kubernetes.io/docs/reference/access-authn-authz/extensible-admission-controllers/) that handles customizations for Spark driver and executor pods based on the annotations on the pods added by the controller,
* and also a command-line tool named `sparkctl` for working with the operator.

The following diagram shows how different components interact and work together.

![Architecture Diagram](https://raw.githubusercontent.com/GoogleCloudPlatform/spark-on-k8s-operator/master/docs/architecture-diagram.png)

Specifically, a user uses the `sparkctl` (or `kubectl`) to create a `SparkApplication` object. The `SparkApplication` controller receives the object through a watcher from the API server, creates a submission carrying the `spark-submit` arguments, and sends the submission to the *submission runner*. The submission runner submits the application to run and creates the driver pod of the application. Upon starting, the driver pod creates the executor pods. While the application is running, the *Spark pod monitor* watches the pods of the application and sends status updates of the pods back to the controller, which then updates the status of the application accordingly. 
