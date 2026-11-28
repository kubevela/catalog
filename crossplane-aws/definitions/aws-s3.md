---
title: aws-s3
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/crossplane-aws/versions.json';

<AddonVersion data={versions} current="0.0.1" page="definitions/aws-s3" />

<!-- Generated from the definition. -->

AWS S3 Bucket

**Type:** component. **From:** the [crossplane-aws](/addons/catalog/crossplane-aws/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>name</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">The bucket name</div></div>
<div className="addon-param"><div className="addon-param-head"><code>acl</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">The canned ACL to apply to the bucket.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>locationConstraint</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">LocationConstraint specifies the Region where the bucket will be created.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>secretName</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Secret name which RDS connection will write to</div></div>
<div className="addon-param"><div className="addon-param-head"><code>providerConfigName</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>aws</code></span></div><div className="addon-param-desc">The ProviderConfig name</div></div>
