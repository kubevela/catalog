---
title: Parameters
sidebar_position: 2
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/crossplane/versions.json';

<AddonVersion data={versions} current="1.0.0" page="parameters" />

<!-- Generated from the addon's parameter.cue. -->

Set them when you enable the addon, `vela addon enable crossplane <name>=<value>`, or in VelaUX's addon form.

<div className="addon-param"><div className="addon-param-head"><code>major</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>2</code></span></div><div className="addon-param-desc">Crossplane major version: 2, or 1 for platforms not yet on 2. The definitions for each differ</div></div>
<div className="addon-param"><div className="addon-param-head"><code>namespace</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>crossplane-system</code></span></div><div className="addon-param-desc">Namespace Crossplane is installed into</div></div>
<div className="addon-param"><div className="addon-param-head"><code>replicas</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>1</code></span></div><div className="addon-param-desc">Replicas of the Crossplane Deployment</div></div>
<div className="addon-param"><div className="addon-param-head"><code>monitoring</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>false</code></span></div><div className="addon-param-desc">Expose Crossplane's metrics on its pods, for Prometheus to scrape</div></div>
<div className="addon-param"><div className="addon-param-head"><code>args</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Extra flags for Crossplane, such as --enable-realtime-compositions or --debug</div></div>
<div className="addon-param"><div className="addon-param-head"><code>nodeSelector</code> <span className="addon-param-type">map&#91;string&#93;string</span></div><div className="addon-param-desc">Run Crossplane only on nodes with these labels</div></div>
<div className="addon-param"><div className="addon-param-head"><code>priorityClassName</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">PriorityClass for Crossplane's pods</div></div>
<div className="addon-param"><div className="addon-param-head"><code>imageRegistry</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Registry to pull Crossplane's image from instead of xpkg.crossplane.io, such as a mirror</div></div>
<div className="addon-param"><div className="addon-param-head"><code>imagePullSecrets</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Secrets in Crossplane's namespace holding the credentials to pull its image and packages</div></div>
<div className="addon-param"><div className="addon-param-head"><code>packageCacheSize</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Largest the package cache may grow</div></div>
<div className="addon-param"><div className="addon-param-head"><code>chartInstall</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>true</code></span></div><div className="addon-param-desc">Install the chart. Set false for the definitions alone, beside a tool you already run another way</div></div>
<div className="addon-param"><div className="addon-param-head"><code>installWith</code> <span className="addon-param-type">vela or flux or argo</span> <span className="addon-param-default">default <code>vela</code></span></div><div className="addon-param-desc">What installs the chart: vela (the built-in helmchart component, the default), flux (a HelmRelease; needs Flux 2.3 or later running) or argo (an Argo CD Application; needs Argo CD running)</div></div>
<div className="addon-param"><div className="addon-param-head"><code>releaseName</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Helm release to install or take over, if not the addon's own name. Upgrading from an addon that installed through the fluxcd addon, name its release &lt;namespace&gt;-&lt;addon name&gt;, such as cert-manager-cert-manager for cert-manager in its default namespace</div></div>

<details>
<summary><code>resources</code> (4) CPU and memory for the Crossplane pod</summary>


<details>
<summary><code>requests</code> (2) What the pod is guaranteed</summary>

<div className="addon-param"><div className="addon-param-head"><code>cpu</code> <span className="addon-param-type">(string or number)</span></div><div className="addon-param-desc">CPU, in cores (0.5) or millicores (500m)</div></div>
<div className="addon-param"><div className="addon-param-head"><code>memory</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Memory, in bytes or with a suffix such as Mi or Gi</div></div>

</details>


<details>
<summary><code>limits</code> (2) The most the pod may use</summary>

<div className="addon-param"><div className="addon-param-head"><code>cpu</code> <span className="addon-param-type">(string or number)</span></div><div className="addon-param-desc">CPU, in cores (0.5) or millicores (500m)</div></div>
<div className="addon-param"><div className="addon-param-head"><code>memory</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Memory, in bytes or with a suffix such as Mi or Gi</div></div>

</details>


</details>


<details>
<summary><code>tolerations[]</code> (5) Taints Crossplane's pods tolerate, so they can run on nodes kept for them</summary>

<div className="addon-param"><div className="addon-param-head"><code>key</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Taint key; leave empty with operator Exists to tolerate every taint</div></div>
<div className="addon-param"><div className="addon-param-head"><code>operator</code> <span className="addon-param-type">Equal or Exists</span> <span className="addon-param-default">default <code>Equal</code></span></div><div className="addon-param-desc">Equal matches the taint's value; Exists matches any value</div></div>
<div className="addon-param"><div className="addon-param-head"><code>value</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Taint value, with operator Equal</div></div>
<div className="addon-param"><div className="addon-param-head"><code>effect</code> <span className="addon-param-type">NoSchedule or PreferNoSchedule or NoExecute</span></div><div className="addon-param-desc">Taint effect to tolerate; leave empty for every effect</div></div>
<div className="addon-param"><div className="addon-param-head"><code>tolerationSeconds</code> <span className="addon-param-type">int</span></div><div className="addon-param-desc">With effect NoExecute, how long the pod stays on a node after the taint appears</div></div>

