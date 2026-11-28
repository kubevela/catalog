---
title: Parameters
sidebar_position: 2
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/velaux-prerelease/versions.json';

<AddonVersion data={versions} current="1.12.0-alpha.1" page="parameters" />

<!-- Generated from the addon's parameter.cue. -->

Set them when you enable the addon, `vela addon enable velaux-prerelease <name>=<value>`, or in VelaUX's addon form.

<div className="addon-param"><div className="addon-param-head"><code>repo</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Specify the image hub of velaux</div></div>
<div className="addon-param"><div className="addon-param-head"><code>dbType</code> <span className="addon-param-type">kubeapi or mongodb or mysql or postgres</span> <span className="addon-param-default">default <code>kubeapi</code></span></div><div className="addon-param-desc">Specify the database type, current support KubeAPI(default), MongoDB, MySQL, Postgres.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>database</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Specify the database name, for the kubeapi db type, it represents namespace.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>dbURL</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Specify the Database connection URL. it is not used when dbType is "kubeapi", Format reference: https://kubevela.io/docs/reference/addons/velaux/</div></div>
<div className="addon-param"><div className="addon-param-head"><code>domain</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Specify the domain, if set, ingress will be created if the gateway driver is nginx.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>secretName</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Specify the name of the certificate cecret, if set, means enable the HTTPs.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>gatewayDriver</code> <span className="addon-param-type">nginx or traefik</span> <span className="addon-param-default">default <code>nginx</code></span></div><div className="addon-param-desc">Specify the gateway type.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>serviceAccountName</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>kubevela-ux</code></span></div><div className="addon-param-desc">Specify the serviceAccountName for apiserver</div></div>
<div className="addon-param"><div className="addon-param-head"><code>serviceType</code> <span className="addon-param-type">ClusterIP or NodePort or LoadBalancer</span> <span className="addon-param-default">default <code>ClusterIP</code></span></div><div className="addon-param-desc">Specify the service type.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>imagePullSecrets</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Specify the names of imagePullSecret for private image registry, eg. "&#123;a,b,c&#125;"</div></div>
<div className="addon-param"><div className="addon-param-head"><code>replicas</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>1</code></span></div><div className="addon-param-desc">Specify the replicas.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>nodePort</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>30000</code></span></div><div className="addon-param-desc">Specify nodeport. This will be ignored if serviceType is not NodePort.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>enableImpersonation</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>false</code></span></div><div className="addon-param-desc">Enable impersonation means impersonating the login user to request the KubeAPI.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>enableCelExpressions</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>true</code></span></div><div className="addon-param-desc">Offer $( ) CEL expression editing in forms. On by default; set it to false unless vela-core runs with the EnableCelExpressions feature gate.</div></div>
