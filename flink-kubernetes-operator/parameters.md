---
title: Parameters
sidebar_position: 2
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/flink-kubernetes-operator/versions.json';

<AddonVersion data={versions} current="1.4.0" page="parameters" />

<!-- Generated from the addon's parameter.cue. -->

Set them when you enable the addon, `vela addon enable flink-kubernetes-operator <name>=<value>`, or in VelaUX's addon form.

<div className="addon-param"><div className="addon-param-head"><code>clusters</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Deploy to specified clusters. Leave empty to deploy to all clusters.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>namespace</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>flink-operator</code></span></div><div className="addon-param-desc">Namespace to deploy to</div></div>
<div className="addon-param"><div className="addon-param-head"><code>createWebhook</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>false</code></span></div><div className="addon-param-desc">Specify if create  the webhook or not</div></div>
<div className="addon-param"><div className="addon-param-head"><code>imageRepository</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>apache/flink-kubernetes-operator</code></span></div><div className="addon-param-desc">Specify the image repository</div></div>
<div className="addon-param"><div className="addon-param-head"><code>imageTag</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>latest</code></span></div><div className="addon-param-desc">Specify the image tag</div></div>
<div className="addon-param"><div className="addon-param-head"><code>createJobServiceAccount</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>false</code></span></div><div className="addon-param-desc">Specify if create the sa for job or not</div></div>
<div className="addon-param"><div className="addon-param-head"><code>upgradeCRD</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>false</code></span></div><div className="addon-param-desc">Specify if upgrade the CRDs when upgrading flink-kubernetes-operator or not</div></div>
<div className="addon-param"><div className="addon-param-head"><code>flinkOperatorVersion</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>1.9.0</code></span></div><div className="addon-param-desc">Specify the flink operator version</div></div>
