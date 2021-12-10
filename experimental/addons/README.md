# KubeVela experimental addons

This dir is KubeVela official experimental addon-registry which will contain some KubeVela addons which haven't verified stable.

Addon files in this dir files will be synced to alibaba-oss. Addons in this  dir will not be set in KubeVela by default.

You can add this addon registry by vela cli and use them.

```shell
$ vela addon registry add experimental --type OSS --endpoint=https://addons.kubevela.net --path=experimental/
```

```shell
$ vela addon registry list      
Name            Type    URL                                                                                                      
experimental    OSS     https://addons.kubevela.net 
```

Then you will find these addons.
```shell
$ vela addon list      
NAME                    DESCRIPTION                                                             STATUS  
istio                   Enable service mash and managing triffic shiffting in workflow.         disabled
example                 Extended workload to do continuous and progressive delivery             disabled
kruise                  Kruise is a Kubernetes extended suite for application automations       disabled
kubeflow-pipeline       Run Kubeflow Pipelines on KubeVela                                      disabled
kubeflow                Build Kubeflow Machine Learning Apps on KubeVela                        disabled
```

When user enable an addon by UX or cli, addon files will be generated as a KubeVela application and apply it.

You can add your addon files in this dir and help extends KubeVela addons. 
