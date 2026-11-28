---
title: redis-failover
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/redis-operator/versions.json';

<AddonVersion data={versions} current="0.0.1" page="definitions/redis-failover" />

<!-- Generated from the definition. -->

RedisFailover represents a Redis failover

**Type:** component. **From:** the [redis-operator](/addons/catalog/redis-operator/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>replicas</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>3</code></span></div><div className="addon-param-desc">Number of replicas for redis and sentinel instances.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>password</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Provide a Redis password to enable authorization.</div></div>

<details>
<summary><code>persistence</code> (3) Persistence-related settings.</summary>

<div className="addon-param"><div className="addon-param-head"><code>enabled</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>false</code></span></div><div className="addon-param-desc">Persist to pvc. Note that data will still be deleted once redis-failover is deleted.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>size</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Pvc size.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>keepAfterDeletion</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>false</code></span></div><div className="addon-param-desc">Keep pvc even if redis-failover is deleted.</div></div>

</details>

