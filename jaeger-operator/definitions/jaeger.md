---
title: jaeger
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/jaeger-operator/versions.json';

<AddonVersion data={versions} current="1.0.0" page="definitions/jaeger" />

<!-- Generated from the definition. -->

jaeger component

**Type:** component. **From:** the [jaeger-operator](/addons/catalog/jaeger-operator/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>affinity</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Configure affinity.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>agent</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Configure agent.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>allInOne</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Configure allInOne.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>annotations</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Configure annotations.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>collector</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Configure collector.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>containerSecurityContext</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Configure containerSecurityContext.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>imagePullPolicy</code> <span className="addon-param-type">(null or string)</span></div><div className="addon-param-desc">Configure imagePullPolicy.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>imagePullSecrets</code> <span className="addon-param-type">(null or list)</span></div><div className="addon-param-desc">Configure imagePullSecrets.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>ingester</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Configure ingester.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>ingress</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Configure ingress.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>labels</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Configure labels.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>livenessProbe</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Configure livenessProbe.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>query</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Configure query.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>resources</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Configure resources.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>sampling</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Configure sampling.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>securityContext</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Configure securityContext.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>serviceAccount</code> <span className="addon-param-type">(null or string)</span></div><div className="addon-param-desc">Configure serviceAccount.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>storage</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Configure storage.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>strategy</code> <span className="addon-param-type">(null or string)</span></div><div className="addon-param-desc">Configure strategy.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>tolerations</code> <span className="addon-param-type">(null or list)</span></div><div className="addon-param-desc">Configure tolerations.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>ui</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Configure ui.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>volumeMounts</code> <span className="addon-param-type">(null or list)</span></div><div className="addon-param-desc">Configure volumeMounts.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>volumes</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Configure volumes.</div></div>
