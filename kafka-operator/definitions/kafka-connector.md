---
title: kafka-connector
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/kafka-operator/versions.json';

<AddonVersion data={versions} current="1.0.0" page="definitions/kafka-connector" />

<!-- Generated from the definition. -->

kafka connect component

**Type:** component. **From:** the [kafka-operator](/addons/catalog/kafka-operator/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>connectCluster</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>kafka-connect</code></span></div><div className="addon-param-desc">Type connect cluster name.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>class</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>org.apache.kafka.connect.file.FileStreamSourceConnector</code></span></div><div className="addon-param-desc">The Class for the Kafka Connector.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>tasksMax</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>1</code></span></div><div className="addon-param-desc">The maximum number of tasks for the Kafka Connector.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>autoRestart</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Automatic restart of connector and tasks configuration.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>pause</code> <span className="addon-param-type">(null or bool)</span> <span className="addon-param-default">default <code>false</code></span></div><div className="addon-param-desc">Whether the connector should be paused.</div></div>

<details>
<summary><code>config</code> (2) The Kafka Connector configuration. The following properties cannot be set: connector.class, tasks.max.</summary>

<div className="addon-param"><div className="addon-param-head"><code>file</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>topic</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>

</details>

