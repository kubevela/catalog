---
title: Parameters
sidebar_position: 2
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/loki/versions.json';

<AddonVersion data={versions} current="0.3.2" page="parameters" />

<!-- Generated from the addon's parameter.cue. -->

Set them when you enable the addon, `vela addon enable loki <name>=<value>`, or in VelaUX's addon form.

<div className="addon-param"><div className="addon-param-head"><code>namespace</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>o11y-system</code></span></div><div className="addon-param-desc">The namespace of the loki to be installed</div></div>
<div className="addon-param"><div className="addon-param-head"><code>clusters</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">The clusters to install</div></div>
<div className="addon-param"><div className="addon-param-head"><code>image</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>grafana/loki:2.6.1</code></span></div><div className="addon-param-desc">Specify the image of loki</div></div>
<div className="addon-param"><div className="addon-param-head"><code>imagePullPolicy</code> <span className="addon-param-type">IfNotPresent or Never or Always</span> <span className="addon-param-default">default <code>IfNotPresent</code></span></div><div className="addon-param-desc">Specify the imagePullPolicy of the image</div></div>
<div className="addon-param"><div className="addon-param-head"><code>serviceType</code> <span className="addon-param-type">ClusterIP or NodePort or LoadBalancer or </span> <span className="addon-param-default">default <code>ClusterIP</code></span></div><div className="addon-param-desc">Specify the service type for expose loki. If empty, it will be not exposed.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>storage</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Specify the storage size to use. If empty, emptyDir will be used. Otherwise pvc will be used.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>storageClassName</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Specify the storage class to use.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>agent</code> <span className="addon-param-type">vector or  or promtail</span> <span className="addon-param-default">default <code>vector</code></span></div><div className="addon-param-desc">Specify the type of log agents, if empty, no agent will be installed</div></div>
<div className="addon-param"><div className="addon-param-head"><code>promtailImage</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>grafana/promtail</code></span></div><div className="addon-param-desc">Specify the image of promtail</div></div>
<div className="addon-param"><div className="addon-param-head"><code>vectorImage</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>timberio/vector:0.25.2-distroless-libc</code></span></div><div className="addon-param-desc">Specify the image of vector</div></div>
<div className="addon-param"><div className="addon-param-head"><code>vectorControllerImage</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>oamdev/vector-controller:0.2.2</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>stdout</code> <span className="addon-param-type"> or all</span></div><div className="addon-param-desc">Collect all pods' stdout log</div></div>
<div className="addon-param"><div className="addon-param-head"><code>lokiURL</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">The loki URL for vector agent to sink. If not specified, the in cluster loki endpoint will be used.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>agentOnly</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>false</code></span></div><div className="addon-param-desc">If set to true, only agent will be installed.</div></div>
