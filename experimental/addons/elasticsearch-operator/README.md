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

###  Elasticsearch agent

**Deploy a Elasticsearch agent**

Apply the following specification to deploy Elastic Agent with the System metrics integration to harvest CPU metrics from the Agent Pods. ECK automatically configures the secured connection to an Elasticsearch cluster named `elasticsearch-cluster` that you created previously.

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: elasticsearch-agent-sample
spec:
  components:
    - type: elasticsearch-agent
      name: elasticsearch-agent
      properties:
        version: 8.6.2
        elasticsearchRefs:
          - name: elasticsearch-cluster
        daemonSet:
          podTemplate:
            spec:
              securityContext:
                runAsUser: 0
        config:
          inputs:
            - name: system-1
              revision: 1
              type: system/metrics
              use_output: default
              meta:
                package:
                  name: system
                  version: 0.9.1
              data_stream:
                namespace: default
              streams:
                - id: system/metrics-system.cpu
                  data_stream:
                    dataset: system.cpu
                    type: metrics
                  metricsets:
                    - cpu
                  cpu.metrics:
                    - percentages
                    - normalized_percentages
                  period: 10s
```

Monitor the status of Elastic Agent.

```shell
$ kubectl get agent -n prod
NAME                  HEALTH   AVAILABLE   EXPECTED   VERSION   AGE
elasticsearch-agent   green    1           1          8.6.2     23m
```

List all the Pods that belong to a given Elastic Agent specification.

```shell
$ kubectl get pods -n prod --selector='agent.k8s.elastic.co/name=elasticsearch-agent'
NAME                              READY   STATUS    RESTARTS   AGE
elasticsearch-agent-agent-kfv9s   1/1     Running   0          21m
```

Access logs for one of the Pods.

```shell
$ kubectl logs -n prod -f elasticsearch-agent-agent-kfv9s
```

Access the CPU metrics ingested by Elastic Agent, Make sure elasticsearch is port-forwarded.

You have two options:

- Follow the Elasticsearch deployment guide and run:

  ```shell
  $ PASSWORD=$(kubectl get secret -n prod elasticsearch-cluster-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')
  $ curl -u "elastic:$PASSWORD" -k "https://localhost:9200/metrics-system.cpu-*/_search"
  {"took":4,"timed_out":false,"_shards":{"total":0,"successful":0,"skipped":0,"failed":0},"hits":{"total":{"value":0,"relation":"eq"},"max_score":0.0,"hits":[]}}
  ```

- Follow the Kibana deployment guide, log in and go to **Kibana > Discover**.

###  Elasticsearch beat

**Deploy a Elasticsearch beat**

Apply the following specification to deploy Filebeat and collect the logs of all containers running in the Kubernetes cluster. ECK automatically configures the secured connection to an Elasticsearch cluster named `elasticsearch-cluster` that you created previously.

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: elasticsearch-beat-sample
spec:
  components:
    - type: elasticsearch-beat
      name: elasticsearch-beat
      properties:
        type: filebeat
        version: 8.6.2
        elasticsearchRef:
          name: elasticsearch-cluster
        config:
          filebeat.inputs:
            - type: container
              paths:
                - /var/log/containers/*.log
        daemonSet:
          podTemplate:
            spec:
              dnsPolicy: ClusterFirstWithHostNet
              hostNetwork: true
              securityContext:
                runAsUser: 0
              containers:
                - name: filebeat
                  volumeMounts:
                    - name: varlogcontainers
                      mountPath: /var/log/containers
                    - name: varlogpods
                      mountPath: /var/log/pods
                    - name: varlibdockercontainers
                      mountPath: /var/lib/docker/containers
              volumes:
                - name: varlogcontainers
                  hostPath:
                    path: /var/log/containers
                - name: varlogpods
                  hostPath:
                    path: /var/log/pods
                - name: varlibdockercontainers
                  hostPath:
                    path: /var/lib/docker/containers
```

Monitor Beats.

Retrieve details about the Filebeat.

```shell
kubectl get beat -n prod
NAME                 HEALTH   AVAILABLE   EXPECTED   TYPE       VERSION   AGE
elasticsearch-beat   green    1           1          filebeat   8.6.2     21m
```

List all the Pods belonging to a given Beat.

```shell
$ kubectl get pods -n prod | grep beat
elasticsearch-beat-beat-filebeat-wglvg   1/1     Running   0             26m
```

Access logs for the Pod.

```shell
$ kubectl logs -f elasticsearch-beat-beat-filebeat-wglvg -n prod
```

Access logs ingested by Filebeat, Make sure Elasticsearch service is still port-forwarded.

You have two options:

- Follow the Elasticsearch deployment guide and run:

  ```shell
  $ PASSWORD=$(kubectl get secret -n prod elasticsearch-cluster-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')
  $ curl -u "elastic:$PASSWORD" -k "https://localhost:9200/filebeat-*/_search"
  ```

- Follow the Kibana deployment guide, log in and go to **Kibana > Discover**.

###  Elasticsearch apm-server

**Deploy a Elasticsearch apm-server**

Managing both APM Server and Elasticsearch by ECK allows a smooth and secured integration between the two. The output configuration of the APM Server is setup automatically to establish a trust relationship with Elasticsearch.

- To deploy an APM Server and connect it to the cluster you created as the `elasticsearch-cluster`, apply the following specification:

  ```yaml
  apiVersion: core.oam.dev/v1beta1
  kind: Application
  metadata:
    name: elasticsearch-apm-server-sample
  spec:
    components:
      - type: elasticsearch-apm-server
        name: elasticsearch-apm-server
        properties:
          version: 8.6.2
          count: 1
          elasticsearchRef:
            name: elasticsearch-cluster
  ```

By default elasticsearchRef targets all nodes in your Elasticsearch cluster. If you want to direct traffic to specific nodes of your cluster, refer to Traffic Splitting https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-traffic-splitting.html for more information and examples.

Monitor APM Server deployment.

You can retrieve details about the APM Server instance:

```shell
$ kubectl get apmservers -n prod
NAME                       HEALTH   NODES   VERSION   AGE
elasticsearch-apm-server   green    1       8.6.2     6m2s
```

And you can list all the Pods belonging to a given deployment:

```shell
$ kubectl get pods -n prod | grep apm
elasticsearch-apm-server-apm-server-6967d664d5-qb7hh   1/1     Running   0              6m37s
```

###  Elasticsearch enterprise search

**Deploy a Elasticsearch enterprise search**

Apply the following specification to deploy Enterprise Search. ECK automatically configures the secured connection to an Elasticsearch cluster named `elasticsearch-cluster` that you created previously.

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: elasticsearch-enterprise-search-sample
spec:
  components:
    - type: elasticsearch-enterprise-search
      name: elasticsearch-enterprise-search
      properties:
        version: 8.6.2
        count: 1
        elasticsearchRef:
          name: elasticsearch-cluster
        podTemplate:
          spec:
            containers:
              - name: enterprise-search
                resources:
                  requests:
                    cpu: 1
                    memory: 512Mi
                  limits:
                    cpu: 1
                    memory: 512Mi
```

Monitor the Enterprise Search deployment.

Retrieve details about the Enterprise Search deployment:

```shell
$ kubectl get enterprisesearch -n prod
NAME                            HEALTH    NODES    VERSION   AGE
enterprise-search-quickstart    green     1        8.6.2      8m
```

List all the Pods belonging to a given deployment:

```shell
$ kubectl get pods -n prod | grep enterprise-search
NAME                                                   READY   STATUS    RESTARTS   AGE
elasticsearch-enterprise-search-ent-7d46f867b-w5v4q    1/1     Running   0          2m50s
```

Access Enterprise Search.

A ClusterIP Service is automatically created for the deployment, and can be used to access the Enterprise Search API from within the Kubernetes cluster:

```shell
$ kubectl get svc -n prod | grep enterprise-search
elasticsearch-enterprise-search-ent-http   ClusterIP   10.108.157.221   <none>        3002/TCP   21m
```

Use kubectl port-forward to access Enterprise Search from your local browser:

```shell
$ kubectl port-forward -n prod service/elasticsearch-enterprise-search-ent-http 3002
```

Open https://localhost:3002 in your browser.

Login as the elastic user created with the Elasticsearch cluster. Its password can be obtained with:

```shell
$ kubectl get secret -n prod elasticsearch-cluster-es-elastic-user -o go-template='{{.data.elastic | base64decode}}'
```

**Deploy enterprise-search configured kibana**

Access the Enterprise Search UI in Kibana:

Starting with version 7.14.0, the Enterprise Search UI is accessible in Kibana.

Apply the following specification to deploy Kibana, configured to connect to both Elasticsearch and Enterprise Search:

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
        enterpriseSearchRef:
          name: elasticsearch-enterprise-search
```

Use kubectl port-forward to access Kibana from your local system.

```shell
$ kubectl port-forward service/quickstart-kb-http 5601
```

Open https://localhost:5601 in your browser and navigate to the Enterprise Search UI.

For more, Please visit on the website https://www.elastic.co/.