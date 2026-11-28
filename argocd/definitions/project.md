---
title: argocd-project
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/argocd/versions.json';

<AddonVersion data={versions} current="0.1.0" page="definitions/project" />

<!-- Generated from the definition. -->

Argocd-project is a definition of appproject resource.

**Type:** component. **From:** the [argocd](/addons/catalog/argocd/) addon.

## Parameters


<details>
<summary><code>AppProject</code> (29)</summary>


<details>
<summary><code>metadata</code> (7)</summary>

<div className="addon-param"><div className="addon-param-head"><code>name</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>namespace</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>argocd</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>deletionGracePeriodSeconds</code> <span className="addon-param-type">(null or int)</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>labels</code> <span className="addon-param-type">map&#91;string&#93;string</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>annotations</code> <span className="addon-param-type">map&#91;string&#93;string</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>finalizers</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>clusterName</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc"></div></div>

</details>


<details>
<summary><code>spec</code> (22)</summary>

<div className="addon-param"><div className="addon-param-head"><code>sourceRepos</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>description</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>orphanedResources</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>syncWindows</code> <span className="addon-param-type">&#91;&#93;(null or struct)</span></div><div className="addon-param-desc"></div></div>

<details>
<summary><code>destinations[]</code> (2)</summary>

<div className="addon-param"><div className="addon-param-head"><code>namespace</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>server</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>

</details>


<details>
<summary><code>roles[]</code> (7)</summary>

<div className="addon-param"><div className="addon-param-head"><code>name</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>description</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>policies</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>groups</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc"></div></div>

<details>
<summary><code>jwtTokens[]</code> (3)</summary>

<div className="addon-param"><div className="addon-param-head"><code>iat</code> <span className="addon-param-type">int</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>exp</code> <span className="addon-param-type">int</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>id</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc"></div></div>

</details>


</details>


<details>
<summary><code>clusterResourceWhitelist[]</code> (2)</summary>

<div className="addon-param"><div className="addon-param-head"><code>group</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>kind</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>

</details>


<details>
<summary><code>namespaceResourceBlacklist[]</code> (2)</summary>

<div className="addon-param"><div className="addon-param-head"><code>group</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>kind</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>

</details>


<details>
<summary><code>namespaceResourceWhitelist[]</code> (2)</summary>

<div className="addon-param"><div className="addon-param-head"><code>group</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>kind</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>

</details>


<details>
<summary><code>signatureKeys[]</code> (1)</summary>

<div className="addon-param"><div className="addon-param-head"><code>keyID</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>

</details>


<details>
<summary><code>clusterResourceBlacklist[]</code> (2)</summary>

<div className="addon-param"><div className="addon-param-head"><code>group</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>kind</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>

</details>


</details>


</details>

