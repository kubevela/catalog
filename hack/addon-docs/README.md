# addon-docs

Generates each addon's pages for the [KubeVela docs site](https://kubevela.io/addons/catalog/) from the catalog
itself: its overview from `metadata.yaml`, its parameters from `parameter.cue`, a page per definition, its guides from
`docs/` (or its README), and a versions page, for every published version back to the oldest KubeVela release the
docs cover. CI runs it after each publish and pushes the result to the `docs-site` branch, which the site fetches when
it builds.

It is a Go module of its own because it reads definitions with KubeVela's own parsers; the catalog's other tooling
doesn't need KubeVela. It builds on KubeVela's newest release (no alphas, betas or release candidates):
`pin-kubevela.sh` finds it from kubevela/kubevela's tags and rewrites `go.mod` with it and its replace block. The
publish job runs it before every generation; run it here to move the checked-in pin, which the tests use, and
`pin-kubevela.sh --check` to see whether it is behind.

## Run it

```shell
cd hack/addon-docs
go run . -out /tmp/addon-docs                 # every addon with release tags
go run . -out /tmp/addon-docs cert-manager    # one addon
```

To see the result on the site, build kubevela.github.io with `ADDON_CATALOG_DIR=/tmp/addon-docs yarn build`.

## What to change where

| To change | Edit |
| --- | --- |
| An addon's pages | The addon's own files: `metadata.yaml`, `+usage` comments in `parameter.cue` and its definitions, `docs/*.md` |
| An addon's category or logo | `overrides.yaml`, until `metadata.yaml` carries them |
| The KubeVela releases covered, or when the newest stops being "Next" | `config.yaml`, on each KubeVela minor release |
| What the pages look like | `render.go`; then `UPDATE_GOLDEN=1 go test ./...` and review the goldens' diff |

An addon's `docs/_intro.md` joins its overview; `docs/index.md` is its guide; any other `docs/*.md` is a page of its
own. Links in `docs/` must be absolute site paths (`/docs/...`, `/addons/...`), which `hack/addon-check/check.sh` checks.

## Tests

`go test ./...` renders cert-manager and Crossplane from `testdata/` and compares them with their goldens, and checks
which KubeVela releases each addon version is for.
