---
title: elasticsearch-enterprise-search
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/elasticsearch-operator/versions.json';

<AddonVersion data={versions} current="1.0.0" page="definitions/elasticsearch-enterprise-search" />

<!-- Generated from the definition. -->

elasticsearch enterprise search

**Type:** component. **From:** the [elasticsearch-operator](/addons/catalog/elasticsearch-operator/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>config</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Config holds the Enterprise Search configuration.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>configRef</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">ConfigRef contains a reference to an existing Kubernetes Secret holding the Enterprise Search configuration. Configuration settings are merged and have precedence over settings specified in `config`.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>count</code> <span className="addon-param-type">(null or int)</span></div><div className="addon-param-desc">Count of Enterprise Search instances to deploy.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>elasticsearchRef</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">ElasticsearchRef is a reference to the Elasticsearch cluster running in the same Kubernetes cluster.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>http</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">HTTP holds the HTTP layer configuration for Enterprise Search resource.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>image</code> <span className="addon-param-type">(null or string)</span></div><div className="addon-param-desc">Image is the Enterprise Search Docker image to deploy.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>podTemplate</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">PodTemplate provides customisation options (labels, annotations, affinity rules, resource requests, and so on) for the Enterprise Search pods.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>revisionHistoryLimit</code> <span className="addon-param-type">(null or int)</span></div><div className="addon-param-desc">RevisionHistoryLimit is the number of revisions to retain to allow rollback in the underlying Deployment.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>serviceAccountName</code> <span className="addon-param-type">(null or string)</span></div><div className="addon-param-desc">ServiceAccountName is used to check access from the current resource to a resource (for ex. Elasticsearch) in a different namespace. Can only be used if ECK is enforcing RBAC on references.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>version</code> <span className="addon-param-type">(null or string)</span></div><div className="addon-param-desc">Version of Enterprise Search.</div></div>