</details>


<details>
<summary><code>affinity</code> (39) Kubernetes affinity rules for Crossplane's pods, as in a pod spec</summary>


<details>
<summary><code>nodeAffinity</code> (13) Nodes the pods may run on</summary>


<details>
<summary><code>requiredDuringSchedulingIgnoredDuringExecution</code> (6) Node rules that must hold; a node matching any one term will do</summary>


<details>
<summary><code>nodeSelectorTerms[]</code> (6) Terms, any one of which a node must match</summary>


<details>
<summary><code>matchExpressions[]</code> (3) Node labels that must match</summary>

<div className="addon-param"><div className="addon-param-head"><code>key</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Label to match</div></div>
<div className="addon-param"><div className="addon-param-head"><code>operator</code> <span className="addon-param-type">In or NotIn or Exists or DoesNotExist or Gt or Lt</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">How the label is matched</div></div>
<div className="addon-param"><div className="addon-param-head"><code>values</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Values for In and NotIn, or one number for Gt and Lt</div></div>

</details>


<details>
<summary><code>matchFields[]</code> (3) Node fields that must match, such as metadata.name</summary>

<div className="addon-param"><div className="addon-param-head"><code>key</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Label to match</div></div>
<div className="addon-param"><div className="addon-param-head"><code>operator</code> <span className="addon-param-type">In or NotIn or Exists or DoesNotExist or Gt or Lt</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">How the label is matched</div></div>
<div className="addon-param"><div className="addon-param-head"><code>values</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Values for In and NotIn, or one number for Gt and Lt</div></div>

</details>


</details>


</details>


<details>
<summary><code>preferredDuringSchedulingIgnoredDuringExecution[]</code> (7) Node rules the scheduler tries to meet, each with a weight</summary>

<div className="addon-param"><div className="addon-param-head"><code>weight</code> <span className="addon-param-type">int</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Weight, from 1 to 100</div></div>

<details>
<summary><code>preference</code> (6) The node rule</summary>


<details>
<summary><code>matchExpressions[]</code> (3) Node labels that must match</summary>

<div className="addon-param"><div className="addon-param-head"><code>key</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Label to match</div></div>
<div className="addon-param"><div className="addon-param-head"><code>operator</code> <span className="addon-param-type">In or NotIn or Exists or DoesNotExist or Gt or Lt</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">How the label is matched</div></div>
<div className="addon-param"><div className="addon-param-head"><code>values</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Values for In and NotIn, or one number for Gt and Lt</div></div>

</details>


<details>
<summary><code>matchFields[]</code> (3) Node fields that must match, such as metadata.name</summary>

<div className="addon-param"><div className="addon-param-head"><code>key</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Label to match</div></div>
<div className="addon-param"><div className="addon-param-head"><code>operator</code> <span className="addon-param-type">In or NotIn or Exists or DoesNotExist or Gt or Lt</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">How the label is matched</div></div>
<div className="addon-param"><div className="addon-param-head"><code>values</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Values for In and NotIn, or one number for Gt and Lt</div></div>

</details>


</details>


</details>


</details>


<details>
<summary><code>podAffinity</code> (13) Pods to run alongside</summary>


<details>
<summary><code>requiredDuringSchedulingIgnoredDuringExecution[]</code> (6) Rules that must hold to schedule a pod</summary>

<div className="addon-param"><div className="addon-param-head"><code>topologyKey</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Node label that defines the domain, such as kubernetes.io/hostname or topology.kubernetes.io/zone</div></div>
<div className="addon-param"><div className="addon-param-head"><code>namespaces</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Namespaces of those pods; leave empty for this pod's own</div></div>

<details>
<summary><code>labelSelector</code> (4) Pods to place relative to</summary>

<div className="addon-param"><div className="addon-param-head"><code>matchLabels</code> <span className="addon-param-type">map&#91;string&#93;string</span></div><div className="addon-param-desc">Labels the pods must have</div></div>

<details>
<summary><code>matchExpressions[]</code> (3) Label rules the pods must meet</summary>

<div className="addon-param"><div className="addon-param-head"><code>key</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Label to match</div></div>
<div className="addon-param"><div className="addon-param-head"><code>operator</code> <span className="addon-param-type">In or NotIn or Exists or DoesNotExist</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">How the label is matched</div></div>
<div className="addon-param"><div className="addon-param-head"><code>values</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Values for In and NotIn</div></div>

</details>


</details>


</details>


<details>
<summary><code>preferredDuringSchedulingIgnoredDuringExecution[]</code> (7) Rules the scheduler tries to meet, each with a weight</summary>

<div className="addon-param"><div className="addon-param-head"><code>weight</code> <span className="addon-param-type">int</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Weight, from 1 to 100</div></div>

