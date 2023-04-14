# kafka-operator

Apache Kafka is an open-source distributed publish-subscribe messaging system for fault-tolerant real-time data feeds.
For more information about Apache Kafka, see the Apache Kafka documentation https://kafka.apache.org/documentation/.

## Install

Add experimental registry
```
vela addon registry add experimental --type=helm --endpoint=https://addons.kubevela.net/experimental/
```

Enable this addon
```
vela addon enable kafka-operator
```

```shell
$ vela ls -A | grep kafka
vela-system     addon-kafka-operator    ns-kafka-operator                       k8s-objects                                     running healthy
vela-system     └─                      kafka-operator                          helm                                            running healthy Fetch repository successfully, Create helm release
```

Disable this addon
```
vela addon disable kafka-operator
```

## Use kafka-operator

**Create kafka-cluster**

After you enable this addon, apply below YAML to create a kafka cluster inside kafka-operator namespace:

```yaml
# kafka-cluster.yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: kafka-cluster-sample
spec:
  components:
    - type: kafka-cluster
      name: kafka-cluster
      properties:
        kafka:
          replicas: 1
        zookeeper:
          replicas: 1
```

```shell
# First, Create kafka-cluster.yaml file using above YAML, Then apply below command.
$ vela up -f kafka-cluster.yaml -n kafka-operator
Applying an application in vela K8s object format...
I0406 13:54:27.824629  228528 apply.go:121] "creating object" name="kafka-cluster-sample" resource="core.oam.dev/v1beta1, Kind=Application"
✅ App has been deployed 🚀🚀🚀
    Port forward: vela port-forward kafka-cluster-sample -n kafka-operator
             SSH: vela exec kafka-cluster-sample -n kafka-operator
         Logging: vela logs kafka-cluster-sample -n kafka-operator
      App status: vela status kafka-cluster-sample -n kafka-operator
        Endpoint: vela status kafka-cluster-sample -n kafka-operator --endpoint
Application kafka-operator/kafka-cluster-sample applied.
```

Now, Verify.

```shell
$ vela status kafka-cluster-sample -n kafka-operator
About:

  Name:         kafka-cluster-sample         
  Namespace:    kafka-operator               
  Created at:   2023-04-06 13:54:27 +0530 IST
  Status:       running                      

Workflow:

  mode: DAG-DAG
  finished: true
  Suspend: false
  Terminated: false
  Steps
  - id: eh66k3muw7
    name: kafka-cluster
    type: apply-component
    phase: succeeded 

Services:

  - Name: kafka-cluster  
    Cluster: local  Namespace: kafka-operator
    Type: kafka-cluster
    Healthy 
    No trait applied
```

**Create kafka-topic**

After successful installation of kafka-cluster inside `kafka-operator` namespace, apply below YAML to create a kafka-topic inside `kafka-operator` namespace:

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: kafka-topic-sample
spec:
  components:
    - type: kafka-topic
      name: kafka-topic
      properties:
        partitions: 10
        replicas: 1
        config:
          retention.ms: 604800000
          segment.bytes: 1073741824
```

```shell
# First, Create kafka-topic.yaml file using above YAML, Then apply below command.
$ vela up -f kafka-topic.yaml -n kafka-operator
Applying an application in vela K8s object format...
I0406 14:05:04.023820  255043 apply.go:121] "creating object" name="kafka-topic-sample" resource="core.oam.dev/v1beta1, Kind=Application"
✅ App has been deployed 🚀🚀🚀
    Port forward: vela port-forward kafka-topic-sample -n kafka-operator
             SSH: vela exec kafka-topic-sample -n kafka-operator
         Logging: vela logs kafka-topic-sample -n kafka-operator
      App status: vela status kafka-topic-sample -n kafka-operator
        Endpoint: vela status kafka-topic-sample -n kafka-operator --endpoint
Application kafka-operator/kafka-topic-sample applied.
```

Now, Verify.

```shell
$ vela status kafka-topic-sample -n kafka-operator
About:

  Name:         kafka-topic-sample           
  Namespace:    kafka-operator               
  Created at:   2023-04-06 14:05:04 +0530 IST
  Status:       running                      

Workflow:

  mode: DAG-DAG
  finished: true
  Suspend: false
  Terminated: false
  Steps
  - id: ld98eberfn
    name: kafka-topic
    type: apply-component
    phase: succeeded 

Services:

  - Name: kafka-topic  
    Cluster: local  Namespace: kafka-operator
    Type: kafka-topic
    Healthy 
    No trait applied

