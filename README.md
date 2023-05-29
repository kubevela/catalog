# KubeVela Catalog

KubeVela is a modern software delivery control plane to make deploying and operating applications across today's hybrid, multi-cloud environments easier, faster and more reliable. 

One of the core goals of KubeVela is to build an open, inclusive, and vibrant OSS developer community focused on solving real-world application delivery and operation problems, sharing the reusable building blocks and best practices.

Here's the catalog of the shared resources, we called them `addon`.

## Introduction

This repo is a catalog of [addons](https://kubevela.io/docs/reference/addons/overview) which extend the capability of KubeVela control plane. Generally, an addon consists of Kubernetes CRD and corresponding [X-definition](https://kubevela.net/docs/getting-started/definition), but none of them is necessary. For example, the [fluxcd](addons/fluxcd) addon consists of FluxCD controller and the `helm` component definition, while [VelaUX](addons/velaux) just deploy a web server without any CRD or Definitions.

There're basically two kinds of addons according to maturity. They're [verified addons](./addons) which have been tested for a long time can be used in product environment and [experimental addons](experimental/addons) which contain new features but still need more verification.

Community users can install and use these addons by the following way:

* [Verified Addons](/addons): when a pull request merged, the changes of these addon will be automatically packaged and synced to the OSS bucket, and serving in the [official addon registry](https://addons.kubevela.net). This will be displayed in vela CLI by `vela addon list` or VelaUX as follows.
  ![image](https://user-images.githubusercontent.com/2173670/160372119-3e62044c-ce93-428d-9681-a91f0742bbaf.png)


* [Experimental Addons](/experimental/addons): the experimental addons will also be packaged and synced to the OSS bucket automatically, but in the  `experimental` folder, you need to add the experimental registry manually to use it. 
  ```
  vela addon registry add experimental --type=helm --endpoint=https://addons.kubevela.net/experimental/
  ```

  ![image](https://user-images.githubusercontent.com/2173670/160373204-80e74587-606c-4522-9802-11d4f572450b.png)

## How to use

> The https://addons.kubevela.net will be deprecated and changed to https://kubevela.github.io/catalog/official.
> You can run the following command to set up the new registry.
> ```shell
> vela addon registry delete KubeVela
> vela addon registry update KubeVela --type helm --endpoint=https://kubevela.github.io/catalog/official
> vela addon registry add experimental --type helm --endpoint=https://kubevela.github.io/catalog/experimental
> ```

You can enable these addons by vela command line by:

```
vela addon enable <official-addon-name>
vela addon enable experimental/<experimental-addon-name>
```

You can also enable addons by click the page on VelaUX.

Please refer to [doc](https://kubevela.io/docs/reference/addons/overview) for more infos.

## History versions

All versions of addons will be reserved in the OSS bucket, you can check the old versions and download in this page: https://addons.kubevela.net/index.yaml.

## Create an addon

To create an addon, you can use the following command to create an addon scaffold:

```
vela addon init <addon-name>
```

The best way to learn how to build an addon is follow existing examples:

- Addons consist of CRD controllers as helm chart, refer to [keda](./addons/keda/), [kruise-rollout](./addons/kruise-rollout/) or [trivy-operator](./addons/trivy-operator/) as examples.
- Addons consist of CRD controllers as a bunch of YAML files, refer to [vela-workflow](./addons/vela-workflow/)(written in CUE), [argocd](./experimental/addons/argocd/)(just YAMLs) and [clickhouse](./experimental/addons/clickhouse/)(reference URL) as examples.
- Addons consist of container images, refer to [vela](./addons/velaux/) and [backstage](./experimental/addons/backstage/) as examples.

You can refer [this doc](https://kubevela.io/docs/platform-engineers/addon/intro) to learn all details of how to make an addon and the mechanism behind it.

## Contribute an addon

All contributions are welcome, just send a pull request to this repo following the below rules:

- A new addon should be accepted as experimental one first with the following necessary information:
  - An accessible icon url and source url defined in addon's `metadata.yaml`.
  - A detail introduction include a basic example about how to use and what's the benefit of this addon in `README.md`.
  - It's more likely to be accepted if useful examples are provided in example [dir](examples/).

- An experimental addon must meet these conditions to be promoted as a verified one.
  - This addon must be tested by addon's [e2e-test](./test/e2e-test/addon-test) to guarantee this addon can be enabled successfully.
  - Provide an introduction in KubeVela [official addon documentation](https://kubevela.io/docs/reference/addons/overview).

- If you come across with any addon problems, feel free to raise a github issue or just send pull requests to fix them. Please make sure to update the addon version in your pull request.
    
## Community

Welcome to KubeVela community for discussion, please refer to [the community repo](https://github.com/kubevela/community).
