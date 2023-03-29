# elasticsearch-operator

Elasticsearch is a search engine based on the Lucene library. It provides a distributed, multitenant-capable full-text search engine with an HTTP web interface and schema-free JSON documents. For more visit https://www.elastic.co/.

## Install

Add experimental registry
```
vela addon registry add experimental --type=helm --endpoint=https://addons.kubevela.net/experimental/
```

Enable this addon
```
vela addon enable elasticsearch-operator
```

```shell
$ vela ls -A | grep zookeeper
vela-vela-system     addon-elasticsearch-operator    ns-elasticsearch-operator               k8s-objects                                     running healthy
vela-system         └─                              elasticsearch-operator                   k8s-objects                                     running healthy  
```

Disable this addon
```
vela addon disable elasticsearch-operator
```

## Use elasticsearch-operator

###  Elasticsearch cluster

**Deploy Elasticsearch cluster**

Apply a simple Elasticsearch cluster specification, with one Elasticsearch node:

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: elasticsearch-cluster-sample
spec:
  components:
    - type: elasticsearch-cluster
      name: elasticsearch-cluster
      properties:
        version: 8.6.2
        nodeSets:
          - name: default
            count: 1
            podTemplate:
              spec:
                containers:
                  - name: elasticsearch
                    resources:
                      requests:
                        memory: 1Gi
                        cpu: 1
                      limits:
                        memory: 1Gi
                        cpu: 1
            config:
              node.store.allow_mmap: false
```

Get an overview of the current Elasticsearch clusters in the Kubernetes cluster, including health, version and number of nodes:

```shell
$ kubectl get elasticsearch -n prod
NAME                     HEALTH    NODES     VERSION   PHASE         AGE
elasticsearch-cluster    green     1         8.6.2     Ready         1m
```

*Note: When you create the cluster, there is no HEALTH status and the PHASE is empty. After a while, the PHASE turns into Ready, and HEALTH becomes green.*

**Request Elasticsearch access**

A ClusterIP Service is automatically created for your cluster:

```shell
$ kubectl get -n prod service elasticsearch-cluster-es-http
NAME                            TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
elasticsearch-cluster-es-http   ClusterIP   10.104.95.219   <none>        9200/TCP   12m
```

-   Get the credentials.

    A default user named elastic is automatically created with the password stored in a Kubernetes secret:

    ```shell
    PASSWORD=$(kubectl get secret -n prod elasticsearch-cluster-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')
    ```

-   Request the Elasticsearch endpoint.

    ```shell
    $ kubectl port-forward -n prod service/elasticsearch-cluster-es-http 9200
    ```

    Now, Request.

    ```shell
    $ curl -u "elastic:$PASSWORD" -k "https://localhost:9200"
    {
        "name" : "elasticsearch-cluster-es-default-0",
        "cluster_name" : "elasticsearch-cluster",
        "cluster_uuid" : "SAINs5BrQ8qspbcICHdxAg",
        "version" : {
            "number" : "8.6.2",
            "build_flavor" : "default",
            "build_type" : "docker",
            "build_hash" : "2d58d0f136141f03239816a4e360a8d17b6d8f29",
            "build_date" : "2023-02-13T09:35:20.314882762Z",
            "build_snapshot" : false,
            "lucene_version" : "9.4.2",
            "minimum_wire_compatibility_version" : "7.17.0",
            "minimum_index_compatibility_version" : "7.0.0"
        },
        "tagline" : "You Know, for Search"
    }
    ```

###  Kibana

**Deploy a Kibana instance**

To deploy your Kibana instance go through the apply below YAML:

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: kibana-sample
spec:
  components:
    - type: kibana
      name: kibana
      properties:
        version: 8.6.2
        count: 1
        elasticsearchRef:
          name: elasticsearch-cluster
```

Monitor Kibana health and creation progress.

```shell
$ kubectl get kibana
NAME     HEALTH   NODES   VERSION   AGE
kibana   green    1       8.6.2     7m39s
```

And the associated Pods:

```shell
$ kubectl get pod -n prod --selector='kibana.k8s.elastic.co/name=kibana'
NAME                        READY   STATUS    RESTARTS   AGE
kibana-kb-947c77847-kdbhf   1/1     Running   0          9m46s
```

**Access Kibana**

A ClusterIP Service is automatically created for Kibana:

```shell
kubectl get service -n prod kibana-kb-http
NAME             TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
kibana-kb-http   ClusterIP   10.109.2.144   <none>        5601/TCP   15m
```

```shell
kubectl port-forward -n prod service/kibana-kb-http 5601
```

Get credentials: 

```shell
kubectl get secret -n prod elasticsearch-cluster-es-elastic-user -o=jsonpath='{.data.elastic}' | base64 --decode; echo
```

Login as the elastic user by visiting https://localhost:5601 in your browser.
