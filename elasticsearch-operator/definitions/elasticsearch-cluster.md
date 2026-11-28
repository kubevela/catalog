---
title: elasticsearch-cluster
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/elasticsearch-operator/versions.json';

<AddonVersion data={versions} current="1.0.0" page="definitions/elasticsearch-cluster" />

<!-- Generated from the definition. -->

elasticsearch cluster component

**Type:** component. **From:** the [elasticsearch-operator](/addons/catalog/elasticsearch-operator/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>auth</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Auth contains user authentication and authorization security settings for Elasticsearch.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>http</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">HTTP holds HTTP layer settings for Elasticsearch.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>image</code> <span className="addon-param-type">(null or string)</span></div><div className="addon-param-desc">Image is the Elasticsearch Docker image to deploy.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>monitoring</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Monitoring enables you to collect and ship log and monitoring data of this Elasticsearch cluster. See https://www.elastic.co/guide/en/elasticsearch/reference/current/monitor-elasticsearch-cluster.html. Metricbeat and Filebeat are deployed in the same Pod as sidecars and each one sends data to one or two different Elasticsearch monitoring clusters running in the same Kubernetes cluster.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>nodeSets</code> <span className="addon-param-type">(null or list)</span></div><div className="addon-param-desc">NodeSets allow specifying groups of Elasticsearch nodes sharing the same configuration and Pod templates.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>podDisruptionBudget</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">PodDisruptionBudget provides access to the default pod disruption budget for the Elasticsearch cluster. The default budget selects all cluster pods and sets `maxUnavailable` to 1. To disable, set `PodDisruptionBudget` to the empty value (`&#123;&#125;` in YAML).</div></div>
<div className="addon-param"><div className="addon-param-head"><code>remoteClusters</code> <span className="addon-param-type">(null or list)</span></div><div className="addon-param-desc">RemoteClusters enables you to establish uni-directional connections to a remote Elasticsearch cluster.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>revisionHistoryLimit</code> <span className="addon-param-type">(null or int)</span></div><div className="addon-param-desc">RevisionHistoryLimit is the number of revisions to retain to allow rollback in the underlying StatefulSets.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>secureSettings</code> <span className="addon-param-type">(null or list)</span></div><div className="addon-param-desc">SecureSettings is a list of references to Kubernetes secrets containing sensitive configuration options for Elasticsearch.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>serviceAccountName</code> <span className="addon-param-type">(null or list)</span></div><div className="addon-param-desc">ServiceAccountName is used to check access from the current resource to a resource (for ex. a remote Elasticsearch cluster) in a different namespace. Can only be used if ECK is enforcing RBAC on references.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>transport</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Transport holds transport layer settings for Elasticsearch.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>updateStrategy</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">UpdateStrategy specifies how updates to the cluster should be performed.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>version</code> <span className="addon-param-type">(null or string)</span></div><div className="addon-param-desc">Version of Elasticsearch.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>volumeClaimDeletePolicy</code> <span className="addon-param-type">(null or string)</span> <span className="addon-param-default">default <code>DeleteOnScaledownAndClusterDeletion</code></span></div><div className="addon-param-desc">VolumeClaimDeletePolicy sets the policy for handling deletion of PersistentVolumeClaims for all NodeSets. Possible values are DeleteOnScaledownOnly and DeleteOnScaledownAndClusterDeletion.</div></div>
