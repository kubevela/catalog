---
title: koordinator-pod-migration-job
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/koordinator/versions.json';

<AddonVersion data={versions} current="1.1.1" page="definitions/pod-migration-job" />

<!-- Generated from the definition. -->

koordinator pod migration job component

**Type:** component. **From:** the [koordinator](/addons/catalog/koordinator/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>paused</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>false</code></span></div><div className="addon-param-desc">Paused indicates whether the PodMigrationJob should to work or not.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>ttl</code> <span className="addon-param-type">(null or string)</span></div><div className="addon-param-desc">TTL controls the PodMigrationJob timeout duration.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>mode</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>PodMigrationJobModeReservationFirst</code></span></div><div className="addon-param-desc">Mode represents the operating mode of the Job.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>podRef</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">PodRef represents the Pod that be migrated.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>reservationOptions</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">ReservationOptions defines the Reservation options for migrated Pod.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>deleteOptions</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">DeleteOptions defines the deleting options for the migrated Pod and preempted Pods.</div></div>
