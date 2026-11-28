---
title: helm
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/argocd/versions.json';

<AddonVersion data={versions} current="0.1.0" page="definitions/helm" />

<!-- Generated from the definition. -->

An argocd-based helm support.

**Type:** component. **From:** the [argocd](/addons/catalog/argocd/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>repoType</code> <span className="addon-param-type">helm or git</span> <span className="addon-param-default">default <code>helm</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>url</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">The Git or Helm repository URL, OSS endpoint, accept HTTP/S or SSH address as git url,</div></div>
<div className="addon-param"><div className="addon-param-head"><code>secretRef</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">The name of the secret containing authentication credentials</div></div>
<div className="addon-param"><div className="addon-param-head"><code>chart</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">1.The relative path to helm chart for git/oss source. 2. chart name for helm resource 3. relative path for chart package(e.g. ./charts/podinfo-1.2.3.tgz)</div></div>
<div className="addon-param"><div className="addon-param-head"><code>version</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>*</code></span></div><div className="addon-param-desc">Chart version</div></div>
<div className="addon-param"><div className="addon-param-head"><code>targetNamespace</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">The namespace for helm chart, optional</div></div>
<div className="addon-param"><div className="addon-param-head"><code>releaseName</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">The release name</div></div>
<div className="addon-param"><div className="addon-param-head"><code>values</code> <span className="addon-param-type">map&#91;string&#93;any</span></div><div className="addon-param-desc">Chart values</div></div>

<details>
<summary><code>git</code> (1)</summary>

<div className="addon-param"><div className="addon-param-head"><code>branch</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>master branch</code></span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">The Git reference to checkout and monitor for changes</div></div>

</details>

