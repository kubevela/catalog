---
title: azure-storage-account
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/crossplane-azure/versions.json';

<AddonVersion data={versions} current="0.0.1" page="definitions/azure-storage-account" />

<!-- Generated from the definition. -->

Azure Storage Account

**Type:** component. **From:** the [crossplane-azure](/addons/catalog/crossplane-azure/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>Name</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Specify the name of the Storage Account. Ensure it's less than 24 characters.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>ResourceGroupName</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">The name of the Resource Group where the Storage Account will be created.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>Kind</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>Storage</code></span></div><div className="addon-param-desc">The kind of Storage Account to create. Possible values: "Storage", "BlobStorage".</div></div>
<div className="addon-param"><div className="addon-param-head"><code>Location</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Location where the Storage Account will be created (e.g., "East US", "West US").</div></div>
<div className="addon-param"><div className="addon-param-head"><code>SKU_Name</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>Standard_LRS</code></span></div><div className="addon-param-desc">The SKU of the Storage Account. Valid values: "Standard_LRS", "Standard_GRS", "Standard_RAGRS", "Standard_ZRS", "Premium_LRS".</div></div>
<div className="addon-param"><div className="addon-param-head"><code>providerConfigName</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>azure-provider</code></span></div><div className="addon-param-desc">The name of the Azure ProviderConfig to use. This should match the provider you configured for Azure</div></div>
<div className="addon-param"><div className="addon-param-head"><code>secretName</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Optional secret name to store the connection details of the Storage Account.</div></div>
