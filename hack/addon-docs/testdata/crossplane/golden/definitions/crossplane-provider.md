---
title: crossplane-provider
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/crossplane/versions.json';

<AddonVersion data={versions} current="1.0.0" page="definitions/crossplane-provider" />

<!-- Generated from the definition. -->

A Crossplane Provider package, installed from its OCI image.

**Type:** component. **From:** the [crossplane](/addons/catalog/crossplane/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>package</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">OCI image of the package, e.g. xpkg.crossplane.io/crossplane-contrib/provider-aws-s3:v2.10.0</div></div>
<div className="addon-param"><div className="addon-param-head"><code>runtimeConfig</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Name of a DeploymentRuntimeConfig for the package's pods</div></div>
<div className="addon-param"><div className="addon-param-head"><code>packagePullPolicy</code> <span className="addon-param-type">IfNotPresent or Always or Never</span> <span className="addon-param-default">default <code>IfNotPresent</code></span></div><div className="addon-param-desc">When to pull the package image</div></div>
<div className="addon-param"><div className="addon-param-head"><code>revisionActivationPolicy</code> <span className="addon-param-type">Automatic or Manual</span> <span className="addon-param-default">default <code>Automatic</code></span></div><div className="addon-param-desc">Automatic activates each new revision; Manual keeps the current one active until you set the new revision's desiredState to Active</div></div>
<div className="addon-param"><div className="addon-param-head"><code>revisionHistoryLimit</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>1</code></span></div><div className="addon-param-desc">Inactive revisions to keep</div></div>
