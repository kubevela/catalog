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

## Use
## kafka-operator

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

After successful installation of kafka-cluster inside `kafka-operator` namespace, apply below YAML to create a kafka-topic inside `kafka-operator` namespace:

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: kafka-topic-sample
  namespace: kafka-operator
spec:
  components:
    - type: kafka-topic
      name: kafka-topic
      namespace: kafka-operator
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

## Run the operator locally
## Send and receive messages

With the cluster running, run a simple producer to send messages to the Kafka topic `kafka-topic`:

```shell
$ kubectl -n kafka-operator run kafka-producer -ti --image=quay.io/strimzi/kafka:0.33.2-kafka-3.4.0 --rm=true --restart=Never -- bin/kafka-console-producer.sh --bootstrap-server kafka-cluster-kafka-bootstrap:9092 --topic kafka-topic
```

And to receive them in a different terminal, run:

```shell
$ kubectl -n kafka-operator run kafka-consumer -ti --image=quay.io/strimzi/kafka:0.33.2-kafka-3.4.0 --rm=true --restart=Never -- bin/kafka-console-consumer.sh --bootstrap-server kafka-cluster-kafka-bootstrap:9092 --topic kafka-topic --from-beginning
```

Enjoy your Apache Kafka cluster, running on Minikube!
