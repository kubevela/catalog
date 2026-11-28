---
title: crossplane-azure
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/crossplane-azure/versions.json';

<AddonVersion data={versions} current="0.0.1" page="definitions/crossplane-azure" />

<!-- Generated from the definition. -->

Azure Provider for Crossplane

**Type:** component. **From:** the [crossplane-azure](/addons/catalog/crossplane-azure/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>provider_name</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>azure-provider</code></span></div><div className="addon-param-desc">The name of Crossplane Provider for Azure. Specify a unique name</div></div>
<div className="addon-param"><div className="addon-param-head"><code>AZURE_APP_ID</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>AZURE_PASSWORD</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">The `password` field from the CLI output corresponds to `AZURE_PASSWORD`.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>AZURE_TENANT_ID</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">The `tenant` field from the CLI output corresponds to `AZURE_TENANT_ID`.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>AZURE_SUBSCRIPTION_ID</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"> The `subscriptionId` from the CLI output corresponds to `AZURE_SUBSCRIPTION_ID`.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>AZURE_AD_ENDPOINT</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>https://login.microsoftonline.com/</code></span></div><div className="addon-param-desc">The `activeDirectoryEndpointUrl` field</div></div>
<div className="addon-param"><div className="addon-param-head"><code>AZURE_RESOURCE_MANAGER_ENDPOINT</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>https://management.azure.com/</code></span></div><div className="addon-param-desc">The `resourceManagerEndpointUrl`</div></div>
<div className="addon-param"><div className="addon-param-head"><code>AZURE_AD_GRAPH_RESOURCE</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>https://graph.windows.net/</code></span></div><div className="addon-param-desc">The `activeDirectoryGraphResourceId`</div></div>
<div className="addon-param"><div className="addon-param-head"><code>AZURE_SQL_MANAGEMENT_ENDPOINT</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>https://management.core.windows.net:8443/</code></span></div><div className="addon-param-desc">The `sqlManagementEndpointUrl`</div></div>
<div className="addon-param"><div className="addon-param-head"><code>AZURE_GALLERY_ENDPOINT</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>https://gallery.azure.com/</code></span></div><div className="addon-param-desc">The `galleryEndpointUrl`</div></div>
<div className="addon-param"><div className="addon-param-head"><code>AZURE_MANAGEMENT_ENDPOINT</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>https://management.core.windows.net/</code></span></div><div className="addon-param-desc">The `managementEndpointUrl`</div></div>
