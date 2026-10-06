# DefKit

Installs [DefKit](https://github.com/kubevela/kubevela/tree/master/pkg/definition/defkit) definition modules as Applications. A module is a Go module of X-Definitions written with DefKit, such as [vela-go-definitions](https://github.com/kubevela/vela-go-definitions).

Each module is an Application whose workflow:

1. **renders** the module in a Job (`defkit-render`), the way `vela def apply-module` loads it, into a ConfigMap;
2. waits for **review** (optional, a `suspend` step);
3. **applies** the rendered definitions (`defkit-apply`), so the Application tracks them and garbage collects the ones a new version drops.

The render Job runs in the `vela-defkit` namespace, under an account that may only write ConfigMaps there.

## Install a module

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: defkit-vela-definitions
  namespace: vela-system
  labels:
    defkit.oam.dev/module: vela-definitions
spec:
  components: []
  workflow:
    steps:
      - name: render
        type: defkit-render
        properties:
          git: https://github.com/kubevela/vela-go-definitions
          version: main
          prefix: dk-        # optional: a prefix for every definition's name
          types: [trait]     # optional: only these kinds
        outputs:
          - name: rendered
            valueFrom: configMap
      - name: review
        type: suspend
      - name: apply
        type: defkit-apply
        inputs:
          - from: rendered
            parameterKey: configMap
```

`vela workflow resume -n vela-system defkit-vela-definitions` applies what was rendered. The full example is in `examples/`.

## Parameters

| Name | Default | Description |
| --- | --- | --- |
| `image` | `oamdev/defkit-render:v0.1.0` | Image of the render Job: Go plus `defkit-render` |
| `repositories` | vela-go-definitions | Repositories a UI offers when adding a module; a module can still come from anywhere |

## The render image

`render/` holds `defkit-render` and its Dockerfile. The image needs Go, since loading a module runs `go mod download` and `go run`.

```shell
docker buildx build --platform linux/amd64,linux/arm64 -t oamdev/defkit-render:v0.1.0 render/
```
