# KubeVela addons

This dir is KubeVela official addon-registry which will contain stable KubeVela addons.

Addon files in this dir files will be synced to alibaba-oss. This addon registry be set in KubeVela as default addons registry.

You can list all addons by vela cli. For example

```shell
$ vela addon list
terraform               Terraform Controller is a Kubernetes Controller for Terraform.                                                                          disabled
velaux                  The KubeVela User Experience (UX ). Dashboard Designed as an extensible, application-oriented delivery and management control panel.    disabled
ocm-cluster-manager     ocm-cluster-manager can deploy an OCM hub cluster environment.                                                                          disabled
fluxcd                  Extended workload to do continuous and progressive delivery                                                                             disabled
terraform-aws           Kubernetes Terraform Controller for AWS                                                                                                 disabled
observability           An out of the box solution for KubeVela observability                                                                                   disabled
terraform-alibaba       Kubernetes Terraform Controller for Alibaba Cloud                                                                                       disabled
terraform-azure         Kubernetes Terraform Controller for Azure                                                                                               disabled
```

When user enable an addon by UX or cli, addon files will be generated as a KubeVela application and apply it.

You can manage the addon-registry by vela cli.

```shell
$ vela addon registry list 
Name            Type    URL                        
KubeVela        OSS     https://addons.kubevela.net
```

You can add your addon files in this dir and help extends KubeVela addons. 