```

**Send and receive messages with Producer & Consumer**

An event records the fact that "something happened" in the world or in your business. It is also called record or message in the documentation. When you read or write data to Kafka, you do this in the form of events. Conceptually, an event has a key, value, timestamp, and optional metadata headers. Here's an example event:

- Event key: "Alice"
- Event value: "Made a payment of $200 to Bob"
- Event timestamp: "Jun. 25, 2020 at 2:06 p.m."

Producers are those client applications that publish (write) events to Kafka, and consumers are those that subscribe to (read and process) these events. In Kafka, producers and consumers are fully decoupled and agnostic of each other, which is a key design element to achieve the high scalability that Kafka is known for. For example, producers never need to wait for consumers.

Events are organized and durably stored in topics. Very simplified, a topic is similar to a folder in a filesystem, and the events are the files in that folder.

*Make sure that `kafka-topic` and `kafka-cluster` got created successfullly before to move further because further steps utilizes `kafka-topic` and `kafka-cluster`.*

With the cluster running, run a simple producer to send messages to the Kafka topic `kafka-topic`:

```shell
$ kubectl -n kafka-operator run kafka-producer -ti --image=quay.io/strimzi/kafka:0.33.2-kafka-3.4.0 --rm=true --restart=Never -- bin/kafka-console-producer.sh --bootstrap-server kafka-cluster-kafka-bootstrap:9092 --topic kafka-topic
```

And to receive messages in a different terminal from topic, run:

```shell
$ kubectl -n kafka-operator run kafka-consumer -ti --image=quay.io/strimzi/kafka:0.33.2-kafka-3.4.0 --rm=true --restart=Never -- bin/kafka-console-consumer.sh --bootstrap-server kafka-cluster-kafka-bootstrap:9092 --topic kafka-topic --from-beginning
```

**Create a kafka-bridge to enable HTTP connection to the kafka-cluster**

Apply below YAML to create kafka bridge in `kafka-operator` namespace:

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: kafka-bridge-sample
spec:
  components:
    - type: kafka-bridge
      name: kafka-bridge
      properties:
        replicas: 1
        bootstrapServers: 'kafka-cluster-kafka-bootstrap:9092'
        http:
          port: 8080
```

```shell
# First, Create kafka-bridge.yaml file using above YAML, Then apply below command.
$ vela up -f kafka-bridge.yaml -n kafka-operator
Applying an application in vela K8s object format...
I0406 14:16:23.139482  281531 apply.go:121] "creating object" name="kafka-bridge-sample" resource="core.oam.dev/v1beta1, Kind=Application"
✅ App has been deployed 🚀🚀🚀
    Port forward: vela port-forward kafka-bridge-sample -n kafka-operator
             SSH: vela exec kafka-bridge-sample -n kafka-operator
         Logging: vela logs kafka-bridge-sample -n kafka-operator
      App status: vela status kafka-bridge-sample -n kafka-operator
        Endpoint: vela status kafka-bridge-sample -n kafka-operator --endpoint
Application kafka-operator/kafka-bridge-sample applied.
```

Now, Verify.

```shell
$ vela status kafka-bridge-sample -n kafka-operator
About:

  Name:         kafka-bridge-sample          
  Namespace:    kafka-operator               
  Created at:   2023-04-06 14:16:23 +0530 IST
  Status:       running                      

Workflow:

  mode: DAG-DAG
  finished: true
  Suspend: false
  Terminated: false
  Steps
  - id: ic332zwn64
    name: kafka-bridge
    type: apply-component
    phase: succeeded 

Services:

  - Name: kafka-bridge  
    Cluster: local  Namespace: kafka-operator
    Type: kafka-bridge
    Healthy 
    No trait applied
```

Create a NodePort service.

```shell
# Create a NodePort service.
$ kubectl expose -n kafka-operator service kafka-bridge-bridge-service --port=8080 --target-port=8080 --name=kafka-bridge-nodeport --type=NodePort

# Access the NodePort service using minikube.
$ svcurl=$(minikube service -n kafka-operator kafka-bridge-nodeport --url)

# Visit on the port-forwarding port via CLI
$ curl $svcurl
{"bridge_version":"0.24.0"}
```

**Create kafka-rebalance to depict every partition of topic**

Apply below YAML to create kafka-rebalance in `kafka-operator` namespace:

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: kafka-rebalance-sample
spec:
  components:
    - type: kafka-rebalance
      name: kafka-rebalance
      properties:
        goals:
        - CpuCapacityGoal
        - NetworkInboundCapacityGoal
        - DiskCapacityGoal
        - RackAwareGoal
        - MinTopicLeadersPerBrokerGoal
        - NetworkOutboundCapacityGoal
        - ReplicaCapacityGoal
```

```shell
# First, Create kafka-rebalance.yaml file using above YAML, Then apply below command.
$ vela up -f kafka-rebalance.yaml -n kafka-operator
Applying an application in vela K8s object format...
I0406 14:27:54.395927  309046 apply.go:121] "creating object" name="kafka-rebalance-sample" resource="core.oam.dev/v1beta1, Kind=Application"
✅ App has been deployed 🚀🚀🚀
    Port forward: vela port-forward kafka-rebalance-sample -n kafka-operator
             SSH: vela exec kafka-rebalance-sample -n kafka-operator
         Logging: vela logs kafka-rebalance-sample -n kafka-operator
      App status: vela status kafka-rebalance-sample -n kafka-operator
        Endpoint: vela status kafka-rebalance-sample -n kafka-operator --endpoint
