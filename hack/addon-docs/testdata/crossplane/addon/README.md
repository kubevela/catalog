# Crossplane

Installs [Crossplane](https://crossplane.io), either major version, with definitions to match. The chart installs with
the built-in `helmchart` component on the hub cluster, or through Flux or Argo CD.

```shell
vela addon enable crossplane            # Crossplane 2.5.0
vela addon enable crossplane major=1    # Crossplane 1.20.15
```

| Definition | Type | Crossplane |
| --- | --- | --- |
| `crossplane-provider` | Component | 1 and 2 |
| `crossplane-function` | Component | 1 and 2 |
| `crossplane-xrd` | Component | 1 and 2, in each one's shape |
| `crossplane-composition` | Component | 1 and 2, pipeline mode |
| `crossplane-activation-policy` | Component | 2 only |

Needs KubeVela 1.12 or later. On 1.11, enable the previous version: `vela addon enable crossplane --version 0.0.1`.
Moving from 0.0.1 takes Crossplane to 1.20 by its own path first; see the
[addon docs](docs/index.md#from-the-001-experimental-addon).

`major` picks the pinned chart and the definitions. A `chart.version` override must stay within that major, at or above
`1.20.0` or `2.0.0`. Definitions that differ by major live in `variants/major/<n>/`, and
`hack/addon-optional/sync.sh` renders them into `resources/variant-major.cue`.

`crossplane-xrd` keeps one name on both majors, so an Application keeps its component type across an upgrade. On
Crossplane 2, `claimNames` needs `scope: LegacyCluster`, the 1.x shape that Crossplane 2 still serves, and so does every
XRD made on Crossplane 1, since an XRD's scope cannot change.

## Moving from Crossplane 1 to 2

Follow Crossplane's [upgrade guide](https://docs.crossplane.io/latest/guides/upgrade-to-crossplane-v2/) first, then:

```shell
vela addon upgrade crossplane major=2
```

The release upgrades in place and claims keep working. Add `scope: LegacyCluster` to any `crossplane-xrd` component
with `claimNames`. Downgrading is not supported.

## Tests

```shell
vela def test experimental/addons/crossplane/tests
```
