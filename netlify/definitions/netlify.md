---
title: netlify
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/netlify/versions.json';

<AddonVersion data={versions} current="10.5.2" page="definitions/netlify" />

<!-- Generated from the definition. -->

Netlify component.

**Type:** component. **From:** the [netlify](/addons/catalog/netlify/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>backofflimit</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>5</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>completions</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>1</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>sitname</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>deploy-from-vela</code></span></div><div className="addon-param-desc">Specify the website name on app.netlify.com</div></div>
<div className="addon-param"><div className="addon-param-head"><code>token</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>your-own-token-after-base64</code></span></div><div className="addon-param-desc">Specify the token got from app.netlify.com</div></div>
<div className="addon-param"><div className="addon-param-head"><code>reponame</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>oeular.github.io</code></span></div><div className="addon-param-desc">Specify the direcotry name for saving the resources from git or other repo supporting git-cli</div></div>
<div className="addon-param"><div className="addon-param-head"><code>gitrepo</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>https://github.com/oeular/oeular.github.io.git</code></span></div><div className="addon-param-desc">Specify the repo address your resources of the frontend service  store</div></div>
<div className="addon-param"><div className="addon-param-head"><code>restartPolicy</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>OnFailure</code></span></div><div className="addon-param-desc"></div></div>
