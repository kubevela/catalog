---
title: kibana
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/elasticsearch-operator/versions.json';

<AddonVersion data={versions} current="1.0.0" page="definitions/kibana" />

<!-- Generated from the definition. -->

kibana component

**Type:** component. **From:** the [elasticsearch-operator](/addons/catalog/elasticsearch-operator/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>config</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Config holds the Kibana configuration. See: https://www.elastic.co/guide/en/kibana/current/settings.html.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>count</code> <span className="addon-param-type">(null or int)</span></div><div className="addon-param-desc">Count of Kibana instances to deploy.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>elasticsearchRef</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">ElasticsearchRef is a reference to an Elasticsearch cluster running in the same Kubernetes cluster.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>enterpriseSearchRef</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">EnterpriseSearchRef is a reference to an EnterpriseSearch running in the same Kubernetes cluster. Kibana provides the default Enterprise Search UI starting version 7.14.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>http</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">HTTP holds the HTTP layer configuration for Kibana.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>image</code> <span className="addon-param-type">(null or string)</span></div><div className="addon-param-desc">Image is the Kibana Docker image to deploy.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>monitoring</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Monitoring enables you to collect and ship log and monitoring data of this Kibana. See https://www.elastic.co/guide/en/kibana/current/xpack-monitoring.html. Metricbeat and Filebeat are deployed in the same Pod as sidecars and each one sends data to one or two different Elasticsearch monitoring clusters running in the same Kubernetes cluster.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>podTemplate</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">PodTemplate provides customisation options (labels, annotations, affinity rules, resource requests, and so on) for the Kibana pods.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>revisionHistoryLimit</code> <span className="addon-param-type">(null or int)</span></div><div className="addon-param-desc">RevisionHistoryLimit is the number of revisions to retain to allow rollback in the underlying Deployment.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>secureSettings</code> <span className="addon-param-type">(null or list)</span></div><div className="addon-param-desc">SecureSettings is a list of references to Kubernetes secrets containing sensitive configuration options for Kibana.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>serviceAccountName</code> <span className="addon-param-type">(null or string)</span></div><div className="addon-param-desc">ServiceAccountName is used to check access from the current resource to a resource (for ex. Elasticsearch) in a different namespace. Can only be used if ECK is enforcing RBAC on references.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>version</code> <span className="addon-param-type">(null or string)</span></div><div className="addon-param-desc">Version of Kibana.</div></div>
