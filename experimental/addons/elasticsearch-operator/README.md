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
      traits:
        - type: elasticsearch-cluster-expose
          properties:
            type: "NodePort"
```

Get an overview of the current Elasticsearch clusters in the Kubernetes cluster, including health, version and number of nodes:

```shell
$ kubectl get elasticsearch -n prod
NAME                     HEALTH    NODES     VERSION   PHASE         AGE
elasticsearch-cluster    green     1         8.6.2     Ready         1m
```

*Note: When you create the cluster, there is no HEALTH status and the PHASE is empty. After a while, the PHASE turns into Ready, and HEALTH becomes green.*

**Request Elasticsearch access**

A NodePort Service is got created for your cluster by trait block of above YAML:

```shell
$ kubectl get -n prod service | grep elasticsearch-cluster-expose
NAME                                                          TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
elasticsearch-cluster-elasticsearch-cluster-expose-d857b75d   NodePort    10.99.242.232   <none>        9200:31070/TCP   53m```

-   Get the credentials.

    A default user named elastic is automatically created with the password stored in a Kubernetes secret:

    ```shell
    PASSWORD=$(kubectl get secret -n prod elasticsearch-cluster-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')
    ```

-   Request the Elasticsearch endpoint if using minikube.

    ```shell
    # Get URL
    $ eckURL=$(minikube service -n prod elasticsearch-cluster-elasticsearch-cluster-expose-d857b75d --url | sed "s/http/https/")
    ```

    Visit on the obtained url.

    ```shell
    $ curl -u "elastic:$PASSWORD" -k $eckURL
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
      traits:
        - type: kibana-expose
          properties:
            type: "NodePort"
```

Monitor Kibana health and creation progress.

```shell
$ kubectl get kibana -n prod
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

Login as the elastic user by visiting https://localhost:5601 in your browser.

Otherwise, Use NodePort service created by the above YAML trait block.

```shell
# Check service name
$ kubectl get service -n prod | grep kibana-expose
kibana-kibana-expose-759b4f896                                NodePort    10.105.77.93    <none>        5601:31889/TCP   16m

# Check URL
$ minikube service kibana-kibana-expose-759b4f896 -n prod --url
http://192.168.49.2:31889
```

Visit on the shell printed URL by replacing `http` with `https` in your browser and Login as the elastic user.

Get credentials: 

```shell
# Get password
kubectl get secret -n prod elasticsearch-cluster-es-elastic-user -o=jsonpath='{.data.elastic}' | base64 --decode; echo
```

###  Elasticsearch agent

**Deploy a Elasticsearch agent**

Apply the following specification to deploy Elastic Agent with the System metrics integration to harvest CPU metrics from the Agent Pods. ECK automatically configures the secured connection to an Elasticsearch cluster named `elasticsearch-cluster` that you created previously.

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: elasticsearch-cluster-sample-with-agent
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
      traits:
        - type: elasticsearch-agent
          properties:
            version: 8.6.1
            elasticsearchRefs:
              - name: elasticsearch-cluster
            daemonSet:
              podTemplate:
                spec:
                  containers:
                    - name: agent
                      securityContext:
                        runAsUser: 0
            config:
              id: 488e0b80-3634-11eb-8208-57893829af4e
              revision: 2
              agent:
                monitoring:
                  enabled: true
                  use_output: default
                  logs: true
                  metrics: true
              inputs:
                - id: 4917ade0-3634-11eb-8208-57893829af4e
                  name: system-1
                  revision: 1
                  type: system/metrics
                  use_output: default
                  meta:
                    package:
                      name: system
                      version: 8.6.1
                  data_stream:
                    namespace: prod
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
                    - id: system/metrics-system.diskio
                      data_stream:
                        dataset: system.diskio
                        type: metrics
                      metricsets:
                        - diskio
                      diskio.include_devices: null
                      period: 10s
                    - id: system/metrics-system.filesystem
                      data_stream:
                        dataset: system.filesystem
                        type: metrics
                      metricsets:
                        - filesystem
                      period: 1m
                      processors:
                        - drop_event.when.regexp:
                            system.filesystem.mount_point: ^/(sys|cgroup|proc|dev|etc|host|lib|snap)($|/)
                    - id: system/metrics-system.fsstat
                      data_stream:
                        dataset: system.fsstat
                        type: metrics
                      metricsets:
                        - fsstat
                      period: 1m
                      processors:
                        - drop_event.when.regexp:
                            system.fsstat.mount_point: ^/(sys|cgroup|proc|dev|etc|host|lib|snap)($|/)
                    - id: system/metrics-system.load
                      data_stream:
                        dataset: system.load
                        type: metrics
                      metricsets:
                        - load
                      period: 10s
                    - id: system/metrics-system.memory
                      data_stream:
                        dataset: system.memory
                        type: metrics
                      metricsets:
                        - memory
                      period: 10s
                    - id: system/metrics-system.network
                      data_stream:
                        dataset: system.network
                        type: metrics
                      metricsets:
                        - network
                      period: 10s
                      network.interfaces: null
                    - id: system/metrics-system.process
                      data_stream:
                        dataset: system.process
                        type: metrics
                      metricsets:
                        - process
                      period: 10s
                      process.include_top_n.by_cpu: 5
                      process.include_top_n.by_memory: 5
                      process.cmdline.cache.enabled: true
                      process.cgroups.enabled: false
                      process.include_cpu_ticks: false
                      processes:
                        - .*
                    - id: system/metrics-system.process_summary
                      data_stream:
                        dataset: system.process_summary
                        type: metrics
                      metricsets:
                        - process_summary
                      period: 10s
                    - id: system/metrics-system.socket_summary
                      data_stream:
                        dataset: system.socket_summary
                        type: metrics
                      metricsets:
                        - socket_summary
                      period: 10s
                    - id: system/metrics-system.uptime
                      data_stream:
                        dataset: system.uptime
                        type: metrics
                      metricsets:
                        - uptime
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
$ kubectl get pods -n prod | grep agent
NAME                                 READY   STATUS    RESTARTS   AGE
elasticsearch-cluster-agent-rgh2f    1/1     Running   0          114s
```

Access logs for one of the Pods.

```shell
$ kubectl logs -n prod -f elasticsearch-cluster-agent-rgh2f
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
  name: elasticsearch-cluster-sample-with-beat
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
      traits: 
        - type: elasticsearch-beat
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

- Follow the Kibana deployment guide to install kibana, And log in and go to **Kibana > Discover** then create a dataview in kibana for `filebeat-8.6.2` index, You will be able to view the entire logs related to above created `filebeat` type elasticsearch-beat.

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
      traits:
        - type: kibana-expose
          properties:
            type: "NodePort"
```

Use kubectl port-forward to access Kibana from your local system.

```shell
$ kubectl port-forward service/quickstart-kb-http 5601
```

Otherwise, Use NodePort service created by the above YAML trait block.

```shell
# Check service name
$ kubectl get service -n prod | grep kibana-expose
kibana-kibana-expose-759b4f896                                NodePort    10.105.77.93    <none>        5601:31889/TCP   16m

# Check URL
$ minikube service kibana-kibana-expose-759b4f896 -n prod --url
http://192.168.49.2:31889
```

Visit on the shell printed URL by replacing `http` with `https` in your browser and navigate to the Enterprise Search UI.

For more, Please visit on the website https://www.elastic.co/.