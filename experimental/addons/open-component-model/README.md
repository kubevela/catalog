# open-component-model

[Open Component Model (OCM)](https://ocm.software) packages software as signed, location-independent component versions.
This addon installs the [OCM controller](https://github.com/open-component-model/open-component-model/tree/main/bindings/go/kubernetes/controller),
which resolves, verifies and replicates component versions in the cluster. KubeVela then orchestrates the delivered resources.

Not to be confused with the `ocm-cluster-manager` addon, which is Open Cluster Management.

## Install

```shell
vela addon registry add experimental --type helm --endpoint=https://kubevela.github.io/catalog/experimental
vela addon enable experimental/open-component-model
```

Install into a different namespace:

```shell
vela addon enable experimental/open-component-model namespace=my-ocm
```

## Usage

The addon provides two component types:

- `ocm-component` resolves a component version from an OCM repository.
- `ocm-resource` resolves and verifies one resource of that component version.
  `additionalStatusFields` publishes values from the resource under `status.additional`, so other components can consume them.

This application ([examples/open-component-model/app.yaml](../../../examples/open-component-model/app.yaml)) resolves the published OCM CLI component and runs its image as a job.
The job's `image` comes from the verified, digest-pinned reference in the component version.

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: ocm-cli-demo
spec:
  components:
    - name: ocm-cli
      type: ocm-component
      properties:
        repository:
          type: OCIRegistry
          baseUrl: ghcr.io/open-component-model
        component: ocm.software/cli
        semver: 0.23.0
    - name: ocm-cli-image
      type: ocm-resource
      dependsOn: [ocm-cli]
      properties:
        componentRef: ocm-cli
        resource:
          name: image
        additionalStatusFields:
          image: resource.access.imageReference
      outputs:
        - name: image
          valueFrom: output.status.additional.image
    - name: ocm-version
      type: task
      dependsOn: [ocm-cli-image]
      inputs:
        - from: image
          parameterKey: image
      properties:
        image: placeholder
        cmd: ["/ocm", "version"]
```

```shell
$ vela status ocm-cli-demo
...
  - Name: ocm-cli-image
    Type: ocm-resource
    Health: ✅
      Message: image from ocm.software/cli:0.23.0
...
$ kubectl logs job/ocm-cli-demo-ocm-version
OCM CLI (Open Component Model v2)
  Version:  0.23.0
```

Use `vela show ocm-component` and `vela show ocm-resource` for all parameters.

## Requirements

KubeVela v1.11.0 or later, for the native `helmchart` component.
