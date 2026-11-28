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
| [`crossplane-runtime-config`](#running-a-packages-pods) | Trait | 1 and 2 | Its own DeploymentRuntimeConfig for a provider or function |
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
| `imageRegistry` | `xpkg.crossplane.io` | A registry mirror for Crossplane's image. |
| `imagePullSecrets` | none | Secrets with the mirror's credentials. |
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
        repository: crossplane-contrib/provider-aws-s3
        version: v2.10.0
    - name: function-patch-and-transform
      type: crossplane-function
      properties:
        repository: crossplane-contrib/function-patch-and-transform
        version: v0.8.2
```

A package is named by `repository` and `version`, on `xpkg.crossplane.io` unless `registry` names another, such as a
mirror. Or give the whole reference as `package` instead, which is how to pin one by digest:
`package: xpkg.crossplane.io/crossplane-contrib/provider-aws-s3@sha256:...`.

Each is healthy once Crossplane reports it Installed and Healthy; until then its status names the condition that is not.
Its details name the package actually running and its current revision.
`runtimeConfig` names a DeploymentRuntimeConfig that already exists, such as one the platform team shares.

### Running a package's pods

The `crossplane-runtime-config` trait gives one provider or function its own DeploymentRuntimeConfig, named after the
component, and points the package at it. Most packages run fine without it; reach for it when a provider needs a cloud
role, more resources, or extra flags:

```yaml
    - name: provider-aws-s3
      type: crossplane-provider
      properties:
        repository: crossplane-contrib/provider-aws-s3
        version: v2.10.0
      traits:
        - type: crossplane-runtime-config
          properties:
            serviceAccount:
              annotations:
                eks.amazonaws.com/role-arn: arn:aws:iam::123456789012:role/crossplane-s3
            resources:
              requests: {cpu: 100m, memory: 256Mi}
            args: [--debug]
```

| Parameter | Default | Description |
| --- | --- | --- |
| `serviceAccount.name` | Crossplane's | Service account the package's pods run as. |
| `serviceAccount.annotations` | none | Annotations on it, such as the cloud role for IRSA. |
| `replicas` | `1` | Replicas of the package's Deployment. |
| `resources` | none | CPU and memory `requests` and `limits` for the package's container. |
| `args` | none | Extra flags, e.g. `--debug` or `--poll=10m`. |
| `nodeSelector` | none | Node labels the package's pods must run on. |

A service account with a cloud role grants whatever that role can do, so keep the trait to the teams that manage
providers. It refuses a package that already sets `runtimeConfig`: use one or the other. Changing it restarts the
package's pods.

## Composite APIs

`crossplane-xrd` defines the API, and `crossplane-composition` says how to build it. On Crossplane 2 the XRD's
`scope` is required, since it cannot change once the XRD exists. A `Namespaced` composite is created directly in a
team's own namespace:

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
        scope: Namespaced
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

The XRD is healthy once Crossplane has established its API, and offered its claim if it has one; its details give the
`apiVersion` and `kind` to write a Composition and composites against. Compositions run in `Pipeline` mode on both
majors: Crossplane 2 removed the native patch-and-transform mode, so the addon only writes the mode that works on both.

A Composition has no health of its own: Crossplane checks each version of it on a CompositionRevision, which the addon
does not create, so the component only says what it builds and with which functions. To see Crossplane's verdict, read
the revisions:

```shell
kubectl get compositionrevisions -l crossplane.io/composition-name=xconfigs-configmap \
  -o 'custom-columns=NAME:.metadata.name,REVISION:.spec.revision,SYNCED:.status.conditions[0].status,MESSAGE:.status.conditions[0].message'
```

The composites built from it are where Crossplane reports how they are doing: `Synced` once the pipeline has run, and
`Ready` once every composed resource is ready, as each resource's `readinessChecks` or a function such as
function-auto-ready decide. A Composition can copy fields back from its resources onto the composite's status with
`ToCompositeFieldPath` patches.

### Offering the API to teams

Offer the API to teams as a component definition of its own: parameters named and checked for that API, with their
own descriptions and form, a description that says what it is for, and details drawn from the status the Composition
writes. The status block is the same for every composite: healthy once Crossplane reports it `Synced` and `Ready`,
with Crossplane's message until then, such as `Unready resources: bucket`:

```cue
"config": {
	type:        "component"
	description: "A ConfigMap of the team's colour, from the platform's XConfig API."
	attributes: {
		workload: type: "autodetects.core.oam.dev"
		status: {
			healthPolicy: #"""
				_conditions: *context.output.status.conditions | []
				isHealth: len([for c in _conditions if (c.type == "Synced" || c.type == "Ready") && c.status == "True" {c}]) == 2
				"""#
			customStatus: #"""
				_conditions: *context.output.status.conditions | []
				_down: [for t in ["Synced", "Ready"] for c in _conditions if c.type == t && c.status != "True" {c}]
				message: [
					for c in _down if c.message != _|_ if c.message != "" {c.message},
					for c in _down if c.reason != _|_ {"\(c.type): \(c.reason)"},
					if len([for c in _conditions if (c.type == "Synced" || c.type == "Ready") && c.status == "True" {c}]) == 2 {"Ready"},
					"Waiting for Crossplane",
				][0]
				"""#
			// Fields the Composition copies onto the composite's status, with ToCompositeFieldPath.
			details: #"""
				if context.output.status.configMapName != _|_ {configMap: context.output.status.configMapName}
				"""#
		}
	}
}

template: {
	output: {
		apiVersion: "platform.example.com/v1alpha1"
		kind:       "XConfig"
		metadata: name: context.name
		spec: colour: parameter.colour
	}

	parameter: {
		// +usage=Colour to write to the ConfigMap
		colour: *"blue" | "green" | "red"
	}
}
```

Apply it with `vela def apply config.cue`, and teams write `type: config` with `colour: green`. Ship it in an addon
of your own beside the XRD and Composition, so the API and its definition are versioned together.

### The XRD on each major

`crossplane-xrd` is one definition with a body per major, so an Application keeps its component type across an upgrade.
The fields differ:

| | `major=1` | `major=2` |
| --- | --- | --- |
| Writes | `apiextensions.crossplane.io/v1` | `apiextensions.crossplane.io/v2`; `v1` for `LegacyCluster` |
| Composite | `scope`: `LegacyCluster` only, the default, and not written | `scope`, required: `Namespaced`, `Cluster`, or `LegacyCluster` |
| Claims | `claimNames` | `claimNames` with `scope: LegacyCluster` only |

`LegacyCluster` is Crossplane 2's name for how every Crossplane 1 XRD behaves: cluster-scoped composites, with an
optional namespaced claim. Crossplane 1 has no `scope` field, so its body takes `scope: LegacyCluster` and writes
nothing, which lets one Application run on both majors. Each refuses what the other cannot do: `Namespaced` or
`Cluster` on Crossplane 1, and `claimNames` without `LegacyCluster` on Crossplane 2.

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
addon's definitions write. Add `scope: LegacyCluster` to every `crossplane-xrd` component, with claims or without. On
Crossplane 1 it renders the same XRD, so nothing changes:

```yaml
    - name: xconfigs
      type: crossplane-xrd
      properties:
        scope: LegacyCluster
        claimNames: {kind: Config, plural: configs}
        # ...as before
```

Then:

```shell
vela addon upgrade crossplane major=2
```

The release is upgraded in place, and the addon's definitions change to their 2.x bodies, adding
`crossplane-activation-policy`. Your claims and composites keep working. On Crossplane 2
`crossplane-xrd` requires `scope`, since an XRD's scope cannot be changed. A component you missed keeps running as it
is until its Application next changes; from then it fails to render, naming `parameter.scope`, and nothing is applied,
so the XRD is left as it is until you add `scope: LegacyCluster`.

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
