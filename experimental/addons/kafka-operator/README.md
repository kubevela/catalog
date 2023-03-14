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
$ kubectl get po  -n kafka-operator  -o wide
NAME                                            READY   STATUS    RESTARTS   AGE     IP            NODE       NOMINATED NODE   READINESS GATES
kafka-cluster-entity-operator-fbd554658-fpbwh   3/3     Running   0          5m48s   172.17.0.15   minikube   <none>           <none>
kafka-cluster-kafka-0                           1/1     Running   0          6m9s    172.17.0.14   minikube   <none>           <none>
kafka-cluster-zookeeper-0                       1/1     Running   0          6m30s   172.17.0.13   minikube   <none>           <none>
strimzi-cluster-operator-6f96fc9c95-ql7kt       1/1     Running   0          10m     172.17.0.10   minikube   <none>           <none>
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
$ kubectl get kafkaTopic -n kafka-operator | grep kafka-topic
NAME                                                                                               CLUSTER         PARTITIONS   REPLICATION FACTOR   READY
kafka-topic                                                                                        kafka-cluster   10           1                    True
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

after creating kafka-bridge, verify it.

```shell
$ kubectl get pods -n kafka-operator | grep kafka-bridge
kafka-bridge-bridge-75549d4f89-c6qjf            1/1     Running   0          34m

# Port forward the above pod
$ kubectl port-forward -n kafka-operator kafka-bridge-bridge-75549d4f89-c6qjf 8080:8080

# Visit on the port-forwarding port via CLI
$ curl http://localhost:8080
{"bridge_version":"0.24.0"}
```

**Create kafka-rebalance to depict every partition of topic**

Apply below YAML to create kafka-connector in `kafka-operator` namespace:

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

Now, Verify.

```shell
NAME              CLUSTER         PENDINGPROPOSAL   PROPOSALREADY   REBALANCING   READY   NOTREADY
kafka-rebalance   kafka-cluster                                                   True        
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

Now, verify.

```shell
$ kubectl get kafkaConnect -n kafka-operator
NAME            DESIRED REPLICAS   READY
kafka-connect   1                  True
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

Now, Verify.

```shell
$ kubectl get kafkaConnector -n kafka-operator
NAME              CLUSTER         CONNECTOR CLASS                                           MAX TASKS   READY
kafka-connector   kafka-connect   org.apache.kafka.connect.file.FileStreamSourceConnector   1           True
```

Enjoy your Apache Kafka cluster, running on Minikube!.
For more visit on https://strimzi.io/.
