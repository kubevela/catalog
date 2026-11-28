---
title: postgres-cluster
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/postgres-operator/versions.json';

<AddonVersion data={versions} current="1.0.0" page="definitions/postgres-cluster" />

<!-- Generated from the definition. -->

postgres cluster component

**Type:** component. **From:** the [postgres-operator](/addons/catalog/postgres-operator/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>replicas</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>2</code></span></div><div className="addon-param-desc">The size of the postgres cluster.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>teamId</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>acid</code></span></div><div className="addon-param-desc">Set team Id.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>image</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>ghcr.io/zalando/spilo-15:2.1-p9</code></span></div><div className="addon-param-desc">The image of the spilo.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>enableShmVolume</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>true</code></span></div><div className="addon-param-desc">Enable SHM volume if set true.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>enableMasterLoadBalancer</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>false</code></span></div><div className="addon-param-desc">Enable master as load balancer if set true.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>enableReplicaLoadBalancer</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>false</code></span></div><div className="addon-param-desc">Enable replica as load balancer if set true.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>enableConnectionPooler</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>false</code></span></div><div className="addon-param-desc">Enable/disable connection pooler deployment.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>enableReplicaConnectionPooler</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>false</code></span></div><div className="addon-param-desc">Set to enable connection pooler for replica service.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>enableMasterPoolerLoadBalancer</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>false</code></span></div><div className="addon-param-desc">Set to enable master pooler as load balancer.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>enableReplicaPoolerLoadBalancer</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>false</code></span></div><div className="addon-param-desc">Set to enable replica pooler as load balancer.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>ttl</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>30</code></span></div><div className="addon-param-desc">Set ttl(Time to live) by dedault it's 30 days.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>loopWait</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>10</code></span></div><div className="addon-param-desc">Set loop wait time by dedault it's 10.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>retryTimeout</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>10</code></span></div><div className="addon-param-desc">Set retry timeout by dedault it's 10.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>synchronousMode</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>false</code></span></div><div className="addon-param-desc">Set to enable synchronous mode.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>synchronousModeStrict</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>false</code></span></div><div className="addon-param-desc">Set to enable synchronous mode strictly.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>synchronousNodeCount</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>1</code></span></div><div className="addon-param-desc">Set how many nodes to be synchronized.</div></div>

<details>
<summary><code>postgresql</code> (4) configure postgresql.</summary>

<div className="addon-param"><div className="addon-param-head"><code>version</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>15</code></span></div><div className="addon-param-desc">The version of the postgresql to be used.</div></div>

<details>
<summary><code>parameters</code> (3)</summary>

<div className="addon-param"><div className="addon-param-head"><code>shared_buffers</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>32MB</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>max_connections</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>10</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>log_statement</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>all</code></span></div><div className="addon-param-desc"></div></div>

</details>


</details>


<details>
<summary><code>volume</code> (1) configure volume.</summary>

<div className="addon-param"><div className="addon-param-head"><code>size</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>1Gi</code></span></div><div className="addon-param-desc">The size of the volume used of postgres.</div></div>

</details>


<details>
<summary><code>databases</code> (1) define databases to be used.</summary>

<div className="addon-param"><div className="addon-param-head"><code>foo</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>

</details>


<details>
<summary><code>preparedDatabases</code> (6) configure created databases.</summary>


<details>
<summary><code>bar</code> (6)</summary>

<div className="addon-param"><div className="addon-param-head"><code>defaultUsers</code> <span className="addon-param-type">bool</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>

<details>
<summary><code>extensions</code> (2)</summary>

<div className="addon-param"><div className="addon-param-head"><code>pg_partman</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>pgcrypto</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>

</details>


<details>
<summary><code>schemas</code> (3)</summary>

<div className="addon-param"><div className="addon-param-head"><code>data</code> <span className="addon-param-type">object</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>

<details>
<summary><code>history</code> (2)</summary>

<div className="addon-param"><div className="addon-param-head"><code>defaultRoles</code> <span className="addon-param-type">bool</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>defaultUsers</code> <span className="addon-param-type">bool</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>

</details>


</details>


</details>


</details>


<details>
<summary><code>users</code> (2) configure users for the databases.</summary>

<div className="addon-param"><div className="addon-param-head"><code>zalando</code> <span className="addon-param-type">list</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>foo_user</code> <span className="addon-param-type">list</span></div><div className="addon-param-desc"></div></div>

</details>


<details>
<summary><code>patroni</code> (4) configure patroni.</summary>

<div className="addon-param"><div className="addon-param-head"><code>failsafe_mode</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>false</code></span></div><div className="addon-param-desc"></div></div>

<details>
<summary><code>initdb</code> (3)</summary>

<div className="addon-param"><div className="addon-param-head"><code>encoding</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>UTF8</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>locale</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>en_US.UTF-8</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>data-checksums</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>true</code></span></div><div className="addon-param-desc"></div></div>

</details>


</details>


<details>
<summary><code>resources</code> (4) configure resources.</summary>


<details>
<summary><code>requests</code> (2)</summary>

<div className="addon-param"><div className="addon-param-head"><code>cpu</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>10m</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>memory</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>100Mi</code></span></div><div className="addon-param-desc"></div></div>

</details>


<details>
<summary><code>limits</code> (2)</summary>

<div className="addon-param"><div className="addon-param-head"><code>cpu</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>500m</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>memory</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>500Mi</code></span></div><div className="addon-param-desc"></div></div>

</details>


</details>


<details>
<summary><code>tls</code> (5) configure custom TLS.</summary>

<div className="addon-param"><div className="addon-param-head"><code>secretName</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Sets custom TLS secret name, It should correspond to a Kubernetes Secret resource to load.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>certificateFile</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>tls.crt</code></span></div><div className="addon-param-desc">Sets custom TLS certificate file.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>privateKeyFile</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>tls.key</code></span></div><div className="addon-param-desc">Sets custom TLS private key file.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>caFile</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Optionally configure Postgres with a CA certificate.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>caSecretName</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Optionally the ca.crt can come from this secret instead.</div></div>

</details>

