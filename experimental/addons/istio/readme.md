#   Istio

This addon provides istio for service mesh.

##  Directory Structure
```shell
.
├── definitions     //  contains the X-Definition yaml/cue files. These file will be rendered as KubeVela Component in `template.yaml`
├── examples        //  some quick demos to guide you through this addon
├── metadata.yaml   //  addon metadata information.
├── readme.md
├── resources       //  cue definitions which will be converted to JSON schema and rendered in UI forms
└── template.yaml   //  contains the basic app, you can add some component and workflow to meet your requirements
```

##  Quick start
### Install vela istio addon
```shell
vela addon enable istio 
```
For offline install please use
```shell
cd ~/experimental/addons
vela addon enable istio/
```
### Verify installs
Check the deployment status of the application through `vela status <application name>:`
```shell
$ vela status addon-istio
About:

  Name:         addon-istio
  Namespace:    vela-system
  Created at:   2022-05-18 16:57:20 +0800 CST
  Status:       running

Workflow:

  mode: StepByStep
  finished: true
  Suspend: false
  Terminated: false
  Steps
  - id:b6ctrnvrid
    name:deploy-control-plane
    type:apply-application
    phase:succeeded
    message:
  - id:x38n3krvj5
    name:deploy-runtime
    type:deploy2runtime
    phase:succeeded
    message:

Services:

  - Name: ns-istio-system
    Cluster: local  Namespace: vela-system
    Type: raw
    Healthy
    No trait applied

  - Name: istio
    Cluster: local  Namespace: vela-system
    Type: helm
    Healthy Fetch repository successfully, Create helm release successfully
    No trait applied
```
When we see that the `finished` field in Workflow is `true` and the Status is `running`, it means that the entire application is delivered successfully.

If status shows as rendering or healthy as false, it means that the application has either failed to deploy or is still being deployed. Please proceed according to the information returned in `kubectl get application <application name> -o yaml`.

You can also view application list by using the following command:
```shell
$ ls -n vela-system                                                                                                                                                                                                                                           
APP         	COMPONENT            	TYPE       	TRAITS	PHASE  	HEALTHY	STATUS                                                      	CREATED-TIME
addon-istio 	ns-istio-system      	raw        	      	running	healthy	                                                            	2022-05-18 16:57:20 +0800 CST
└─          	istio                	helm       	      	running	healthy	Fetch repository successfully, Create helm release          	2022-05-18 16:57:20 +0800 CST
            	                     	           	      	       	       	successfully
```
We also see that the PHASE of the app is running and the STATUS is healthy.

