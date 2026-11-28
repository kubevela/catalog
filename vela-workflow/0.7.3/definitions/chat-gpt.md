---
title: chat-gpt
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/vela-workflow/versions.json';

<AddonVersion data={versions} current="0.7.3" page="definitions/chat-gpt" />

<!-- Generated from the definition. -->

Send request to chat-gpt

**Type:** workflow-step. **From:** the [vela-workflow](/addons/catalog/vela-workflow/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>token</code> <span className="addon-param-type">object</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>model</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>gpt-3.5-turbo</code></span></div><div className="addon-param-desc">The model name</div></div>
<div className="addon-param"><div className="addon-param-head"><code>timeout</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>30s</code></span></div><div className="addon-param-desc"></div></div>

<details>
<summary><code>prompt</code> (3) the prompt to use</summary>

<div className="addon-param"><div className="addon-param-head"><code>type</code> <span className="addon-param-type">custom or diagnose or audit or quality-gate</span> <span className="addon-param-default">default <code>custom</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>lang</code> <span className="addon-param-type">English or Chinese</span> <span className="addon-param-default">default <code>English</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>content</code> <span className="addon-param-type">(string or struct)</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>

</details>

