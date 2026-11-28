---
title: azure-rg
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/crossplane-azure/versions.json';

<AddonVersion data={versions} current="0.0.1" page="definitions/azure-rg" />

<!-- Generated from the definition. -->

Azure Resource Group

**Type:** component. **From:** the [crossplane-azure](/addons/catalog/crossplane-azure/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>Name</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Specify the Resource Group name</div></div>
<div className="addon-param"><div className="addon-param-head"><code>Location</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Specify the location where the Resource Group will be created. Examples: "eastus", "centralindia", etc. Refer: https://azuretracks.com/2021/04/current-azure-region-names-reference/ for the Azure region names reference.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>providerConfigName</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>azure-provider</code></span></div><div className="addon-param-desc">The name of the Azure ProviderConfig to use. This should match the provider you configured for Azure</div></div>
