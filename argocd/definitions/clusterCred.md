---
title: argocd-cluster-credential
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/argocd/versions.json';

<AddonVersion data={versions} current="0.1.0" page="definitions/clusterCred" />

<!-- Generated from the definition. -->

Argocd-cluster-credential is a definition of k8s credential.

**Type:** component. **From:** the [argocd](/addons/catalog/argocd/) addon.

## Parameters


<details>
<summary><code>stringData</code> (18)</summary>

<div className="addon-param"><div className="addon-param-head"><code>name</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>server</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>namespaces</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc"></div></div>

<details>
<summary><code>config</code> (15)</summary>

<div className="addon-param"><div className="addon-param-head"><code>username</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>password</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>bearerToken</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc"></div></div>

<details>
<summary><code>awsAuthConfig</code> (2)</summary>

<div className="addon-param"><div className="addon-param-head"><code>clusterName</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>roleARN</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>

</details>


<details>
<summary><code>execProviderConfig</code> (5)</summary>

<div className="addon-param"><div className="addon-param-head"><code>command</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>args</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>env</code> <span className="addon-param-type">map&#91;string&#93;any</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>apiVersion</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>installHint</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc"></div></div>

</details>


<details>
<summary><code>tlsClientConfig</code> (5)</summary>

<div className="addon-param"><div className="addon-param-head"><code>caData</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>certData</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>insecure</code> <span className="addon-param-type">bool</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>keyData</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>serverName</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc"></div></div>

</details>


</details>


</details>

