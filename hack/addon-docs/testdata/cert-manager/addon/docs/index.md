---
title: cert-manager
---

The cert-manager addon installs [cert-manager](https://cert-manager.io), which issues and renews TLS certificates from
Let's Encrypt and other ACME servers, your own CA, or self-signed. It gives application teams two definitions, and the
platform an opt-in policy for choosing issuers per namespace:

| Definition | Type | What it does |
| --- | --- | --- |
| [`issuer`](#issuer) | Component | A ClusterIssuer or Issuer: ACME, self-signed, or a CA |
| [`certificate`](#certificate) | Trait | A Certificate for a component, written to a Secret its gateway or ingress serves |
| [`cert-manager-default-issuer`](#a-namespace-chooses-its-issuer) | Global policy, opt-in | Lets a namespace choose the issuer its certificates use. Installed only with `namespaceIssuers=true` |

:::info
Version 3.0.0 of the addon needs KubeVela 1.12 (v1.12.0-alpha.3 or later). It installs cert-manager with the built-in
[`helmchart`](/docs/next/end-user/components/references#helmchart) component and no longer needs the fluxcd addon. Coming from 2.x? See
[Upgrading from 2.x](#upgrading-from-2x).
:::

## Install

```shell
vela addon enable cert-manager
```

This installs cert-manager chart `v1.21.3` from `https://charts.jetstack.io` into the `cert-manager` namespace, on every
cluster KubeVela manages. Check it is running:

```shell
vela status addon-cert-manager -n vela-system
```

The addon needs Kubernetes 1.33 or later, the oldest release cert-manager 1.21 supports, and KubeVela 1.12 or later:
from 1.12, the `helmchart` component installs a release on each cluster a topology picks, rather than on the hub. On
KubeVela 1.11, enable the previous version instead:

```shell
vela addon enable cert-manager --version 2.2.0
```

### Parameters

| Parameter | Default | Description |
| --- | --- | --- |
| `installWith` | `vela` | What installs the chart: `vela`, `flux` or `argo`. See [Installing with Flux or Argo CD](#installing-with-flux-or-argo-cd). |
| `chartInstall` | `true` | Install the chart. `false` installs the definitions alone, for a cert-manager you run yourself. |
| `chart.version` | `v1.21.3` | Install another chart version, `v1.15.0` or later. See [Chart version](#chart-version). |
| `chart.repoURL` | `https://charts.jetstack.io` | Install from a mirror of the chart repository. |
| `namespace` | `cert-manager` | Namespace cert-manager is installed into. |
| `clusters` | every cluster | Clusters to install on, e.g. `clusters='{local,edge-1}'`. |
| `namespaceIssuers` | `false` | Install the `cert-manager-default-issuer` global policy. See [A namespace chooses its issuer](#a-namespace-chooses-its-issuer). |
| `releaseName` | `cert-manager` | Helm release to install, or to take over. See [Upgrading from 2.x](#upgrading-from-2x). |
| `replicas` | `1` | Replicas of each cert-manager Deployment: the controller, the webhook and the CA injector. |
| `highAvailability` | `false` | A PodDisruptionBudget for each Deployment, so drains keep it available. Needs `replicas` of 2 or more. |
| `monitoring` | `false` | A ServiceMonitor for cert-manager's metrics. Needs the Prometheus operator's CRDs. |
| `keepCRDs` | `true` | Keep the CRDs, and every certificate and issuer, when the addon is disabled. |
| `resources` | the chart's | CPU and memory `requests` and `limits` for each pod. |
| `nodeSelector`, `tolerations`, `affinity`, `priorityClassName` | the chart's | Where cert-manager's pods run, applied to each of them. |
| `imageRegistry`, `imagePullSecrets` | `quay.io` | A registry mirror to pull the images from, and Secrets with its credentials. |
| `featureGates` | the chart's | cert-manager feature gates, e.g. `featureGates.ServerSideApply=true`. |
| `dns01Nameservers` | the cluster's | DNS servers to check DNS01 challenges against, e.g. `dns01Nameservers='{1.1.1.1:53}'`. |
| `certificateOwnerRef` | `false` | Delete a certificate's Secret when the certificate is deleted. |

A parameter left unset sends nothing to the chart, so the chart's own default applies. For a chart setting with no
parameter, the hidden `values` parameter is a free-form override of the [chart's values](https://artifacthub.io/packages/helm/cert-manager/cert-manager/1.21.3?modal=values),
applied over what the parameters set, e.g. `values.podDnsPolicy=None`. Nothing checks it, so use it at your own risk.

The addon installs and upgrades the chart's CRDs with it, and keeps them when the addon is disabled, so certificates
already issued survive. Set `keepCRDs=false` to have them removed with the addon.

### Installing with Flux or Argo CD

By default the chart installs with KubeVela's built-in `helmchart` component. If your platform runs its charts through
Flux or Argo CD, the addon can hand cert-manager to them instead, and you keep their drift detection, history and
dashboards:

| `installWith` | The addon creates | Needs |
| --- | --- | --- |
| `vela` (default) | The Helm release, through `helmchart` | Nothing else |
| `flux` | A `HelmRepository` and a `HelmRelease` in `vela-system` | Flux 2.3 or later (the catalog's fluxcd addon runs 2.1, too old): its source and helm controllers |
| `argo` | An Argo CD `Application` in the `argocd` namespace, syncing automatically | Argo CD |

```shell
vela addon enable cert-manager installWith=flux
```

The addon cannot depend on Flux or Argo CD only when you choose them, so install those first: with their own addons or
however you run them. Every installer keeps the Helm release in the target namespace under the same name: `cert-manager`,
or `releaseName` if you set it.

#### Switching installer

| From | To | What happens |
| --- | --- | --- |
| `helm install`, or `vela` | `flux` | Flux adopts the release in place. |
| `flux` | `argo` | Flux uninstalls the release when its HelmRelease goes, and Argo CD installs again: cert-manager is down for a few seconds. Certificates and CRDs are kept. |
| `argo` | `vela` | Not supported yet: Helm refuses objects Argo CD applied. |

`vela addon upgrade` keeps the parameters you set before, so to install the chart after `chartInstall=false`, pass `chartInstall=true` too.

## Already running cert-manager

| You installed cert-manager with | Enable the addon with |
| --- | --- |
| `helm install cert-manager` into the `cert-manager` namespace | The defaults. The addon adopts the Helm release in place, with no reinstall. |
| Anything else: your own Flux or Argo CD app, OLM, your cloud provider | `chartInstall=false`. The addon installs the definitions only, and the install stays where it is. |

```shell
vela addon enable cert-manager chartInstall=false
```

With `chartInstall=false` the addon does not check which version you run. The definitions use `cert-manager.io/v1`, which
every cert-manager release since 1.0 serves.

### Chart version

Each version of the addon pins the cert-manager chart it was tested with, and `vela addon upgrade cert-manager` moves
you to the next pinned version. To take a cert-manager patch release before the addon does, or to install from a
mirror:

```shell
vela addon enable cert-manager chart.version=v1.21.4 chart.repoURL=https://charts.example.com/jetstack
```

An overridden version is yours to test: the definitions are checked against the pinned one. The addon refuses anything
older than `v1.15.0`, the first chart with the `crds.enabled` and `crds.keep` values it sets; an older chart would
install cert-manager without its CRDs.

## Issuer

An issuer is where certificates come from. The `issuer` component creates a ClusterIssuer, which every namespace can
use, or with `scope: namespace` an Issuer in the Application's namespace. It takes exactly one of `acme`, `selfSigned`
or `ca`.

### Let's Encrypt over HTTP-01

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: letsencrypt
  namespace: vela-system
spec:
  components:
    - name: letsencrypt
      type: issuer
      properties:
        acme:
          email: ops@example.com
          http01:
            ingressClassName: traefik
```

`server` defaults to Let's Encrypt production. Use `server: staging` while you test, since production rate-limits
failed orders, or give the directory URL of another ACME server. To route the challenge through a Gateway rather than an
ingress class, use `http01.gateway: {name: public, namespace: gateways}`.

### Let's Encrypt over DNS-01

DNS-01 is needed for wildcard certificates. Create the credentials as a Secret first. For a ClusterIssuer, cert-manager
reads it from its own namespace:

```shell
kubectl create secret generic cloudflare -n cert-manager --from-literal=api-token=<token>
```

```yaml
    - name: letsencrypt-dns
      type: issuer
      properties:
        acme:
          email: ops@example.com
          dns01:
            cloudflare:
              apiTokenSecretRef:
                name: cloudflare
                key: api-token
```

For Route53, give `dns01.route53.region`. Leave out `accessKeyIDSecretRef` and `secretAccessKeySecretRef` to use the
pod's own AWS credentials (IRSA or EKS Pod Identity).

### Self-signed and CA

```yaml
    - name: selfsigned
      type: issuer
      properties:
        selfSigned: {}
    - name: internal-ca
      type: issuer
      properties:
        ca:
          secretName: internal-root-ca   # holds tls.crt and tls.key
```

The component is healthy once cert-manager reports the issuer `Ready`; until then its status message is cert-manager's
own, such as `Failed to register ACME account`.

## Certificate

The `certificate` trait asks an issuer for a certificate for its component:

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: shop
spec:
  components:
    - name: shop
      type: webservice
      properties:
        image: shop:1.0
      traits:
        - type: certificate
          properties:
            dnsNames: [shop.example.com]
            issuerRef:
              name: letsencrypt
```

| Property | Default | Description |
| --- | --- | --- |
| `dnsNames` | required | Host names the certificate covers. |
| `secretName` | `<component>-tls` | Secret the certificate and key are written to. |
| `issuerRef.name` | the [default issuer](#the-default-issuer) | Issuer to use. |
| `issuerRef.kind` | `ClusterIssuer` | `ClusterIssuer`, or `Issuer` for one in the Application's namespace. |
| `duration` | the issuer's | Lifetime to request, e.g. `2160h`. |
| `renewBefore` | cert-manager's | How long before expiry to renew, e.g. `360h`. |

The trait is healthy once the certificate is issued, and its status details carry `secretName`, so a gateway or ingress
trait can point at it.

## The default issuer

Most teams should not need to know which issuer the platform uses. A `certificate` trait without `issuerRef` uses the
ClusterIssuer named `default`, so the platform team creates its default issuer under that name:

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: default-issuer
  namespace: vela-system
spec:
  components:
    - name: default
      type: issuer
      properties:
        acme:
          email: ops@example.com
          http01:
            ingressClassName: traefik
```

Until a ClusterIssuer named `default` exists, a certificate that relies on it stays not ready, with cert-manager's
message in the trait status.

### A namespace chooses its issuer

The `cert-manager-default-issuer` global policy lets a namespace pick another issuer with an annotation, for the
certificates of every Application in it that names none. A global policy runs for every Application on the cluster, so
it is opt-in. It needs global policies enabled in vela-core:

```shell
helm upgrade kubevela kubevela/vela-core -n vela-system --reuse-values \
  --set featureGates.enableApplicationScopedPolicies=true \
  --set featureGates.enableGlobalPolicies=true
vela addon enable cert-manager namespaceIssuers=true
```

| Annotation on the Namespace | Issuer |
| --- | --- |
| `cert-manager.oam.dev/cluster-issuer: <name>` | The ClusterIssuer `<name>` |
| `cert-manager.oam.dev/issuer: <name>` | The Issuer `<name>` in that namespace |

```shell
kubectl annotate namespace team-a cert-manager.oam.dev/cluster-issuer=letsencrypt-team-a
```

An Application's own `issuerRef` always wins. The policy reads the namespace once per reconcile, and only for
Applications that use the `certificate` trait. A namespace with both annotations is refused, since neither can be the
intended one: its Applications report `namespace <name> sets both cert-manager.oam.dev/issuer and
cert-manager.oam.dev/cluster-issuer; keep one`.

:::caution
Setting `namespaceIssuers=false` later does not remove the policy. Delete it yourself:
`kubectl -n vela-system delete policydefinition cert-manager-default-issuer`.
:::

## Upgrading from 2.x

Version 2.x installed cert-manager `v1.9.1` through the fluxcd addon, as a Flux `HelmRelease` whose Helm release is
called `cert-manager-cert-manager`. 3.0.0 takes that release over and upgrades it in place to `v1.21.3`, so the CRDs,
and every Issuer, Certificate and Secret in them, stay where they are throughout.

Two things have to happen before the upgrade: the `HelmRelease` on every cluster 2.x deployed to is suspended, so that
Flux leaves the release alone when the upgrade removes it, and the addon is told the release's name. The addon ships an Application that does both.

### Preparing with the upgrade Application

```shell
kubectl apply -f https://raw.githubusercontent.com/kubevela/catalog/master/addons/cert-manager/upgrade/from-2.x.yaml
vela status cert-manager-upgrade-from-2x -n vela-system
```

Once it is `running`, upgrade the addon naming the release to take over, then delete the Application. In VelaUX, set
**Release Name** under the advanced install settings and choose **Upgrade**.

```shell
vela addon upgrade cert-manager releaseName=cert-manager-cert-manager
kubectl delete -f https://raw.githubusercontent.com/kubevela/catalog/master/addons/cert-manager/upgrade/from-2.x.yaml
```

The Application runs two Jobs, each as a ServiceAccount allowed only the objects it writes. First, on every cluster,
`suspend` suspends the `cert-manager` HelmRelease, refusing one the addon did not create. Then, on the hub, `store`
stores `releaseName` in the addon's parameters (the `addon-secret-cert-manager` Secret) and removes the 2.x ones,
including the `dns01` API token. An addon enabled without parameters has none stored, so there is nothing to
remove. It refuses an addon that is not 2.x, and running it again after the upgrade changes
nothing. If a Job fails, its log says why:

```shell
kubectl -n vela-system logs job/cert-manager-upgrade-from-2x-suspend   # on the cluster it failed on
kubectl -n vela-system logs job/cert-manager-upgrade-from-2x-store
```

Download the file and edit it first if you set either 2.x parameter:

| 2.x parameter | Change in `from-2.x.yaml` |
| --- | --- |
| `namespace` | `cert-manager` in both `NAMESPACE` variables, and in the Role and RoleBinding that live in that namespace |
| `clusters` | The `every-cluster` policy: replace `clusterLabelSelector: {}` with `clusters: [...]`, the same list |

### Preparing by hand

Without the Application, suspend the `HelmRelease` yourself, on every cluster 2.x deployed to:

```shell
kubectl -n cert-manager patch helmrelease cert-manager --type=merge -p '{"spec":{"suspend":true}}'
```

Then upgrade, naming the release to take over:

```shell
vela addon upgrade cert-manager releaseName=cert-manager-cert-manager
```

`vela addon upgrade` remembers `releaseName`, so you only pass it once.

:::warning
Do not skip the suspend. Without it, Flux uninstalls the release as soon as the upgrade removes its `HelmRelease`, and
cert-manager is down until KubeVela installs it again.
:::

If you upgrade without preparing, nothing changes and the addon reports that Helm refused the install:

```
CustomResourceDefinition "challenges.acme.cert-manager.io" in namespace "" exists and cannot be imported into the
current release: invalid ownership metadata
```

That is the 2.x release still owning the CRDs. Prepare, then upgrade again.

### What changes

| 2.x | 3.0.0 |
| --- | --- |
| Needs the fluxcd addon | Needs nothing else. Disable fluxcd once nothing else uses it. |
| `dns01` made a `letsencrypt` ClusterIssuer, a Certificate and a token Secret | Those are left running, released from the addon: they are yours now. New issuers are the [`issuer`](#issuer) component's, with credentials in a Secret you create. |
| `dns01.alidns` installed the alidns webhook | The webhook is left running, released from the addon. 3.0.0 does not install it. |
| `replicas` | Kept, and now sets the webhook and CA injector too. |
| `staging`, `installCRDs`, `upgradeCRD` | Accepted and ignored. CRDs are always installed and upgraded, and kept unless `keepCRDs=false`. |

The upgrade Application removes the 2.x parameters from the addon's stored parameters. Prepared by hand, they stay, since
`vela addon upgrade` cannot remove them. If you set `dns01`, its API token is among them, in the
`addon-secret-cert-manager` Secret in `vela-system`. 3.0.0 never reads it; remove it, keeping the other parameters, with
[jq](https://jqlang.org):

```shell
kubectl -n vela-system patch secret addon-secret-cert-manager --type=merge -p "{\"data\":{\"addonParameterDataKey\":\"$(
  kubectl -n vela-system get secret addon-secret-cert-manager -o jsonpath='{.data.addonParameterDataKey}' |
    base64 -d | jq -c 'del(.dns01)' | base64 | tr -d '\n')\"}}"
```

## Uninstall

```shell
vela addon disable cert-manager
```

cert-manager's CRDs, and every Certificate, Issuer and Secret, stay unless `keepCRDs` was `false`.
