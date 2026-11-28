---
title: kafka-connect
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/kafka-operator/versions.json';

<AddonVersion data={versions} current="1.0.0" page="definitions/kafka-connect" />

<!-- Generated from the definition. -->

kafka connect component

**Type:** component. **From:** the [kafka-operator](/addons/catalog/kafka-operator/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>version</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>3.3.2</code></span></div><div className="addon-param-desc">The Kafka Connect version. Defaults to 3.3.2. Consult the user documentation to understand the process required to upgrade or downgrade the version.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>replicas</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>1</code></span></div><div className="addon-param-desc">The number of pods in the Kafka Connect group.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>bootstrapServers</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>kafka-cluster-kafka-bootstrap:9093</code></span></div><div className="addon-param-desc">Bootstrap servers to connect to. This should be given as a comma separated list of &lt;hostname&gt;:_&lt;port&gt;_ pairs.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>build</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Configures how the Connect container image should be built. Optional.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>metricsConfig</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Metrics configuration. The type depends on the value of the metricsConfig.type property within the given object, which must be one of [jmxPrometheusExporter].</div></div>
<div className="addon-param"><div className="addon-param-head"><code>image</code> <span className="addon-param-type">(null or string)</span></div><div className="addon-param-desc">The docker image for the pods.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>authentication</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Authentication configuration for Kafka Connect. The type depends on the value of the authentication.type property within the given object, which must be one of [tls, scram-sha-256, scram-sha-512, plain, oauth].</div></div>
<div className="addon-param"><div className="addon-param-head"><code>livenessProbe</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Pod liveness checking.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>readinessProbe</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Pod readiness checking.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>jvmOptions</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">JVM Options for pods.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>jmxOptions</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">JMX Options for Kafka brokers.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>resources</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">The maximum limits for CPU and memory resources and the requested initial resources. For more information, see the external documentation for core/v1 resourcerequirements.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>logging</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Logging configuration for Kafka. The type depends on the value of the logging.type property within the given object, which must be one of [inline, external].</div></div>
<div className="addon-param"><div className="addon-param-head"><code>clientRackInitImage</code> <span className="addon-param-type">(null or string)</span></div><div className="addon-param-desc">The image of the init container used for initializing the client.rack.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>rack</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Configuration of the node label which will be used as the client.rack consumer configuration.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>tracing</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">The configuration of tracing in Kafka Connect. The type depends on the value of the tracing.type property within the given object, which must be one of [jaeger, opentelemetry].</div></div>
<div className="addon-param"><div className="addon-param-head"><code>template</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Template for Kafka Connect and Kafka Mirror Maker 2 resources. The template allows users to specify how the Deployment, Pods and Service are generated.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>externalConfiguration</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Pass data from Secrets or ConfigMaps to the Kafka Connect pods and use them to configure connectors.</div></div>

<details>
<summary><code>tls</code> (1) TLS configuration.</summary>

<div className="addon-param"><div className="addon-param-head"><code>trustedCertificates</code> <span className="addon-param-type">list</span></div><div className="addon-param-desc"></div></div>

</details>


<details>
<summary><code>config</code> (7) The Kafka Connect configuration. Properties with the following prefixes cannot be set: ssl., sasl., security., listeners, plugin.path, rest., bootstrap.servers, consumer.interceptor.classes, producer.interceptor.classes (with the exception of: ssl.endpoint.identification.algorithm, ssl.cipher.suites, ssl.protocol, ssl.enabled.protocols).</summary>

<div className="addon-param"><div className="addon-param-head"><code>group.id</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>offset.storage.topic</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>config.storage.topic</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>status.storage.topic</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>config.storage.replication.factor</code> <span className="addon-param-type">int</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>offset.storage.replication.factor</code> <span className="addon-param-type">int</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>status.storage.replication.factor</code> <span className="addon-param-type">int</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>

</details>

