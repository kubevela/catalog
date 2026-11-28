---
title: Crossplane
---

The Crossplane addon installs [Crossplane](https://crossplane.io), which turns the cluster into a control plane for
infrastructure: providers' managed resources, and composite APIs your platform defines on top of them. It installs either
major version of Crossplane, with the definitions to match:

| Definition | Type | Crossplane | What it does |
| --- | --- | --- | --- |
| [`crossplane-provider`](#providers-and-functions) | Component | 1 and 2 | A Provider package |
| [`crossplane-function`](#providers-and-functions) | Component | 1 and 2 | A Function package |
| [`crossplane-xrd`](#composite-apis) | Component | 1 and 2, in each one's shape | A CompositeResourceDefinition: a new API and its schema |
| [`crossplane-composition`](#composite-apis) | Component | 1 and 2 | A pipeline Composition, the functions that build the API's resources |
| [`crossplane-activation-policy`](#activating-managed-resources) | Component | 2 only | A ManagedResourceActivationPolicy: which managed resources are switched on |

## Install

```shell
vela addon enable crossplane
```

This installs Crossplane `2.5.0` from `https://charts.crossplane.io/stable` into `crossplane-system`, on the hub cluster.
For Crossplane 1:

```shell
vela addon enable crossplane major=1
```

which installs `1.20.15` and the definitions in their 1.x shape. Check it is running:

```shell
vela status addon-crossplane -n vela-system
```

The addon supports KubeVela 1.12 or later. On KubeVela 1.11, enable the previous version instead:

```shell
vela addon enable crossplane --version 0.0.1
```

### Parameters

| Parameter | Default | Description |
| --- | --- | --- |
| `major` | `2` | Crossplane major version, `2` or `1`. It picks the pinned chart and the definitions. |
| `installWith` | `vela` | What installs the chart: `vela`, `flux` or `argo`; see [installing the chart](/addons/guides/chart-install). |
| `chartInstall` | `true` | Install the chart. `false` installs the definitions alone, for a Crossplane you run yourself: set `major` to the one you run. |
| `chart.version` | `2.5.0`, or `1.20.15` with `major=1` | Install another chart version within the major: `2.0.0` or later, or `1.20.0` or later. |
| `chart.repoURL` | `https://charts.crossplane.io/stable` | Install from a mirror of the chart repository. |
| `namespace` | `crossplane-system` | Namespace Crossplane is installed into. |
| `releaseName` | `crossplane` | Helm release to install, or to take over. |
| `replicas` | `1` | Replicas of the Crossplane Deployment. |
| `monitoring` | `false` | Expose Crossplane's metrics on its pods, for Prometheus to scrape. |
| `args` | the chart's | Extra Crossplane flags, e.g. `args='{--debug}'`. |
| `resources` | the chart's | CPU and memory `requests` and `limits` for the Crossplane pod. |
| `nodeSelector`, `tolerations`, `affinity`, `priorityClassName` | the chart's | Where Crossplane and its RBAC manager run. |
| `imageRegistry`, `imagePullSecrets` | `xpkg.crossplane.io` | A registry mirror for Crossplane's image, and Secrets with its credentials. |
| `packageCacheSize` | `20Mi` | Largest the package cache may grow. |
| `registryCaBundle` | none | `name` and `key` of a ConfigMap with a private package registry's CA bundle. |

A parameter left unset sends nothing to the chart, so the chart's own default applies. For a chart setting with no
parameter, the hidden `values` parameter passes [chart values](https://artifacthub.io/packages/helm/crossplane/crossplane?modal=values)
as they are, and overrides what the parameters set. Nothing checks them, so use it at your own risk.

A `chart.version` from the other major is refused, since the definitions would not match it:

```
chart.version 1.20.15 is major 1, but major 2 is selected: set major to match
```

If you already ran `helm install crossplane` into `crossplane-system`, the defaults adopt that release in place, with no
restart.

## Providers and functions

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: crossplane-packages
  namespace: vela-system
spec:
  components:
    - name: provider-aws-s3
      type: crossplane-provider
      properties:
        package: xpkg.crossplane.io/crossplane-contrib/provider-aws-s3:v2.10.0
    - name: function-patch-and-transform
      type: crossplane-function
      properties:
        package: xpkg.crossplane.io/crossplane-contrib/function-patch-and-transform:v0.8.2
```

Each is healthy once Crossplane reports it Installed and Healthy; until then its status names the condition that is not.
`runtimeConfig` names a DeploymentRuntimeConfig for the package's pods.

## Composite APIs

`crossplane-xrd` defines the API, and `crossplane-composition` says how to build it. On Crossplane 2 a composite is
namespaced by default, so teams create it directly in their own namespace:

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: config-api
  namespace: vela-system
spec:
  components:
    - name: xconfigs
      type: crossplane-xrd
      properties:
        group: platform.example.com
        names: {kind: XConfig, plural: xconfigs}
        versions:
          - name: v1alpha1
            schema:
              type: object
              properties:
                spec: {type: object, properties: {colour: {type: string}}}
    - name: xconfigs-configmap
      type: crossplane-composition
      dependsOn: [xconfigs]
      properties:
        compositeTypeRef: {apiVersion: platform.example.com/v1alpha1, kind: XConfig}
        pipeline:
          - step: render
            function: function-patch-and-transform
            input:
              apiVersion: pt.fn.crossplane.io/v1beta1
              kind: Resources
              resources:
                - name: cm
                  base: {apiVersion: v1, kind: ConfigMap, data: {colour: unset}}
                  readinessChecks: [{type: None}]
                  patches:
                    - {type: FromCompositeFieldPath, fromFieldPath: spec.colour, toFieldPath: data.colour}
```

The XRD is healthy once Crossplane has established its API, and offered its claim if it has one. Compositions run in
`Pipeline` mode on both majors: Crossplane 2 removed the native patch-and-transform mode, so the addon only writes the
mode that works on both.

### The XRD on each major

`crossplane-xrd` is one definition with a body per major, so an Application keeps its component type across an upgrade.
The fields differ:

| | `major=1` | `major=2` |
| --- | --- | --- |
| Writes | `apiextensions.crossplane.io/v1` | `apiextensions.crossplane.io/v2`; `v1` for `LegacyCluster` |
| Composite | Cluster-scoped | `scope`: `Namespaced` (default), `Cluster`, or `LegacyCluster` |
| Claims | `claimNames` | `claimNames` with `scope: LegacyCluster` only |

Each refuses the other's field rather than dropping it: `scope` on Crossplane 1, and `claimNames` without
`LegacyCluster` on Crossplane 2.

## Activating managed resources

Crossplane 2 installs a provider's managed resource types only once a ManagedResourceActivationPolicy activates them:

```yaml
    - name: s3
      type: crossplane-activation-policy
      properties:
        activate: ["*.s3.aws.m.upbound.io"]
```

The definition exists only with `major=2`.

## Moving from Crossplane 1 to 2

Crossplane supports upgrading 1.20 to 2.x in place. Before you do, follow
[Crossplane's upgrade guide](https://docs.crossplane.io/latest/guides/upgrade-to-crossplane-v2/): Crossplane 2 refuses
Compositions in the native patch-and-transform mode, ControllerConfigs and external secret stores, none of which the
addon's definitions write. Then:

```shell
vela addon upgrade crossplane major=2
```

The release is upgraded in place, and the addon's definitions change to their 2.x bodies, adding
`crossplane-activation-policy`. Your claims and composites keep working. Every XRD made on Crossplane 1 is
cluster-scoped, while `crossplane-xrd` on Crossplane 2 defaults to `scope: Namespaced`, and an XRD's scope cannot be
changed. So add `scope: LegacyCluster`, which keeps the API as it is, to every `crossplane-xrd` component before its next
change, with claims or without: one with `claimNames` is refused until you do, and one without would ask Crossplane to
change its scope.

```yaml
    - name: xconfigs
      type: crossplane-xrd
      properties:
        scope: LegacyCluster
        claimNames: {kind: Config, plural: configs}
        # ...as before
```

Moving to a namespaced API is a new XRD, migrated by Crossplane's own guide. Crossplane cannot be downgraded, so the
addon does not support `major=1` on a cluster that has run Crossplane 2.

### From the 0.0.1 experimental addon

The 0.0.1 addon installed Crossplane 1.8.1 through Flux, as the Helm release `vela-system-crossplane` in `vela-system`.
Crossplane upgrades one minor version at a time, so it cannot move straight to either pinned version. Upgrade Crossplane
to 1.20 by its own path first. Then suspend the `HelmRelease`, so Flux leaves the release alone when the upgrade removes
it, and upgrade the addon to take that release over:

```shell
kubectl -n vela-system patch helmrelease crossplane --type=merge -p '{"spec":{"suspend":true}}'
vela addon upgrade crossplane major=1 namespace=vela-system releaseName=vela-system-crossplane
```

## Uninstall

```shell
vela addon disable crossplane
```

Crossplane creates its own CRDs rather than shipping them in the chart, so they stay, with every composite and managed
resource. Remove providers' managed resources before disabling, or their cloud resources are left without a controller.
