---
title: elasticsearch-apm-server
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/elasticsearch-operator/versions.json';

<AddonVersion data={versions} current="1.0.0" page="definitions/elasticsearch-apm-server" />

<!-- Generated from the definition. -->

elasticsearch apm server component

**Type:** component. **From:** the [elasticsearch-operator](/addons/catalog/elasticsearch-operator/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>config</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Config holds the APM Server configuration. See: https://www.elastic.co/guide/en/apm/server/current/configuring-howto-apm-server.html.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>count</code> <span className="addon-param-type">(null or int)</span></div><div className="addon-param-desc">Count of APM Server instances to deploy.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>elasticsearchRef</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">ElasticsearchRef is a reference to the output Elasticsearch cluster running in the same Kubernetes cluster.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>image</code> <span className="addon-param-type">(null or string)</span></div><div className="addon-param-desc">Image is the APM Server Docker image to deploy.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>kibanaRef</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">KibanaRef is a reference to a Kibana instance running in the same Kubernetes cluster. It allows APM agent central configuration management in Kibana.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>podTemplate</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">PodTemplate provides customisation options (labels, annotations, affinity rules, resource requests, and so on) for the APM Server pods.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>revisionHistoryLimit</code> <span className="addon-param-type">(null or int)</span></div><div className="addon-param-desc">RevisionHistoryLimit is the number of revisions to retain to allow rollback in the underlying Deployment.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>secureSettings</code> <span className="addon-param-type">(null or list)</span></div><div className="addon-param-desc">SecureSettings is a list of references to Kubernetes secrets containing sensitive configuration options for APM Server.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>serviceAccountName</code> <span className="addon-param-type">(null or string)</span></div><div className="addon-param-desc">ServiceAccountName is used to check access from the current resource to a resource (for ex. Elasticsearch) in a different namespace. Can only be used if ECK is enforcing RBAC on references.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>version</code> <span className="addon-param-type">(null or string)</span></div><div className="addon-param-desc">Version of the APM Server.</div></div>
