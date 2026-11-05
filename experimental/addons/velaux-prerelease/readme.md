# VelaUX (prerelease)

A prerelease of VelaUX, the end-to-end application delivery and management experience for KubeVela: API services and the UI dashboard. It tracks the newest VelaUX alpha or release candidate; for production, use the stable `velaux` addon.

This addon needs KubeVela v1.11 or later.

## Switching from velaux

This addon replaces `velaux` and cannot run alongside it: both own the same `velaux` service, service account and cluster role binding. Disable one before enabling the other.

```shell
vela addon disable velaux
vela addon registry add experimental --type helm --endpoint=https://kubevela.github.io/catalog/experimental/
vela addon enable velaux-prerelease
```

To go back to the stable release:

```shell
vela addon disable velaux-prerelease
vela addon enable velaux
```

VelaUX keeps its data in the datastore, not in the addon, so it survives the switch in both directions as long as `dbType` and `database` stay the same.

The `dex` addon depends on `velaux`, so enabling it beside this addon tries to install the stable release and fails. Enable dex only with the stable addon for now.

## Parameters

| Parameter | Description |
| --- | --- |
| `enableCelExpressions` | Offer `$( )` CEL expression editing in forms. On by default; set it to `false` unless vela-core runs with the `EnableCelExpressions` feature gate, since forms otherwise save expressions the controller passes through as plain strings. |

The other parameters are the same as the `velaux` addon's.

## Feedback

- Create Issue: [https://github.com/kubevela/velaux/issues](https://github.com/kubevela/velaux/issues)
- Slack: [CNCF Slack](https://slack.cncf.io/) #kubevela channel
