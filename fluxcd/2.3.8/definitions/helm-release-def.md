---
title: helm
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/fluxcd/versions.json';

<AddonVersion data={versions} current="2.3.8" page="definitions/helm-release-def" />

<!-- Generated from the definition. -->

helm release is a group of K8s resources from either git repository or helm repo

**Type:** component. **From:** the [fluxcd](/addons/catalog/fluxcd/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>repoType</code> <span className="addon-param-type">helm or git or oss or oci</span> <span className="addon-param-default">default <code>helm</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>pullInterval</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>5m</code></span></div><div className="addon-param-desc">The interval at which to check for repository/bucket and release updates</div></div>
<div className="addon-param"><div className="addon-param-head"><code>interval</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>30s</code></span></div><div className="addon-param-desc">The  Interval at which to reconcile the Helm release</div></div>
<div className="addon-param"><div className="addon-param-head"><code>url</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">The Git or Helm repository URL, OSS endpoint, accept HTTP/S or SSH address as git url,</div></div>
<div className="addon-param"><div className="addon-param-head"><code>secretRef</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">The name of the secret containing authentication credentials</div></div>
<div className="addon-param"><div className="addon-param-head"><code>timeout</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">The timeout for operations like download index/clone repository, optional</div></div>
<div className="addon-param"><div className="addon-param-head"><code>installTimeout</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>10m</code></span></div><div className="addon-param-desc">The timeout for operation `helm install`, optional</div></div>
<div className="addon-param"><div className="addon-param-head"><code>sourceName</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">The name of the source already existed</div></div>
<div className="addon-param"><div className="addon-param-head"><code>valuesFiles</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Alternative list of values files to use as the chart values (values.yaml is not included by default), expected to be a relative path in the SourceRef.Values files are merged in the order of this list with the last file overriding the first.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>chart</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">1.The relative path to helm chart for git/oss source. 2. chart name for helm resource 3. relative path for chart package(e.g. ./charts/podinfo-1.2.3.tgz)</div></div>
<div className="addon-param"><div className="addon-param-head"><code>version</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>*</code></span></div><div className="addon-param-desc">Chart version</div></div>
<div className="addon-param"><div className="addon-param-head"><code>targetNamespace</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">The namespace for helm chart, optional</div></div>
<div className="addon-param"><div className="addon-param-head"><code>releaseName</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">The release name</div></div>
<div className="addon-param"><div className="addon-param-head"><code>retries</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>3</code></span></div><div className="addon-param-desc">Retry times when install/upgrade fail.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>values</code> <span className="addon-param-type">map&#91;string&#93;any</span></div><div className="addon-param-desc">Chart values</div></div>
<div className="addon-param"><div className="addon-param-head"><code>upgradeCRD</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>false</code></span></div><div className="addon-param-desc"></div></div>

<details>
<summary><code>git</code> (1)</summary>

<div className="addon-param"><div className="addon-param-head"><code>branch</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>main</code></span></div><div className="addon-param-desc">The Git reference to checkout and monitor for changes</div></div>

</details>


<details>
<summary><code>oss</code> (3)</summary>

<div className="addon-param"><div className="addon-param-head"><code>bucketName</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">The bucket's name, required if repoType is oss</div></div>
<div className="addon-param"><div className="addon-param-head"><code>provider</code> <span className="addon-param-type">generic or azure or aws or gcp</span> <span className="addon-param-default">default <code>generic</code></span></div><div className="addon-param-desc">"generic" for Minio, Amazon S3, Google Cloud Storage, Alibaba Cloud OSS, "aws" for retrieve credentials from the EC2 service when credentials not specified, default "generic"</div></div>
<div className="addon-param"><div className="addon-param-head"><code>region</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">The bucket region, optional</div></div>

</details>


<details>
<summary><code>helmrepository</code> (1)</summary>

<div className="addon-param"><div className="addon-param-head"><code>provider</code> <span className="addon-param-type">generic or azure or aws or gcp</span> <span className="addon-param-default">default <code>generic</code></span></div><div className="addon-param-desc">The OIDC provider used for authentication purposes.The generic provider can be used for public repositories or when static credentials are used for authentication, either with spec.secretRef or spec.serviceAccountName</div></div>

</details>


<details>
<summary><code>valuesFrom[]</code> (5) valuesFrom holds references to resources containing Helm values for this HelmRelease, and information about how they should be merged.</summary>

<div className="addon-param"><div className="addon-param-head"><code>kind</code> <span className="addon-param-type">Secret or ConfigMap</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Kind of the values referent, valid values are ('Secret', 'ConfigMap').</div></div>
<div className="addon-param"><div className="addon-param-head"><code>name</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Name of the values referent. Should reside in the same namespace as the referring resource.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>valuesKey</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>'values.yaml'</code></span></div><div className="addon-param-desc">ValuesKey is the data key where the values.yaml or a specific value can be found at.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>targetPath</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>'None', which results in the values getting merged at the root</code></span></div><div className="addon-param-desc">TargetPath is the YAML dot notation path the value should be merged at. When set, the ValuesKey is expected to be a single flat value.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>optional</code> <span className="addon-param-type">bool</span></div><div className="addon-param-desc">Optional marks this ValuesReference as optional. When set, a not found error or the values reference is ignored, but any ValuesKey, TargetPath or transient error will still result in a reconciliation failure.</div></div>

</details>

