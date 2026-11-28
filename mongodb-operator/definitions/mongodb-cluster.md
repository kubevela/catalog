---
title: mongodb-cluster
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/mongodb-operator/versions.json';

<AddonVersion data={versions} current="0.3.0" page="definitions/mongodb-cluster" />

<!-- Generated from the definition. -->

mongodb cluster component

**Type:** component. **From:** the [mongodb-operator](/addons/catalog/mongodb-operator/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>password</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">The password for accessing the mongodb cluster.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>clusterSize</code> <span className="addon-param-type">int</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">The size of the mongodb cluster.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>image</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>quay.io/opstree/mongo:v5.0.6</code></span></div><div className="addon-param-desc">The image of the mongodb.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>imagePullPolicy</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>IfNotPresent</code></span></div><div className="addon-param-desc">The image pull policy to pull the image.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>mongoDBAdminUser</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">The admin user for accessing the mongodb cluster.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>storageClass</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">The storageClass name for the mongodb cluster.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>storageSize</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">The storageSize for the mongodb cluster.</div></div>
