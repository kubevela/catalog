---
title: kafka-bridge
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/kafka-operator/versions.json';

<AddonVersion data={versions} current="1.0.0" page="definitions/kafka-bridge" />

<!-- Generated from the definition. -->

kafka bridge component

**Type:** component. **From:** the [kafka-operator](/addons/catalog/kafka-operator/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>replicas</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>1</code></span></div><div className="addon-param-desc">The number of pods in the Deployment.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>image</code> <span className="addon-param-type">(null or string)</span></div><div className="addon-param-desc">The docker image for the pods.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>bootstrapServers</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>kafka-cluster-kafka-bootstrap:9092</code></span></div><div className="addon-param-desc">A list of host:port pairs for establishing the initial connection to the Kafka cluster.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>tls</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">TLS configuration for connecting Kafka Bridge to the cluster.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>authentication</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Authentication configuration for connecting to the cluster. The type depends on the value of the authentication.type property within the given object, which must be one of [tls, scram-sha-256, scram-sha-512, plain, oauth].</div></div>
<div className="addon-param"><div className="addon-param-head"><code>adminClient</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Kafka AdminClient related configuration.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>consumer</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Kafka consumer related configuration.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>producer</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Kafka producer related configuration.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>resources</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">CPU and memory resources to reserve. For more information, see the external documentation for core/v1 resourcerequirements.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>jvmOptions</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Currently not supported JVM Options for pods.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>logging</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Logging configuration for Kafka Bridge. The type depends on the value of the logging.type property within the given object, which must be one of [inline, external].</div></div>
<div className="addon-param"><div className="addon-param-head"><code>clientRackInitImage</code> <span className="addon-param-type">(null or string)</span></div><div className="addon-param-desc">The image of the init container used for initializing the client.rack.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>rack</code> <span className="addon-param-type">(null or string)</span></div><div className="addon-param-desc">Configuration of the node label which will be used as the client.rack consumer configuration.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>enableMetrics</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>false</code></span></div><div className="addon-param-desc">Enable the metrics for the Kafka Bridge. Default is false.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>livenessProbe</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Pod liveness checking.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>readinessProbe</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Pod readiness checking.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>template</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Template for Kafka Bridge resources. The template allows users to specify how a Deployment and Pod is generated.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>tracing</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">The configuration of tracing in Kafka Bridge. The type depends on the value of the tracing.type property within the given object, which must be one of [jaeger, opentelemetry].</div></div>

<details>
<summary><code>http</code> (1) The HTTP related configuration.</summary>

<div className="addon-param"><div className="addon-param-head"><code>port</code> <span className="addon-param-type">int</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>

</details>

