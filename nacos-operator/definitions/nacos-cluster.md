---
title: nacos-cluster
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/nacos-operator/versions.json';

<AddonVersion data={versions} current="1.0.0" page="definitions/nacos-cluster" />

<!-- Generated from the definition. -->

nacos cluster component

**Type:** component. **From:** the [nacos-operator](/addons/catalog/nacos-operator/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>affinity</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Affinity is a group of affinity scheduling rules.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>config</code> <span className="addon-param-type">(null or string)</span></div><div className="addon-param-desc">Configuration.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>database</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Configure Database.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>env</code> <span className="addon-param-type">(null or list)</span></div><div className="addon-param-desc">Configure Env.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>image</code> <span className="addon-param-type">(null or string)</span></div><div className="addon-param-desc">Image name.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>imagePullSecrets</code> <span className="addon-param-type">(null or list)</span></div><div className="addon-param-desc">Configure imagePullSecret to pull image secrets.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>k8sWrapper</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Configure k8sWrapper.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>livenessProbe</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Probe describes a health check to be performed against a container to determine whether it is alive or ready to receive traffic.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>mysqlInitImage</code> <span className="addon-param-type">(null or string)</span></div><div className="addon-param-desc">Name of the mysql init image.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>nodeSelector</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Configure nodeSelector.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>readinessProbe</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Probe describes a health check to be performed against a container to determine whether it is alive or ready to receive traffic.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>replicas</code> <span className="addon-param-type">(null or int)</span></div><div className="addon-param-desc">Number of replicas.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>resources</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">VolumeClaimTemplates []v1.PersistentVolumeClaim `json:"volumeClaimTemplates,omitempty" protobuf:"bytes,4,rep,name=volumeClaimTemplates"`.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>tolerations</code> <span className="addon-param-type">(null or list)</span></div><div className="addon-param-desc">Configure tolerations.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>type</code> <span className="addon-param-type">(null or string)</span></div><div className="addon-param-desc">Type.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>volume</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Configure volume.</div></div>
