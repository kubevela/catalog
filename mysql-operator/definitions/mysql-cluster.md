---
title: mysql-cluster
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/mysql-operator/versions.json';

<AddonVersion data={versions} current="0.6.2" page="definitions/mysql-cluster" />

<!-- Generated from the definition. -->

**Type:** component. **From:** the [mysql-operator](/addons/catalog/mysql-operator/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>scname</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>mysql-sc</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>provisioner</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>kubernetes.io/no-provisioner</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>storage</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>2Gi</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>pvname</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>mysql-pv</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>mysqlname</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>namespace</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>db</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>dXNlcmRi</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>passwd</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>dXNlcnBhc3Nz</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>rootpasswd</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>bm90LXNvLXNlY3VyZQ==</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>user</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>dXNlcm5hbWU=</code></span></div><div className="addon-param-desc"></div></div>
