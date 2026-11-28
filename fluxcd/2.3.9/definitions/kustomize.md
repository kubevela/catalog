---
title: kustomize
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/fluxcd/versions.json';

<AddonVersion data={versions} current="2.3.9" page="definitions/kustomize" />

<!-- Generated from the definition. -->

kustomize can fetching, building, updating and applying Kustomize manifests from Git repo or Bucket or OCI repo.

**Type:** component. **From:** the [fluxcd](/addons/catalog/fluxcd/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>repoType</code> <span className="addon-param-type">git or oss or oci</span> <span className="addon-param-default">default <code>git</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>pullInterval</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>5m</code></span></div><div className="addon-param-desc">The interval at which to check for repository/bucket and release updates</div></div>
<div className="addon-param"><div className="addon-param-head"><code>url</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">The Git or Helm repository URL, OSS endpoint or OCI repo, accept HTTP/S or SSH address as git url</div></div>
<div className="addon-param"><div className="addon-param-head"><code>secretRef</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">The name of the secret containing authentication credentials</div></div>
<div className="addon-param"><div className="addon-param-head"><code>timeout</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">The timeout for operations like download index/clone repository, optional</div></div>
<div className="addon-param"><div className="addon-param-head"><code>sourceName</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">The name of the source already existed</div></div>
<div className="addon-param"><div className="addon-param-head"><code>path</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Path to the directory containing the kustomization.yaml file, or the set of plain YAMLs a kustomization.yaml should be generated for.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>prune</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>true</code></span></div><div className="addon-param-desc">Whether to delete objects that have already been applyed</div></div>
<div className="addon-param"><div className="addon-param-head"><code>suspend</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>false</code></span></div><div className="addon-param-desc">This flag tells the controller to suspend subsequent kustomize executions, it does not apply to already started executions.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>force</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>false</code></span></div><div className="addon-param-desc">Force instructs the controller to recreate resources when patching fails due to an immutable field change.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>targetNamespace</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">TargetNamespace sets or overrides the namespace in the kustomization.yaml file, optional</div></div>

<details>
<summary><code>imageRepository</code> (9) The image repository for automatically update image to git</summary>

<div className="addon-param"><div className="addon-param-head"><code>image</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">The image url</div></div>
<div className="addon-param"><div className="addon-param-head"><code>secretRef</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">The name of the secret containing authentication credentials</div></div>
<div className="addon-param"><div className="addon-param-head"><code>commitMessage</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">The image url</div></div>
<div className="addon-param"><div className="addon-param-head"><code>interval</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>5m</code></span></div><div className="addon-param-desc"></div></div>

<details>
<summary><code>policy</code> (3) Policy gives the particulars of the policy to be followed in selecting the most recent image.</summary>


<details>
<summary><code>alphabetical</code> (1) Alphabetical set of rules to use for alphabetical ordering of the tags.</summary>

<div className="addon-param"><div className="addon-param-head"><code>order</code> <span className="addon-param-type">asc or desc</span></div><div className="addon-param-desc">Given the letters of the alphabet as tags, ascending order would select Z, and descending order would select A.</div></div>

</details>


<details>
<summary><code>numerical</code> (1) Numerical set of rules to use for numerical ordering of the tags.</summary>

<div className="addon-param"><div className="addon-param-head"><code>order</code> <span className="addon-param-type">asc or desc</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Given the integer values from 0 to 9 as tags, ascending order would select 9, and descending order would select 0.</div></div>

</details>


<details>
<summary><code>semver</code> (1) SemVer gives a semantic version range to check against the tags available.</summary>

<div className="addon-param"><div className="addon-param-head"><code>range</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Range gives a semver range for the image tag; the highest version within the range that's a tag yields the latest image.</div></div>

</details>


</details>


<details>
<summary><code>filterTags</code> (2) FilterTags enables filtering for only a subset of tags based on a set of rules. If no rules are provided, all the tags from the repository will be ordered and compared.</summary>

<div className="addon-param"><div className="addon-param-head"><code>extract</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Extract allows a capture group to be extracted from the specified regular expression pattern, useful before tag evaluation.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>pattern</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Pattern specifies a regular expression pattern used to filter for image tags.</div></div>

</details>


</details>


<details>
<summary><code>git</code> (2)</summary>

<div className="addon-param"><div className="addon-param-head"><code>branch</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>master branch</code></span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">The Git reference to checkout and monitor for changes</div></div>
<div className="addon-param"><div className="addon-param-head"><code>provider</code> <span className="addon-param-type">GitHub or AzureDevOps</span> <span className="addon-param-default">default <code>GitHub</code></span></div><div className="addon-param-desc">Determines which git client library to use. Defaults to GitHub, it will pick go-git. AzureDevOps will pick libgit2.</div></div>

</details>


<details>
<summary><code>oss</code> (3)</summary>

<div className="addon-param"><div className="addon-param-head"><code>bucketName</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">The bucket's name, required if repoType is oss</div></div>
<div className="addon-param"><div className="addon-param-head"><code>provider</code> <span className="addon-param-type">generic or aws</span> <span className="addon-param-default">default <code>generic</code></span></div><div className="addon-param-desc">"generic" for Minio, Amazon S3, Google Cloud Storage, Alibaba Cloud OSS, "aws" for retrieve credentials from the EC2 service when credentials not specified, default "generic"</div></div>
<div className="addon-param"><div className="addon-param-head"><code>region</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">The bucket region, optional</div></div>

</details>


<details>
<summary><code>oci</code> (2)</summary>

<div className="addon-param"><div className="addon-param-head"><code>provider</code> <span className="addon-param-type">generic or azure or aws or gcp</span> <span className="addon-param-default">default <code>generic</code></span></div><div className="addon-param-desc">The OIDC provider used for authentication purposes.The generic provider can be used for public repositories or when static credentials are used for authentication, either with spec.secretRef or spec.serviceAccountName</div></div>
<div className="addon-param"><div className="addon-param-head"><code>tag</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>latest</code></span></div><div className="addon-param-desc">The image tag</div></div>

</details>

