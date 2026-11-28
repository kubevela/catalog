---
title: Parameters
sidebar_position: 2
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/cronhpa/versions.json';

<AddonVersion data={versions} current="1.4.1" page="parameters" />

<!-- Generated from the addon's parameter.cue. -->

Set them when you enable the addon, `vela addon enable cronhpa <name>=<value>`, or in VelaUX's addon form.

<div className="addon-param"><div className="addon-param-head"><code>registry</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>registry.aliyuncs.com</code></span></div><div className="addon-param-desc">Specify the image registry of cronhpa controller, eg. "registry.aliyuncs.com/acs"</div></div>
<div className="addon-param"><div className="addon-param-head"><code>repository</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>acs/kubernetes-cronhpa-controller</code></span></div><div className="addon-param-desc">Specify the image repository of cronhpa controller, eg. "kubernetes-cronhpa-controller"</div></div>
<div className="addon-param"><div className="addon-param-head"><code>imageTag</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>v1.4.1-b8cd52c-aliyun</code></span></div><div className="addon-param-desc">Specify the image tag of cronhpa controller, eg. "v1.4.1"</div></div>
<div className="addon-param"><div className="addon-param-head"><code>imagePullSecrets</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Specify the names of imagePullSecret for private image registry, eg. "&#123;a,b,c&#125;"</div></div>
<div className="addon-param"><div className="addon-param-head"><code>imagePullPolicy</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>Always</code></span></div><div className="addon-param-desc">Specify the imagePullPolicy of the image</div></div>
<div className="addon-param"><div className="addon-param-head"><code>replicas</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>1</code></span></div><div className="addon-param-desc">Specify the replicas.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>namespace</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>vela-system</code></span></div><div className="addon-param-desc">Specify the namespace to install</div></div>
<div className="addon-param"><div className="addon-param-head"><code>clusters</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Specify the clusters to install</div></div>

<details>
<summary><code>resources</code> (4) Specifies the attributes of the resource required</summary>


<details>
<summary><code>requests</code> (2)</summary>

<div className="addon-param"><div className="addon-param-head"><code>cpu</code> <span className="addon-param-type">number</span> <span className="addon-param-default">default <code>1</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>memory</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>100Mi</code></span></div><div className="addon-param-desc"></div></div>

</details>


<details>
<summary><code>limits</code> (2)</summary>

<div className="addon-param"><div className="addon-param-head"><code>cpu</code> <span className="addon-param-type">number</span> <span className="addon-param-default">default <code>1</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>memory</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>100Mi</code></span></div><div className="addon-param-desc"></div></div>

</details>


</details>

