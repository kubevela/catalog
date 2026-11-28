---
title: kafka-cluster
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/kafka-operator/versions.json';

<AddonVersion data={versions} current="1.0.0" page="definitions/kafka-cluster" />

<!-- Generated from the definition. -->

kafka cluster component

**Type:** component. **From:** the [kafka-operator](/addons/catalog/kafka-operator/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>kafkaExporter</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Configure kafka exporter.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>clusterCa</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Configuration of the cluster certificate authority.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>clientsCa</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Configuration of the clients certificate authority.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>cruiseControl</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Configuration for Cruise Control deployment. Deploys a Cruise Control instance when specified.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>jmxTrans</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">The jmxTrans property has been deprecated. JMXTrans is deprecated and will be removed in Strimzi 0.35.0 Configuration for JmxTrans. When the property is present a JmxTrans deployment is created for gathering JMX metrics from each Kafka broker. For more information see https://github.com/jmxtrans/jmxtrans.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>maintenanceTimeWindows</code> <span className="addon-param-type">(null or list)</span></div><div className="addon-param-desc">A list of time windows for maintenance tasks (that is, certificates renewal). Each time window is defined by a cron expression.</div></div>

<details>
<summary><code>kafka</code> (22) configure kafka cluster.</summary>

<div className="addon-param"><div className="addon-param-head"><code>version</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>3.3.2</code></span></div><div className="addon-param-desc">The kafka broker version.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>replicas</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>3</code></span></div><div className="addon-param-desc">The number of pods in the cluster.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>listeners</code> <span className="addon-param-type">list</span></div><div className="addon-param-desc">Configures listeners of Kafka brokers.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>image</code> <span className="addon-param-type">(null or string)</span></div><div className="addon-param-desc">The docker image for the pods. The default value depends on the configured Kafka.spec.kafka.version.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>authorization</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Authorization configuration for Kafka brokers. The type depends on the value of the authorization.type property within the given object, which must be one of [simple, opa, keycloak, custom].</div></div>
<div className="addon-param"><div className="addon-param-head"><code>brokerRackInitImage</code> <span className="addon-param-type">(null or string)</span></div><div className="addon-param-desc">The image of the init container used for initializing the broker.rack.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>rack</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Configuration of the broker.rack broker config.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>livenessProbe</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Pod liveness checking.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>readinessProbe</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Pod readiness checking.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>jvmOptions</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">JVM Options for pods.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>jmxOptions</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">JMX Options for Kafka brokers.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>resources</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">CPU and memory resources to reserve. For more information, see the https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#resourcerequirements-v1-core</div></div>
<div className="addon-param"><div className="addon-param-head"><code>metricsConfig</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Metrics configuration. The type depends on the value of the metricsConfig.type property within the given object, which must be one of [jmxPrometheusExporter].</div></div>
<div className="addon-param"><div className="addon-param-head"><code>logging</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Logging configuration for Kafka. The type depends on the value of the logging.type property within the given object, which must be one of [inline, external].</div></div>
<div className="addon-param"><div className="addon-param-head"><code>template</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Template for Kafka cluster resources. The template allows users to specify how the StatefulSet, Pods, and Services are generated.</div></div>

<details>
<summary><code>config</code> (6) Kafka broker config properties with the some prefixes cannot be set, so for that use config to set. for more https://strimzi.io/docs/operators/latest/configuring.html#type-KafkaClusterSpec-schema-reference</summary>

<div className="addon-param"><div className="addon-param-head"><code>offsets.topic.replication.factor</code> <span className="addon-param-type">int</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>transaction.state.log.replication.factor</code> <span className="addon-param-type">int</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>transaction.state.log.min.isr</code> <span className="addon-param-type">int</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>default.replication.factor</code> <span className="addon-param-type">int</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>min.insync.replicas</code> <span className="addon-param-type">int</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>inter.broker.protocol.version</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>

</details>


<details>
<summary><code>storage</code> (1) Storage configuration (disk). Cannot be updated. The type depends on the value of the storage.type property within the given object, which must be one of [ephemeral, persistent-claim, jbod].</summary>

<div className="addon-param"><div className="addon-param-head"><code>type</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>

</details>


</details>


<details>
<summary><code>zookeeper</code> (12) configure zookeeper.</summary>

<div className="addon-param"><div className="addon-param-head"><code>replicas</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>3</code></span></div><div className="addon-param-desc">The number of pods in the cluster.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>image</code> <span className="addon-param-type">(null or string)</span></div><div className="addon-param-desc">The docker image for the pods.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>config</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">The ZooKeeper broker config. Properties with the some prefixes cannot be set, so for that use config to set. for more https://strimzi.io/docs/operators/latest/configuring.html#type-ZookeeperClusterSpec-schema-reference</div></div>
<div className="addon-param"><div className="addon-param-head"><code>livenessProbe</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Pod liveness checking.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>readinessProbe</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Pod readiness checking.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>jvmOptions</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">JVM Options for pods.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>jmxOptions</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">JMX Options for Zookeeper nodes.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>resources</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">CCPU and memory resources to reserve. For more information, see the external documentation for core/v1 resourcerequirements.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>metricsConfig</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Metrics configuration. The type depends on the value of the metricsConfig.type property within the given object, which must be one of [jmxPrometheusExporter].</div></div>
<div className="addon-param"><div className="addon-param-head"><code>logging</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Logging configuration for ZooKeeper. The type depends on the value of the logging.type property within the given object, which must be one of [inline, external].</div></div>
<div className="addon-param"><div className="addon-param-head"><code>template</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Template for ZooKeeper cluster resources. The template allows users to specify how the StatefulSet, Pods, and Services are generated.</div></div>

<details>
<summary><code>storage</code> (1) Storage configuration (disk). Cannot be updated. The type depends on the value of the storage.type property within the given object, which must be one of [ephemeral, persistent-claim].</summary>

<div className="addon-param"><div className="addon-param-head"><code>type</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>

</details>


</details>


<details>
<summary><code>entityOperator</code> (4) configure entity operator.</summary>

<div className="addon-param"><div className="addon-param-head"><code>topicOperator</code> <span className="addon-param-type">object</span> <span className="addon-param-default">default <code>&#123;&#125;</code></span></div><div className="addon-param-desc">Configuration of the Topic Operator.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>userOperator</code> <span className="addon-param-type">object</span> <span className="addon-param-default">default <code>&#123;&#125;</code></span></div><div className="addon-param-desc">Configuration of the User Operator.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>tlsSidecar</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">TLS sidecar configuration.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>template</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Template for Entity Operator resources. The template allows users to specify how a Deployment and Pod is generated.</div></div>

</details>

