# KubeVela addons

This dir is KubeVela official addon-registry which will contain stable KubeVela addons.

Addon files in this dir files will be synced to alibaba-oss. This addon registry be set in KubeVela as default addons registry.

You can list all addons by vela cli. For example

```shell
$ vela addon list
NAME                     	DESCRIPTION                                                                                          	STATUS
terraform-gcp            	Kubernetes Terraform Controller Provider for Google Cloud Platform                                   	disabled
ocm-gateway-manager-addon	ocm-gateway-manager-addon is the OCM addon automates the cluster-gateway apiserver.                  	disabled
model-serving            	Enable serving for models                                                                            	disabled
fluxcd                   	Extended workload to do continuous and progressive delivery                                          	disabled
terraform-alibaba        	Kubernetes Terraform Controller for Alibaba Cloud                                                    	disabled
terraform-aws            	Kubernetes Terraform Controller for AWS                                                              	disabled
terraform-azure          	Kubernetes Terraform Controller for Azure                                                            	disabled
terraform-ucloud         	Kubernetes Terraform Controller Provider for UCloud                                                  	disabled
ocm-hub-control-plane    	ocm-hub-control-plane can install OCM hub control plane to the central cluster.                      	disabled
velaux                   	KubeVela User Experience (UX). An extensible, application-oriented delivery and management Dashboard.	disabled
terraform-tencent        	Kubernetes Terraform Controller Provider for Tencent Cloud                                           	disabled
terraform                	Terraform Controller is a Kubernetes Controller for Terraform.                                       	disabled
model-training           	Enable training for models                                                                           	disabled
terraform-baidu          	Kubernetes Terraform Controller Provider for Baidu Cloud                                             	disabled
```

When user enable an addon by UX or cli, addon files will be generated as a KubeVela application and apply it.

You can manage the addon-registry by vela cli.

```shell
$ vela addon registry list 
Name            Type    URL                        
KubeVela        OSS     https://addons.kubevela.net
```

You can add your addon files in this dir and help extends KubeVela addons. 

* Refer to [the docs](https://kubevela.io/docs/how-to/cli/addon/addon) to learn more about addons.

