---
title: Parameters
sidebar_position: 2
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/grafana/versions.json';

<AddonVersion data={versions} current="0.4.4" page="parameters" />

<!-- Generated from the addon's parameter.cue. -->

Set them when you enable the addon, `vela addon enable grafana <name>=<value>`, or in VelaUX's addon form.

<div className="addon-param"><div className="addon-param-head"><code>install</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>true</code></span></div><div className="addon-param-desc">You should create a grafana config and provide the name if want't install the grafana and only init the dashboards.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>grafanaName</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>default</code></span></div><div className="addon-param-desc">The grafana config name.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>configName</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>grafana-vela</code></span></div><div className="addon-param-desc">The config name to register</div></div>
<div className="addon-param"><div className="addon-param-head"><code>kubeEndpoint</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">The endpoint of the Kube APIServer could be connected by Grafana. You need to create the RoleBinding for the grafana ServiceAccount.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>namespace</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>o11y-system</code></span></div><div className="addon-param-desc">The namespace of the grafana to be installed</div></div>
<div className="addon-param"><div className="addon-param-head"><code>clusters</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">The clusters to install</div></div>
<div className="addon-param"><div className="addon-param-head"><code>image</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>grafana/grafana:8.5.3</code></span></div><div className="addon-param-desc">Specify the image of kube-state-metrics</div></div>
<div className="addon-param"><div className="addon-param-head"><code>imagePullPolicy</code> <span className="addon-param-type">IfNotPresent or Never or Always</span> <span className="addon-param-default">default <code>IfNotPresent</code></span></div><div className="addon-param-desc">Specify the imagePullPolicy of the image</div></div>
<div className="addon-param"><div className="addon-param-head"><code>cpu</code> <span className="addon-param-type">number</span> <span className="addon-param-default">default <code>0.5</code></span></div><div className="addon-param-desc">Specify the number of CPU units</div></div>
<div className="addon-param"><div className="addon-param-head"><code>memory</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>1024Mi</code></span></div><div className="addon-param-desc">Specifies the attributes of the memory resource required for the container.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>serviceType</code> <span className="addon-param-type">ClusterIP or NodePort or LoadBalancer</span> <span className="addon-param-default">default <code>ClusterIP</code></span></div><div className="addon-param-desc">Specify the service type for expose prometheus server.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>storage</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Specify the storage size to use. If empty, emptyDir will be used. Otherwise pvc will be used.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>storageClassName</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Specify the storage class to use.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>adminUser</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>admin</code></span></div><div className="addon-param-desc">Specify the admin user for grafana</div></div>
<div className="addon-param"><div className="addon-param-head"><code>adminPassword</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>kubevela</code></span></div><div className="addon-param-desc">Specify the admin password for grafana</div></div>
