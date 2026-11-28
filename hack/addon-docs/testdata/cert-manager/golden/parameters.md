---
title: Parameters
sidebar_position: 2
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/cert-manager/versions.json';

<AddonVersion data={versions} current="3.0.0" page="parameters" />

<!-- Generated from the addon's parameter.cue. -->

Set them when you enable the addon, `vela addon enable cert-manager <name>=<value>`, or in VelaUX's addon form.

<div className="addon-param"><div className="addon-param-head"><code>namespace</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>cert-manager</code></span></div><div className="addon-param-desc">Namespace to install cert-manager into</div></div>
<div className="addon-param"><div className="addon-param-head"><code>clusters</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Deploy to the named clusters. Leave empty to deploy to every cluster</div></div>
<div className="addon-param"><div className="addon-param-head"><code>namespaceIssuers</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>false</code></span></div><div className="addon-param-desc">Install a global policy that lets a namespace choose the issuer for its certificates, with the annotation cert-manager.oam.dev/cluster-issuer or cert-manager.oam.dev/issuer. Needs global policies enabled in vela-core</div></div>
<div className="addon-param"><div className="addon-param-head"><code>replicas</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>1</code></span></div><div className="addon-param-desc">Replicas of each cert-manager Deployment: the controller, the webhook and the CA injector</div></div>
<div className="addon-param"><div className="addon-param-head"><code>highAvailability</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>false</code></span></div><div className="addon-param-desc">Keep every cert-manager Deployment available through node drains, with a PodDisruptionBudget each. Needs replicas of 2 or more</div></div>
<div className="addon-param"><div className="addon-param-head"><code>monitoring</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>false</code></span></div><div className="addon-param-desc">Expose cert-manager's metrics to Prometheus with a ServiceMonitor. Needs the Prometheus operator's CRDs</div></div>
<div className="addon-param"><div className="addon-param-head"><code>keepCRDs</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>true</code></span></div><div className="addon-param-desc">Keep cert-manager's CRDs, and so every certificate and issuer, when the addon is disabled</div></div>
<div className="addon-param"><div className="addon-param-head"><code>nodeSelector</code> <span className="addon-param-type">map&#91;string&#93;string</span></div><div className="addon-param-desc">Run cert-manager only on nodes with these labels</div></div>
<div className="addon-param"><div className="addon-param-head"><code>affinity</code> <span className="addon-param-type">map&#91;string&#93;any</span></div><div className="addon-param-desc">Kubernetes affinity rules for cert-manager's pods, as in a pod spec</div></div>
<div className="addon-param"><div className="addon-param-head"><code>priorityClassName</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">PriorityClass for cert-manager's pods</div></div>
<div className="addon-param"><div className="addon-param-head"><code>imageRegistry</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Registry to pull cert-manager's images from instead of quay.io, such as a mirror</div></div>
<div className="addon-param"><div className="addon-param-head"><code>imagePullSecrets</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Secrets in cert-manager's namespace holding the credentials to pull its images</div></div>
<div className="addon-param"><div className="addon-param-head"><code>featureGates</code> <span className="addon-param-type">map&#91;string&#93;bool</span></div><div className="addon-param-desc">Cert-manager feature gates to turn on or off, such as ServerSideApply: true</div></div>
<div className="addon-param"><div className="addon-param-head"><code>dns01Nameservers</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">DNS servers to check DNS01 challenges against instead of the cluster's, such as 1.1.1.1:53</div></div>
<div className="addon-param"><div className="addon-param-head"><code>certificateOwnerRef</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>false</code></span></div><div className="addon-param-desc">Delete a certificate's Secret when the certificate is deleted</div></div>
<div className="addon-param"><div className="addon-param-head"><code>chartInstall</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>true</code></span></div><div className="addon-param-desc">Install the chart. Set false for the definitions alone, beside a tool you already run another way</div></div>
<div className="addon-param"><div className="addon-param-head"><code>installWith</code> <span className="addon-param-type">vela or flux or argo</span></div><div className="addon-param-desc">What installs the chart: vela (the built-in helmchart component, the default), flux (a HelmRelease; needs Flux 2.3 or later running) or argo (an Argo CD Application; needs Argo CD running)</div></div>
<div className="addon-param"><div className="addon-param-head"><code>releaseName</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Helm release to install or take over, if not the addon's own name. Upgrading from an addon that installed through the fluxcd addon, name its release as the addon's namespace and name joined by a hyphen, e.g. vela-system-cert-manager</div></div>

<details>
<summary><code>resources</code> (4) CPU and memory for each cert-manager pod</summary>


<details>
<summary><code>requests</code> (2) What each pod is guaranteed</summary>

<div className="addon-param"><div className="addon-param-head"><code>cpu</code> <span className="addon-param-type">(string or number)</span></div><div className="addon-param-desc">CPU, in cores or millicores</div></div>
<div className="addon-param"><div className="addon-param-head"><code>memory</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Memory, in bytes or with a suffix</div></div>

</details>


<details>
<summary><code>limits</code> (2) The most each pod may use</summary>

<div className="addon-param"><div className="addon-param-head"><code>cpu</code> <span className="addon-param-type">(string or number)</span></div><div className="addon-param-desc">CPU, in cores or millicores</div></div>
<div className="addon-param"><div className="addon-param-head"><code>memory</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Memory, in bytes or with a suffix</div></div>

</details>


</details>


<details>
<summary><code>tolerations[]</code> (5) Taints cert-manager's pods tolerate, so they can run on nodes kept for them</summary>

<div className="addon-param"><div className="addon-param-head"><code>key</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Taint key; leave empty with operator Exists to tolerate every taint</div></div>
<div className="addon-param"><div className="addon-param-head"><code>operator</code> <span className="addon-param-type">Equal or Exists</span> <span className="addon-param-default">default <code>Equal</code></span></div><div className="addon-param-desc">Equal matches the taint's value; Exists matches any value</div></div>
<div className="addon-param"><div className="addon-param-head"><code>value</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Taint value, with operator Equal</div></div>
<div className="addon-param"><div className="addon-param-head"><code>effect</code> <span className="addon-param-type">NoSchedule or PreferNoSchedule or NoExecute</span></div><div className="addon-param-desc">Taint effect to tolerate; leave empty for every effect</div></div>
<div className="addon-param"><div className="addon-param-head"><code>tolerationSeconds</code> <span className="addon-param-type">int</span></div><div className="addon-param-desc">With effect NoExecute, how long the pod stays on a node after the taint appears</div></div>

</details>


<details>
<summary><code>chart</code> (2) Override the pinned chart, at your own risk: version takes another chart version, repoURL a mirror of the chart repository</summary>

<div className="addon-param"><div className="addon-param-head"><code>version</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Chart version to install instead of the one the addon pins, at or above the addon's minimum and, where the addon offers majors, within the chosen one</div></div>
<div className="addon-param"><div className="addon-param-head"><code>repoURL</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Chart repository to install from instead of the chart's own, such as a mirror</div></div>

</details>

