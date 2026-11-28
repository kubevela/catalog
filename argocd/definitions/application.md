---
title: argo-app
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/argocd/versions.json';

<AddonVersion data={versions} current="0.1.0" page="definitions/application" />

<!-- Generated from the definition. -->

Argocd-application is a definition of application resource.

**Type:** component. **From:** the [argocd](/addons/catalog/argocd/) addon.

## Parameters


<details>
<summary><code>Application</code> (31)</summary>

<div className="addon-param"><div className="addon-param-head"><code>operation</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc"></div></div>

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
<summary><code>spec</code> (23)</summary>

<div className="addon-param"><div className="addon-param-head"><code>project</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>syncPolicy</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>revisionHistoryLimit</code> <span className="addon-param-type">(null or int)</span></div><div className="addon-param-desc"></div></div>

<details>
<summary><code>source</code> (9)</summary>

<div className="addon-param"><div className="addon-param-head"><code>repoURL</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>path</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>targetRevision</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>helm</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>kustomize</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>ksonnet</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>directory</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>plugin</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>chart</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc"></div></div>

</details>


<details>
<summary><code>destination</code> (2)</summary>

<div className="addon-param"><div className="addon-param-head"><code>namespace</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>default</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>server</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>https://kubernetes.default.svc</code></span></div><div className="addon-param-desc"></div></div>

</details>


<details>
<summary><code>ignoreDifferences[]</code> (7)</summary>

<div className="addon-param"><div className="addon-param-head"><code>group</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>kind</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>name</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>namespace</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>jsonPointers</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>jqPathExpressions</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>managedFieldsManagers</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc"></div></div>

</details>


<details>
<summary><code>info[]</code> (2)</summary>

<div className="addon-param"><div className="addon-param-head"><code>name</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>value</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>

</details>


</details>


</details>

