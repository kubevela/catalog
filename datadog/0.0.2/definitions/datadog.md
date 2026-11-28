---
title: datadog
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/datadog/versions.json';

<AddonVersion data={versions} current="0.0.2" page="definitions/datadog" />

<!-- Generated from the definition. -->

Add required env vars, annotations and host volume mount for datadog instrumentation

**Type:** trait. **From:** the [datadog](/addons/catalog/datadog/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>serviceName</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">DD service name</div></div>
<div className="addon-param"><div className="addon-param-head"><code>env</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">DD environment</div></div>
<div className="addon-param"><div className="addon-param-head"><code>version</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">DD version</div></div>
<div className="addon-param"><div className="addon-param-head"><code>mountPath</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>/var/run/datadog</code></span></div><div className="addon-param-desc">Mount path in container (default /var/run/datadog)</div></div>
<div className="addon-param"><div className="addon-param-head"><code>hostMountPath</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>/var/run/datadog</code></span></div><div className="addon-param-desc">Mount path on host (default /var/run/datadog)</div></div>
<div className="addon-param"><div className="addon-param-head"><code>volumeName</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>datadog</code></span></div><div className="addon-param-desc">Name of host mount volume (default datadog)</div></div>
<div className="addon-param"><div className="addon-param-head"><code>source</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Source for logging (added as an annotation 'ad.datadoghq.com/&lt;serviceName&gt;.logs: [&#123;"source":"&lt;this value&gt;"&#125;]' )</div></div>
<div className="addon-param"><div className="addon-param-head"><code>autoDependencyMap</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>false</code></span></div><div className="addon-param-desc">Auto-map standard dependencies to &lt;serviceName&gt;-dependency by setting DD_TRACE_SERVICE_MAPPING env var (default false)</div></div>
<div className="addon-param"><div className="addon-param-head"><code>autoDependencies</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>http-client,redis,sql-server,kafka,faulthandlingdb</code></span></div><div className="addon-param-desc">Comma-separated list of dependencies to be used by autoDependencyMap (default "http-client,redis,sql-server,kafka,faulthandlingdb")</div></div>
