---
title: crossplane-aws
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/crossplane-aws/versions.json';

<AddonVersion data={versions} current="0.0.1" page="definitions/crossplane-aws" />

<!-- Generated from the definition. -->

AWS Provider for Crossplane

**Type:** component. **From:** the [crossplane-aws](/addons/catalog/crossplane-aws/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>name</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>default</code></span></div><div className="addon-param-desc">The name of Crossplane Provider AWS</div></div>
<div className="addon-param"><div className="addon-param-head"><code>AWS_ACCESS_KEY_ID</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Get AWS_ACCESS_KEY_ID per https://aws.amazon.com/blogs/security/wheres-my-secret-access-key/</div></div>
<div className="addon-param"><div className="addon-param-head"><code>AWS_SECRET_ACCESS_KEY</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Get AWS_SECRET_ACCESS_KEY per https://aws.amazon.com/blogs/security/wheres-my-secret-access-key/</div></div>
