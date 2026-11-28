---
title: azure-keyvault-csi
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/azure-keyvault-csi/versions.json';

<AddonVersion data={versions} current="0.0.3" page="definitions/azure-keyvault-csi" />

<!-- Generated from the definition. -->

Add filesystem-mounted values from Azure KeyVault, using Azure key vault provider for secrets store csi driver which must be installed separately, see https://azure.github.io/secrets-store-csi-driver-provider-azure/docs/getting-started/installation/

**Type:** trait. **From:** the [azure-keyvault-csi](/addons/catalog/azure-keyvault-csi/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>keyvaultName</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">The Azure KeyVault to connect to</div></div>
<div className="addon-param"><div className="addon-param-head"><code>subscriptionId</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">The Azure subscriptionId for access to the KeyVault</div></div>
<div className="addon-param"><div className="addon-param-head"><code>tenantId</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">The Azure tenantId for access to the KeyVault</div></div>
<div className="addon-param"><div className="addon-param-head"><code>userAssignedIdentityID</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">The Azure ClientID of the Managed Identity for access to the KeyVault</div></div>

<details>
<summary><code>keys[]</code> (3) What to use from the KeyVault.</summary>

<div className="addon-param"><div className="addon-param-head"><code>name</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Keyvault key</div></div>
<div className="addon-param"><div className="addon-param-head"><code>type</code> <span className="addon-param-type">secret or key or cert</span> <span className="addon-param-default">default <code>secret</code></span></div><div className="addon-param-desc">"secret" (default).  Or "key" or "cert" if key contains a certificate - see https://azure.github.io/secrets-store-csi-driver-provider-azure/docs/configurations/getting-certs-and-keys/#how-to-obtain-the-certificate</div></div>
<div className="addon-param"><div className="addon-param-head"><code>alias</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Changed name to use for mounted secret file, if omitted, will be value of name</div></div>

</details>

