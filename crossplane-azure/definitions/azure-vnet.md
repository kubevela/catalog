---
title: azure-vnet
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/crossplane-azure/versions.json';

<AddonVersion data={versions} current="0.0.1" page="definitions/azure-vnet" />

<!-- Generated from the definition. -->

Azure Virtual Network

**Type:** component. **From:** the [crossplane-azure](/addons/catalog/crossplane-azure/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>Name</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Specify the name of the Virtual Network.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>ResourceGroupName</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Specify the name of the Resource Group. Ensure that it exists already in the Azure Account.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>Location</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Specify the location/region where you want your Virtual Network to be created. Examples: "eastus", "centralindia", etc. Refer: https://azuretracks.com/2021/04/current-azure-region-names-reference/ for the Azure region names reference.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>AddressPrefixes</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Specify the address space for the Virtual Network. This defines the range of IP addresses your network can use. You can provide more than one address space if needed. Example: ["10.0.0.0/16", "10.1.0.0/16"].</div></div>
<div className="addon-param"><div className="addon-param-head"><code>providerConfigName</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>azure-provider</code></span></div><div className="addon-param-desc">The name of the Azure ProviderConfig to use. This should match the provider you configured for Azure</div></div>
