# backstage

This is a backstage addon for KubeVela.

## Installation

```shell
vela addon registry add experimental --type=helm --endpoint=https://addons.kubevela.net/experimental/
vela addon enable backstage
```

If you want to test it locally, you can run the port-forward command and choose `backstage-plugin-vela` component:

```shell
vela port-forward addon-backstage -n vela-system
```


## How to build my own backstage?

This is a [demo repo](https://github.com/wonderflow/vela-backstage-demo) of my own backstage app. Below is the steps that how I create this repo.

1. Create backstage app by:

```
npx @backstage/create-app
```

You can refer to the [doc of backstage for details](https://backstage.io/docs/getting-started/create-an-app).

2. Add dockerfile and build images

The dockerfile is already added inside the demo repo. You can read [this doc](https://github.com/wonderflow/vela-backstage-demo#build-docker-image) to learn how to build and run this image.

You can refer to [this PR #1](https://github.com/wonderflow/vela-backstage-demo/pull/1) to learn the detail changes from initial commit.

3. Use Entity Provider for Vela Integrations

We will leverage the [external integrations](https://backstage.io/docs/features/software-catalog/external-integrations) mechanism and works as a `Custom Entity Providers`.

You can refer to [this PR #2](https://github.com/wonderflow/vela-backstage-demo/pull/2) to learn the detail changes.

4. Build and Push Image

Prepare a [makefile](https://github.com/wonderflow/vela-backstage-demo/blob/main/Makefile) like the demo repo and replace the image with yours. Then run the following command:

```
make build-push
```

Make sure you've updated the `app-config.yaml` with the target service endpoint.

Check the detail config in this [commit](https://github.com/wonderflow/vela-backstage-demo/commit/e703bc2ce96e3813ac9a535e223d5db503c6f6fb).

5. Update the image when enable the addon

```
vela addon enable backstage image="<my-backstage-image>"
```