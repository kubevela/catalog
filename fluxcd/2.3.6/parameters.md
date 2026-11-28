---
title: Parameters
sidebar_position: 2
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/fluxcd/versions.json';

<AddonVersion data={versions} current="2.3.6" page="parameters" />

<!-- Generated from the addon's parameter.cue. -->

Set them when you enable the addon, `vela addon enable fluxcd <name>=<value>`, or in VelaUX's addon form.

<div className="addon-param"><div className="addon-param-head"><code>registry</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Base URL for images that the FluxCD controllers use, e.g. ghcr.io</div></div>
<div className="addon-param"><div className="addon-param-head"><code>clusters</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Deploy to specified clusters. Leave empty to deploy to all clusters.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>namespace</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>flux-system</code></span></div><div className="addon-param-desc">Namespace to deploy to</div></div>
<div className="addon-param"><div className="addon-param-head"><code>onlyHelmComponents</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>false</code></span></div><div className="addon-param-desc">OnlyHelmComponents only enable helm associated components</div></div>
<div className="addon-param"><div className="addon-param-head"><code>helmControllerOptions</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Advanced options for Helm Controller</div></div>
<div className="addon-param"><div className="addon-param-head"><code>sourceControllerOptions</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Advanced options for Source Controller</div></div>
<div className="addon-param"><div className="addon-param-head"><code>kustomizeControllerOptions</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Advanced options for Kustomize Controller</div></div>
<div className="addon-param"><div className="addon-param-head"><code>imageReflectorControllerOptions</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Advanced options for Image Reflector Controller</div></div>
<div className="addon-param"><div className="addon-param-head"><code>imageAutomationControllerOptions</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Advanced options for Image Automation Controller</div></div>