<details>
<summary><code>podAffinityTerm</code> (6) The rule</summary>

<div className="addon-param"><div className="addon-param-head"><code>topologyKey</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Node label that defines the domain, such as kubernetes.io/hostname or topology.kubernetes.io/zone</div></div>
<div className="addon-param"><div className="addon-param-head"><code>namespaces</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Namespaces of those pods; leave empty for this pod's own</div></div>

<details>
<summary><code>labelSelector</code> (4) Pods to place relative to</summary>

<div className="addon-param"><div className="addon-param-head"><code>matchLabels</code> <span className="addon-param-type">map&#91;string&#93;string</span></div><div className="addon-param-desc">Labels the pods must have</div></div>

<details>
<summary><code>matchExpressions[]</code> (3) Label rules the pods must meet</summary>

<div className="addon-param"><div className="addon-param-head"><code>key</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Label to match</div></div>
<div className="addon-param"><div className="addon-param-head"><code>operator</code> <span className="addon-param-type">In or NotIn or Exists or DoesNotExist</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">How the label is matched</div></div>
<div className="addon-param"><div className="addon-param-head"><code>values</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Values for In and NotIn</div></div>

</details>


</details>


</details>


</details>


</details>


<details>
<summary><code>podAntiAffinity</code> (13) Pods to keep away from, such as other replicas</summary>


<details>
<summary><code>requiredDuringSchedulingIgnoredDuringExecution[]</code> (6) Rules that must hold to schedule a pod</summary>

<div className="addon-param"><div className="addon-param-head"><code>topologyKey</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Node label that defines the domain, such as kubernetes.io/hostname or topology.kubernetes.io/zone</div></div>
<div className="addon-param"><div className="addon-param-head"><code>namespaces</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Namespaces of those pods; leave empty for this pod's own</div></div>

<details>
<summary><code>labelSelector</code> (4) Pods to place relative to</summary>

<div className="addon-param"><div className="addon-param-head"><code>matchLabels</code> <span className="addon-param-type">map&#91;string&#93;string</span></div><div className="addon-param-desc">Labels the pods must have</div></div>

<details>
<summary><code>matchExpressions[]</code> (3) Label rules the pods must meet</summary>

<div className="addon-param"><div className="addon-param-head"><code>key</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Label to match</div></div>
<div className="addon-param"><div className="addon-param-head"><code>operator</code> <span className="addon-param-type">In or NotIn or Exists or DoesNotExist</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">How the label is matched</div></div>
<div className="addon-param"><div className="addon-param-head"><code>values</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Values for In and NotIn</div></div>

</details>


</details>


</details>


<details>
<summary><code>preferredDuringSchedulingIgnoredDuringExecution[]</code> (7) Rules the scheduler tries to meet, each with a weight</summary>

<div className="addon-param"><div className="addon-param-head"><code>weight</code> <span className="addon-param-type">int</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Weight, from 1 to 100</div></div>

<details>
<summary><code>podAffinityTerm</code> (6) The rule</summary>

<div className="addon-param"><div className="addon-param-head"><code>topologyKey</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Node label that defines the domain, such as kubernetes.io/hostname or topology.kubernetes.io/zone</div></div>
<div className="addon-param"><div className="addon-param-head"><code>namespaces</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Namespaces of those pods; leave empty for this pod's own</div></div>

<details>
<summary><code>labelSelector</code> (4) Pods to place relative to</summary>

<div className="addon-param"><div className="addon-param-head"><code>matchLabels</code> <span className="addon-param-type">map&#91;string&#93;string</span></div><div className="addon-param-desc">Labels the pods must have</div></div>

<details>
<summary><code>matchExpressions[]</code> (3) Label rules the pods must meet</summary>

<div className="addon-param"><div className="addon-param-head"><code>key</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Label to match</div></div>
<div className="addon-param"><div className="addon-param-head"><code>operator</code> <span className="addon-param-type">In or NotIn or Exists or DoesNotExist</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">How the label is matched</div></div>
<div className="addon-param"><div className="addon-param-head"><code>values</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Values for In and NotIn</div></div>

</details>


</details>


</details>


</details>


</details>


</details>


<details>
<summary><code>registryCaBundle</code> (2) ConfigMap in Crossplane's namespace with the CA bundle of a private package registry</summary>

<div className="addon-param"><div className="addon-param-head"><code>name</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Name of the ConfigMap</div></div>
<div className="addon-param"><div className="addon-param-head"><code>key</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Key in the ConfigMap that holds the bundle</div></div>

</details>


<details>
<summary><code>chart</code> (2) Override the pinned chart, at your own risk: version takes another chart version, repoURL a mirror of the chart repository</summary>

<div className="addon-param"><div className="addon-param-head"><code>version</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Chart version to install instead of the one the addon pins, at or above the addon's minimum and, where the addon offers majors, within the chosen one</div></div>
<div className="addon-param"><div className="addon-param-head"><code>repoURL</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Chart repository to install from instead of the chart's own, such as a mirror</div></div>

</details>

