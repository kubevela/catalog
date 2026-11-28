---
title: flink-cluster
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/flink-kubernetes-operator/versions.json';

<AddonVersion data={versions} current="1.3.2" page="definitions/flink-cluster" />

<!-- Generated from the definition. -->

Flink Component.

**Type:** component. **From:** the [flink-kubernetes-operator](/addons/catalog/flink-kubernetes-operator/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>nots</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Specify the taskmanager.numberOfTaskSlots, e.g "2"</div></div>
<div className="addon-param"><div className="addon-param-head"><code>flinkVersion</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Specify the flink cluster version, e.g "v1_14"</div></div>
<div className="addon-param"><div className="addon-param-head"><code>image</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Specify the image for flink cluster to run, e.g "flink:latest"</div></div>
<div className="addon-param"><div className="addon-param-head"><code>name</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Specify the flink cluster name</div></div>
<div className="addon-param"><div className="addon-param-head"><code>namespace</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Specify the namespace for flink cluster to install</div></div>
<div className="addon-param"><div className="addon-param-head"><code>jarURI</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Specify the uri for the jar of the flink cluster job, e.g "local:///opt/flink/examples/streaming/StateMachineExample.jar"</div></div>
<div className="addon-param"><div className="addon-param-head"><code>parallelism</code> <span className="addon-param-type">int</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Specify the parallelism of the flink cluster job, e.g 2</div></div>
<div className="addon-param"><div className="addon-param-head"><code>upgradeMode</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Specify the upgradeMode of the flink cluster job, e.g "stateless"</div></div>
<div className="addon-param"><div className="addon-param-head"><code>replicas</code> <span className="addon-param-type">int</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Specify the replicas of the flink cluster jobManager, e.g 1</div></div>
<div className="addon-param"><div className="addon-param-head"><code>jmcpu</code> <span className="addon-param-type">int</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Specify the cpu of the flink cluster jobManager, e.g 1</div></div>
<div className="addon-param"><div className="addon-param-head"><code>jmmem</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Specify the memory of the flink cluster jobManager, e.g "1024m"</div></div>
<div className="addon-param"><div className="addon-param-head"><code>tmcpu</code> <span className="addon-param-type">int</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Specify the cpu of the flink cluster taskManager, e.g 1</div></div>
<div className="addon-param"><div className="addon-param-head"><code>tmmem</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Specify the memory of the flink cluster taskManager, e.g "1024m"</div></div>
