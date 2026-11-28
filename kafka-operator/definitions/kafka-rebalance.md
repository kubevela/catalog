---
title: kafka-rebalance
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/kafka-operator/versions.json';

<AddonVersion data={versions} current="1.0.0" page="definitions/kafka-rebalance" />

<!-- Generated from the definition. -->

kafka rebalance component

**Type:** component. **From:** the [kafka-operator](/addons/catalog/kafka-operator/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>cluster</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>kafka-cluster</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>mode</code> <span className="addon-param-type">(null or string)</span></div><div className="addon-param-desc">Mode to run the rebalancing. The supported modes are full, add-brokers, remove-brokers. If not specified, the full mode is used by default.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>brokers</code> <span className="addon-param-type">(null or list)</span></div><div className="addon-param-desc">The list of newly added brokers in case of scaling up or the ones to be removed in case of scaling down to use for rebalancing. This list can be used only with rebalancing mode add-brokers and removed-brokers. It is ignored with full mode.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>goals</code> <span className="addon-param-type">(null or list)</span></div><div className="addon-param-desc">A list of goals, ordered by decreasing priority, to use for generating and executing the rebalance proposal. The supported goals are available at https://github.com/linkedin/cruise-control#goals. If an empty goals list is provided, the goals declared in the default.goals Cruise Control configuration parameter are used.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>skipHardGoalCheck</code> <span className="addon-param-type">(null or bool)</span></div><div className="addon-param-desc">Whether to allow the hard goals specified in the Kafka CR to be skipped in optimization proposal generation. This can be useful when some of those hard goals are preventing a balance solution being found. Default is false.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>rebalanceDisk</code> <span className="addon-param-type">(null or bool)</span></div><div className="addon-param-desc">Enables intra-broker disk balancing, which balances disk space utilization between disks on the same broker. Only applies to Kafka deployments that use JBOD storage with multiple disks. When enabled, inter-broker balancing is disabled. Default is false.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>excludedTopics</code> <span className="addon-param-type">(null or string)</span></div><div className="addon-param-desc">A regular expression where any matching topics will be excluded from the calculation of optimization proposals. This expression will be parsed by the java.util.regex.Pattern class; for more information on the supported format consult the documentation for that class.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>concurrentPartitionMovementsPerBroker</code> <span className="addon-param-type">(null or int)</span></div><div className="addon-param-desc">The upper bound of ongoing partition replica movements going into/out of each broker. Default is 5.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>concurrentIntraBrokerPartitionMovements</code> <span className="addon-param-type">(null or int)</span></div><div className="addon-param-desc">The upper bound of ongoing partition replica movements between disks within each broker. Default is 2.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>concurrentLeaderMovements</code> <span className="addon-param-type">(null or int)</span></div><div className="addon-param-desc">The upper bound of ongoing partition leadership movements. Default is 1000.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>replicationThrottle</code> <span className="addon-param-type">(null or int)</span></div><div className="addon-param-desc">The upper bound, in bytes per second, on the bandwidth used to move replicas. There is no limit by default.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>replicaMovementStrategies</code> <span className="addon-param-type">(null or list)</span></div><div className="addon-param-desc">A list of strategy class names used to determine the execution order for the replica movements in the generated optimization proposal. By default</div></div>
