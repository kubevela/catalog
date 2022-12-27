#   Canary Rollout with Istio

This addon provides istio support for vela rollout, it just adds two definitions and depends on vela-rollout and istio addons.

##  Directory Structure
```shell
.
├── definitions     //  contains the X-Definition yaml/cue files. These file will be rendered as KubeVela Component in `template.yaml`
├── metadata.yaml   //  addon metadata information.
├── readme.md
```

##  Quick start
### Install vela canary-rollout-istio addon
```shell
vela addon enable canary-rollout-istio
```
For offline install please use
```shell
cd ~/experimental/addons
vela addon enable canary-rollout-istio/
```
### Verify installs
Check the deployment status of the application through `vela status <application name>:`
```shell
$ vela status addon-canary-rollout-istio -n vela-system
About:

  Name:         addon-canary-rollout-istio   
  Namespace:    vela-system                  
  Created at:   2022-12-26 15:34:28 +0800 CST
  Status:       running                      

Workflow:

  mode: DAG-DAG
  finished: true
  Suspend: false
  Terminated: false
  Steps
  - id: yisdqy3lx7
    name: deploy-deploy-addon-to-all-clusters
    type: deploy
    phase: succeeded
```
When we see that the `finished` field in Workflow is `true` and the Status is `running`, it means that the entire application is delivered successfully.

If status shows as rendering or healthy as false, it means that the application has either failed to deploy or is still being deployed. Please proceed according to the information returned in `kubectl get application <application name> -o yaml`.

You can also view WorkflowStepDefinition list by using the following command:
```shell
$ vela def list |& grep canary-roll
canary-rollback                 WorkflowStepDefinition  vela-system     canary-rollout-istio                                                                
canary-rollout                  WorkflowStepDefinition  vela-system     canary-rollout-istio                                                                                                                                                                                                                                       
```

