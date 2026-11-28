---
title: Parameters
sidebar_position: 2
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/velero/versions.json';

<AddonVersion data={versions} current="0.0.1" page="parameters" />

<!-- Generated from the addon's parameter.cue. -->

Set them when you enable the addon, `vela addon enable velero <name>=<value>`, or in VelaUX's addon form.

<div className="addon-param"><div className="addon-param-head"><code>clusters</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Deploy to specified clusters. Leave empty to deploy to all clusters.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>chartUrl</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>https://vmware-tanzu.github.io/helm-charts</code></span></div><div className="addon-param-desc">Helm repo URL to find Velero chart. Specify it if you cannot access the default one.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>snapshotsEnabled</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>true</code></span></div><div className="addon-param-desc">Whether or not to enable volume snapshot feature.</div></div>

<details>
<summary><code>aws</code> (8) Use AWS for backup and snapshots. How to setup: https://github.com/vmware-tanzu/velero-plugin-for-aws#setup .</summary>

<div className="addon-param"><div className="addon-param-head"><code>bucket</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">The name of the bucket to store backups in.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>prefix</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">The prefix within the bucket under which to store backups.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>region</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">The AWS region where the bucket is located. Queried from the AWS S3 API if not provided. Optional if s3ForcePathStyle is false.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>accessKeyId</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Your AWS access key ID.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>secretAccessKey</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Your AWS secret access key.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>s3ForcePathStyle</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>false</code></span></div><div className="addon-param-desc">Whether to use path-style addressing instead of virtual hosted bucket addressing. Set to "true" if using a local storage service like MinIO.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>s3Url</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">You can specify the AWS S3 URL here for explicitness, but Velero can already generate it from "region" and "bucket". This field is primarily for local storage services like MinIO.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>insecureSkipTLSVerify</code> <span className="addon-param-type">bool</span></div><div className="addon-param-desc">Skip verifing the TLS certificate when connecting to the object store. Not recommended for production.</div></div>

</details>

