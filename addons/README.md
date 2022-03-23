# KubeVela addons

This dir is KubeVela official addon-registry which will contain stable KubeVela addons.

Addon files in this dir files will be synced to alibaba-oss. This addon registry be set in KubeVela as default addons registry.

You can list all addons by vela cli. For example

```shell
$ vela addon list
terraform-aws            	KubeVela	Kubernetes Terraform Controller for AWS                                                              	disabled
ocm-gateway-manager-addon	KubeVela	ocm-gateway-manager-addon is the OCM addon automates the cluster-gateway apiserver.                  	disabled
fluxcd                   	KubeVela	Extended workload to do continuous and progressive delivery                                          	disabled
terraform-tencent        	KubeVela	Kubernetes Terraform Controller Provider for Tencent Cloud                                           	disabled
velaux                   	KubeVela	KubeVela User Experience (UX). An extensible, application-oriented delivery and management Dashboard.	disabled
terraform-ucloud         	KubeVela	Kubernetes Terraform Controller Provider for UCloud                                                  	disabled
terraform-gcp            	KubeVela	Kubernetes Terraform Controller Provider for Google Cloud Platform                                   	disabled
model-training           	KubeVela	Enable training for models                                                                           	disabled
terraform-baidu          	KubeVela	Kubernetes Terraform Controller Provider for Baidu Cloud                                             	disabled
model-serving            	KubeVela	Enable serving for models                                                                            	disabled
terraform-azure          	KubeVela	Kubernetes Terraform Controller for Azure                                                            	disabled
ocm-hub-control-plane    	KubeVela	ocm-hub-control-plane can install OCM hub control plane to the central cluster.                      	disabled
terraform                	KubeVela	Terraform Controller is a Kubernetes Controller for Terraform.                                       	disabled
terraform-alibaba        	KubeVela	Kubernetes Terraform Controller for Alibaba Cloud                                                    	disabled
```

When user enable an addon by UX or cli, addon files will be generated as a KubeVela application and apply it.

You can manage the addon-registry by vela cli.

```shell
$ vela addon registry list 
Name            Type    URL                        
KubeVela        OSS     https://addons.kubevela.net
```

You can add your addon files in this dir and help extends KubeVela addons. 

