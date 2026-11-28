---
title: sample-app
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/sample/versions.json';

<AddonVersion data={versions} current="1.0.0" page="definitions/sample-app" />

<!-- Generated from the definition. -->

Runs the sample app as a Deployment.

**Type:** component. **From:** the [sample](/addons/catalog/sample/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>image</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Image to run</div></div>
<div className="addon-param"><div className="addon-param-head"><code>secretName</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>\(context.name)-keys</code></span></div><div className="addon-param-desc">Secret the app reads its keys from</div></div>
<div className="addon-param"><div className="addon-param-head"><code>replicas</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>1</code></span></div><div className="addon-param-desc">Replicas to run</div></div>
<div className="addon-param"><div className="addon-param-head"><code>storageClass</code> <span className="addon-param-type">string</span> <span className="addon-param-lock" role="img" tabIndex="0" data-tip="Immutable: set it when the component is first deployed. KubeVela refuses an update that changes it, unless the Application has the annotation app.oam.dev/force-param-mutations: &quot;true&quot;." aria-label="Immutable"><svg viewBox="0 0 24 24" width="14" height="14" aria-hidden="true"><rect x="5" y="11" width="14" height="9" rx="2" fill="none" stroke="currentColor" strokeWidth="2"/><path d="M8 11V8a4 4 0 0 1 8 0v3" fill="none" stroke="currentColor" strokeWidth="2"/></svg></span></div><div className="addon-param-desc">Storage class for its volume, set when it is first deployed</div></div>

<details>
<summary><code>ports[]</code> (2) Ports to expose</summary>

<div className="addon-param"><div className="addon-param-head"><code>port</code> <span className="addon-param-type">int</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Port number</div></div>
<div className="addon-param"><div className="addon-param-head"><code>protocol</code> <span className="addon-param-type">TCP or UDP</span> <span className="addon-param-default">default <code>TCP</code></span></div><div className="addon-param-desc">Protocol</div></div>

</details>

