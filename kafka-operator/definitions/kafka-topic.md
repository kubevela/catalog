---
title: kafka-topic
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/kafka-operator/versions.json';

<AddonVersion data={versions} current="1.0.0" page="definitions/kafka-topic" />

<!-- Generated from the definition. -->

kafka topic component

**Type:** component. **From:** the [kafka-operator](/addons/catalog/kafka-operator/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>cluster</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>kafka-cluster</code></span></div><div className="addon-param-desc">Type cluster name.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>partitions</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>10</code></span></div><div className="addon-param-desc">The number of partitions the topic should have. This cannot be decreased after topic creation. It can be increased after topic creation, but it is important to understand the consequences that has, especially for topics with semantic partitioning. When absent this will</div></div>
<div className="addon-param"><div className="addon-param-head"><code>replicas</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>3</code></span></div><div className="addon-param-desc">The number of replicas the topic should have. When absent this will</div></div>
<div className="addon-param"><div className="addon-param-head"><code>topicName</code> <span className="addon-param-type">(null or string)</span></div><div className="addon-param-desc">The name of the topic. When absent this will default to the metadata.name of the topic. It is recommended to not set this unless the topic name is not a valid Kubernetes resource name.</div></div>

<details>
<summary><code>config</code> (2) The topic configuration.</summary>

<div className="addon-param"><div className="addon-param-head"><code>retention.ms</code> <span className="addon-param-type">int</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>segment.bytes</code> <span className="addon-param-type">int</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>

</details>

