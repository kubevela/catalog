---
title: Parameters
sidebar_position: 2
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/prometheus-server/versions.json';

<AddonVersion data={versions} current="0.3.3" page="parameters" />

<!-- Generated from the addon's parameter.cue. -->

Set them when you enable the addon, `vela addon enable prometheus-server <name>=<value>`, or in VelaUX's addon form.

<div className="addon-param"><div className="addon-param-head"><code>namespace</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>o11y-system</code></span></div><div className="addon-param-desc">The namespace of the prometheus-server to be installed</div></div>
<div className="addon-param"><div className="addon-param-head"><code>clusters</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">The clusters to install</div></div>
<div className="addon-param"><div className="addon-param-head"><code>image</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>quay.io/prometheus/prometheus:v2.34.0</code></span></div><div className="addon-param-desc">Specify the image of prometheus-server</div></div>
<div className="addon-param"><div className="addon-param-head"><code>imagePullPolicy</code> <span className="addon-param-type">IfNotPresent or Never or Always</span> <span className="addon-param-default">default <code>IfNotPresent</code></span></div><div className="addon-param-desc">Specify the imagePullPolicy of the image</div></div>
<div className="addon-param"><div className="addon-param-head"><code>cpu</code> <span className="addon-param-type">number</span> <span className="addon-param-default">default <code>0.5</code></span></div><div className="addon-param-desc">Specify the number of CPU units</div></div>
<div className="addon-param"><div className="addon-param-head"><code>memory</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>1024Mi</code></span></div><div className="addon-param-desc">Specifies the attributes of the memory resource required for the container.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>serviceType</code> <span className="addon-param-type">ClusterIP or NodePort or LoadBalancer or </span> <span className="addon-param-default">default <code>ClusterIP</code></span></div><div className="addon-param-desc">Specify the service type for expose prometheus server. If empty, it will be not exposed.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>storage</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Specify the storage size to use. If empty, emptyDir will be used. Otherwise pvc will be used.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>storageClassName</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Specify the storage class to use.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>customConfig</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">If specified, the prometheus server will mount the config map as the additional config.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>thanos</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>false</code></span></div><div className="addon-param-desc">If specified, thanos sidecar will be attached and ports will be exposed</div></div>
<div className="addon-param"><div className="addon-param-head"><code>scrapeInterval</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>15s</code></span></div><div className="addon-param-desc">The interval for scraping pods, services, endpoints.</div></div>
