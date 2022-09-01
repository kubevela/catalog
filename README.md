# KubeVela Catalog

## Introduction

This is repo of source files of community KubeVela [addons](https://kubevela.net/docs/reference/addons/overview) which extend the capability of platform. An addoon can be a kubernetes operator and its [X-definition](https://kubevela.net/docs/getting-started/definition) such as [Fluxcd](addons/fluxcd) or other useful components for KubeVela such as [VelaUX](addons/velaux).

Addons here contain [verified](./addons) addons which have been tested for a long time can be used in product environment and [experimental](experimental/addons) addons which isn't general available yet.

* [Verified Addons](/addons): when a pull Request of addons were merged to this directory, the addon will automatically synced to the OSS bucket( https://addons.kubevela.net ). This will be displayed in vela CLI by `vela addon list` or VelaUX by default.

![image](https://user-images.githubusercontent.com/2173670/160372119-3e62044c-ce93-428d-9681-a91f0742bbaf.png)


* [Experimental Addons](/experimental/addons): some addons which were not well verified will be merged into the experimental addons directory, the addon will also be synced to the OSS bucket( https://addons.kubevela.net in path `experimental`) automatically. 
  ```
  vela addon registry add experimental --type=helm --endpoint=https://addons.kubevela.net/experimental/
  ```

![image](https://user-images.githubusercontent.com/2173670/160373204-80e74587-606c-4522-9802-11d4f572450b.png)

## How to use

You can enable these addons by Vela cli or VelaUX. Please refer to [doc](https://kubevela.net/docs/reference/addons/overview) for more infos.

## History addon versions

Since any changes about one addon will upgrade the version, this repo's source files always are the latest version of addons, but you can find all other history versions' download url of an addon in `https://addons.kubevela.net/index.yaml`. Then you can download and enable them if you want.

## Contribution

Community members are welcome to contribute this repo by putting their customize vela addons here.

>This [doc](https://kubevela.net/docs/platform-engineers/addon/intro) will introduce how to make an KuebVela addon and the mechanism behind it.

Please be aware of this contribution rules when contribute addons.

- A new addon added in this repo should be put in as an experimental one unless you have test for a long time in your product environment and be approved by most maintainers.

- An experimental addon must meet these conditions can be promoted as a verified one.

  - This addon must be tested by addon's [e2e-test](./test/e2e-test/addon-test) to guarantee this addon can ben enabled successfully.

  - This addon must have some basic but necessary information.

    - An accessible icon url and source url defined in addon's `metadata.yaml`.
    
    - A detail introduction include a basic example about how to use and what's the benefit of this addon in `README.md`.
      
    - Also provide an introduction in KubeVela [documentation](https://kubevela.net/docs/reference/addons/overview).
    
    - Better provide more useful examples in example [dir](examples/).
    
## Community

Welcome to KubeVela community. Refer to [here](https://github.com/kubevela/kubevela#community) for more info.