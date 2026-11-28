---
title: zookeeper-cluster
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/zookeeper-operator/versions.json';

<AddonVersion data={versions} current="1.0.0" page="definitions/zookeeper-cluster" />

<!-- Generated from the definition. -->

zookeeper cluster component

**Type:** component. **From:** the [zookeeper-operator](/addons/catalog/zookeeper-operator/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>replicas</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>3</code></span></div><div className="addon-param-desc">The size of the zookeeper cluster.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>maxUnavailableReplicas</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>1</code></span></div><div className="addon-param-desc">Max unavailable replicas in pdb</div></div>
<div className="addon-param"><div className="addon-param-head"><code>triggerRollingRestart</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>false</code></span></div><div className="addon-param-desc">If true, the zookeeper cluster is restarted. After the restart is triggered, this value is auto-reverted to false.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>domainName</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">External host name appended for dns annotation</div></div>
<div className="addon-param"><div className="addon-param-head"><code>kubernetesClusterDomain</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>cluster.local</code></span></div><div className="addon-param-desc">Domain of the kubernetes cluster</div></div>
<div className="addon-param"><div className="addon-param-head"><code>labels</code> <span className="addon-param-type">object</span> <span className="addon-param-default">default <code>&#123;&#125;</code></span></div><div className="addon-param-desc">Specifies the labels to be attached.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>ports</code> <span className="addon-param-type">list</span></div><div className="addon-param-desc">Groups the ports for a zookeeper cluster node for easy access.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>pod</code> <span className="addon-param-type">object</span></div><div className="addon-param-desc">Defines the policy to create new pods for the zookeeper cluster.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>clientService</code> <span className="addon-param-type">object</span></div><div className="addon-param-desc">Defines the policy to create client Service for the zookeeper cluster.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>headlessService</code> <span className="addon-param-type">object</span></div><div className="addon-param-desc">Defines the policy to create headless Service for the zookeeper cluster.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>adminServerService</code> <span className="addon-param-type">object</span></div><div className="addon-param-desc">Defines the policy to create AdminServer Service for the zookeeper cluster.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>storageType</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>persistence</code></span></div><div className="addon-param-desc">Type of storage that can be used it can take either ephemeral or persistence as value.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>containers</code> <span className="addon-param-type">list</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Application containers run with the zookeeper pod.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>initContainers</code> <span className="addon-param-type">list</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Init Containers to add to the zookeeper pods.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>volumes</code> <span className="addon-param-type">list</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Named volumes that may be accessed by any container in the pod.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>volumeMounts</code> <span className="addon-param-type">list</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Customized volumeMounts for zookeeper container that can be configured to mount volumes to zookeeper container.</div></div>

<details>
<summary><code>image</code> (3) Image configuration</summary>

<div className="addon-param"><div className="addon-param-head"><code>repository</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>pravega/zookeeper</code></span></div><div className="addon-param-desc">Image repository</div></div>
<div className="addon-param"><div className="addon-param-head"><code>tag</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>0.2.14</code></span></div><div className="addon-param-desc">Image tag</div></div>
<div className="addon-param"><div className="addon-param-head"><code>pullPolicy</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>IfNotPresent</code></span></div><div className="addon-param-desc">Image pull policy</div></div>

</details>


<details>
<summary><code>probes</code> (9) Probes configuration</summary>


<details>
<summary><code>readiness</code> (5) readiness</summary>

<div className="addon-param"><div className="addon-param-head"><code>initialDelaySeconds</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>10</code></span></div><div className="addon-param-desc">Number of seconds after the container has started before readiness probe is initiated.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>periodSeconds</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>10</code></span></div><div className="addon-param-desc">Number of seconds in which readiness probe will be performed.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>failureThreshold</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>3</code></span></div><div className="addon-param-desc">Number of seconds after which the readiness probe times out.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>successThreshold</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>1</code></span></div><div className="addon-param-desc">Minimum number of consecutive successes for the readiness probe to be considered successful after having failed.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>timeoutSeconds</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>10</code></span></div><div className="addon-param-desc">Number of times Kubernetes will retry after a readiness probe failure before restarting the container.</div></div>

</details>


<details>
<summary><code>liveness</code> (4) liveness</summary>

<div className="addon-param"><div className="addon-param-head"><code>initialDelaySeconds</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>10</code></span></div><div className="addon-param-desc">Number of seconds after the container has started before liveness probe is initiated.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>periodSeconds</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>10</code></span></div><div className="addon-param-desc">Number of seconds in which liveness probe will be performed.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>failureThreshold</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>3</code></span></div><div className="addon-param-desc">Number of seconds after which the liveness probe times out.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>timeoutSeconds</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>10</code></span></div><div className="addon-param-desc">Number of seconds after which the liveness probe times out.</div></div>

</details>


</details>


<details>
<summary><code>config</code> (16)</summary>

<div className="addon-param"><div className="addon-param-head"><code>initLimit</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>10</code></span></div><div className="addon-param-desc">Amount of time (in ticks) to allow followers to connect and sync to a leader.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>tickTime</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>2000</code></span></div><div className="addon-param-desc">Length of a single tick which is the basic time unit used by Zookeeper (measured in milliseconds).</div></div>
<div className="addon-param"><div className="addon-param-head"><code>syncLimit</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>2</code></span></div><div className="addon-param-desc">Amount of time (in ticks) to allow followers to sync with Zookeeper.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>globalOutstandingLimit</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>1000</code></span></div><div className="addon-param-desc">Max limit for outstanding requests.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>preAllocSize</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>65536</code></span></div><div className="addon-param-desc">PreAllocSize in kilobytes.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>snapCount</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>100000</code></span></div><div className="addon-param-desc">The number of transactions recorded in the transaction log before a snapshot can be taken.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>commitLogCount</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>500</code></span></div><div className="addon-param-desc">The number of committed requests in memory.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>snapSizeLimitInKb</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>4194304</code></span></div><div className="addon-param-desc">SnapSizeLimitInKb.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>maxCnxns</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>0</code></span></div><div className="addon-param-desc">The total number of concurrent connections that can be made to a zookeeper server.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>maxClientCnxns</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>60</code></span></div><div className="addon-param-desc">The number of concurrent connections that a single client.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>minSessionTimeout</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>4000</code></span></div><div className="addon-param-desc">The minimum session timeout in milliseconds that the server will allow the client to negotiate.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>maxSessionTimeout</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>40000</code></span></div><div className="addon-param-desc">The maximum session timeout in milliseconds that the server will allow the client to negotiate.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>autoPurgeSnapRetainCount</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>3</code></span></div><div className="addon-param-desc">The number of snapshots to be retained.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>autoPurgePurgeInterval</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>1</code></span></div><div className="addon-param-desc">The time interval in hours for which the purge task has to be triggered.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>quorumListenOnAllIPs</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>false</code></span></div><div className="addon-param-desc">Whether Zookeeper server will listen for connections from its peers on all available IP addresses.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>additionalConfig</code> <span className="addon-param-type">object</span> <span className="addon-param-default">default <code>&#123;&#125;</code></span></div><div className="addon-param-desc">Additional zookeeper coniguration parameters that should be defined in generated zoo.cfg file.</div></div>

</details>


<details>
<summary><code>persistence</code> (4) Persistant storage type configuration.</summary>

<div className="addon-param"><div className="addon-param-head"><code>annotations</code> <span className="addon-param-type">object</span> <span className="addon-param-default">default <code>&#123;&#125;</code></span></div><div className="addon-param-desc">Specifies the annotations to attach to pvcs.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>reclaimPolicy</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>Delete</code></span></div><div className="addon-param-desc">Reclaim policy for persistent volumes.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>storageClassName</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Storage class for persistent volumes.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>volumeSize</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>20Gi</code></span></div><div className="addon-param-desc">Size of the volume requested for persistent volumes.</div></div>

</details>


<details>
<summary><code>ephemeral</code> (2) Ephemeral storage type configuration.</summary>


<details>
<summary><code>emptydirvolumesource</code> (2)</summary>

<div className="addon-param"><div className="addon-param-head"><code>medium</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">What type of storage medium should back the directory.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>sizeLimit</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>20Gi</code></span></div><div className="addon-param-desc">Total amount of local storage required for the EmptyDir volume.</div></div>

</details>


</details>