Application kafka-operator/kafka-rebalance-sample applied.
```

Now, Verify.

```shell
vela status kafka-rebalance-sample -n kafka-operator
About:

  Name:         kafka-rebalance-sample       
  Namespace:    kafka-operator               
  Created at:   2023-04-06 14:27:54 +0530 IST
  Status:       running                      

Workflow:

  mode: DAG-DAG
  finished: true
  Suspend: false
  Terminated: false
  Steps
  - id: jxr1yzhi2r
    name: kafka-rebalance
    type: apply-component
    phase: succeeded 

Services:

  - Name: kafka-rebalance  
    Cluster: local  Namespace: kafka-operator
    Type: kafka-rebalance
    Healthy 
    No trait applied
```

### External datasource connection to kafka broker

**Create kafka-connect cluster**

Apply below YAML to create kafka-connect in `kafka-operator` namespace:

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: kafka-connect-sample
spec:
  components:
    - type: kafka-connect
      name: kafka-connect
      properties:
        version: 3.3.2
        replicas: 1
        bootstrapServers: "kafka-cluster-kafka-bootstrap:9093"
        tls:
          trustedCertificates:
            - secretName: kafka-cluster-cluster-ca-cert
              certificate: ca.crt
        config:
          group.id: connect-cluster
          offset.storage.topic: connect-cluster-offsets
          config.storage.topic: connect-cluster-configs
          status.storage.topic: connect-cluster-status
          config.storage.replication.factor: -1
          offset.storage.replication.factor: -1
          status.storage.replication.factor: -1
```

```shell
# First, Create kafka-connect.yaml file using above YAML, Then apply below command.
$ vela up -f kafka-connect.yaml -n kafka-operator
Applying an application in vela K8s object format...
I0406 14:33:32.214558  322307 apply.go:121] "creating object" name="kafka-connect-sample" resource="core.oam.dev/v1beta1, Kind=Application"
✅ App has been deployed 🚀🚀🚀
    Port forward: vela port-forward kafka-connect-sample -n kafka-operator
             SSH: vela exec kafka-connect-sample -n kafka-operator
         Logging: vela logs kafka-connect-sample -n kafka-operator
      App status: vela status kafka-connect-sample -n kafka-operator
        Endpoint: vela status kafka-connect-sample -n kafka-operator --endpoint
Application kafka-operator/kafka-connect-sample applied.
```

Now, verify.

```shell
$ vela status kafka-connect-sample -n kafka-operator
About:

  Name:         kafka-connect-sample         
  Namespace:    kafka-operator               
  Created at:   2023-04-06 14:33:32 +0530 IST
  Status:       running                      

Workflow:

  mode: DAG-DAG
  finished: true
  Suspend: false
  Terminated: false
  Steps
  - id: mx6g7qwc7z
    name: kafka-connect
    type: apply-component
    phase: succeeded 

Services:

  - Name: kafka-connect  
    Cluster: local  Namespace: kafka-operator
    Type: kafka-connect
    Healthy 
    No trait applied
```

**Create kafka-connector to connect with `kafka-connect` cluster and external datasource**

Apply below YAML to create kafka-connector in `kafka-operator` namespace:

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: kafka-connector-sample
spec:
  components:
    - type: kafka-connector
      name: kafka-connector
      properties:
        class: org.apache.kafka.connect.file.FileStreamSourceConnector
        tasksMax: 1
        config:
          file: /opt/kafka/LICENSE
          topic: kafka-topic
```

```shell
# First, Create kafka-connector.yaml file using above YAML, Then apply below command.
$ vela up -f kafka-connector.yaml -n kafka-operator
Applying an application in vela K8s object format...
I0406 14:41:29.559970  342274 apply.go:121] "creating object" name="kafka-connector-sample" resource="core.oam.dev/v1beta1, Kind=Application"
✅ App has been deployed 🚀🚀🚀
    Port forward: vela port-forward kafka-connector-sample -n kafka-operator
             SSH: vela exec kafka-connector-sample -n kafka-operator
         Logging: vela logs kafka-connector-sample -n kafka-operator
      App status: vela status kafka-connector-sample -n kafka-operator
        Endpoint: vela status kafka-connector-sample -n kafka-operator --endpoint
Application kafka-operator/kafka-connector-sample applied.
```

Now, Verify.

```shell
$ vela status kafka-connector-sample -n kafka-operator
About:

  Name:         kafka-connector-sample       
  Namespace:    kafka-operator               
  Created at:   2023-04-06 14:41:29 +0530 IST
  Status:       running                      

Workflow:

  mode: DAG-DAG
  finished: true
  Suspend: false
  Terminated: false
  Steps
  - id: 1li4qnv9k3
    name: kafka-connector
    type: apply-component
    phase: succeeded 

Services:

  - Name: kafka-connector  
    Cluster: local  Namespace: kafka-operator
    Type: kafka-connector
    Healthy 
    No trait applied
```

Enjoy your Apache Kafka cluster, running on Minikube!.
For more visit on https://strimzi.io/.
