# Advancedstatefulset

## Description

Enhanced rolling update workflow of default StatefulSet controller

## Specification

List of all configuration options for a `Advancedstatefulset` workload type.

```yaml
```

## Properties

Name | Description | Type | Required | Default 
------------ | ------------- | ------------- | ------------- | ------------- 
 cmd | Commands to run in the container | []string | false |  
 env | Define arguments by using environment variables | [[]env](#env) | false |  
 replicas | Pod replicas | int | false | 1 
 image | Which image would you like to use for your service | string | true |  
 port | Traffic port | int | true | 80 
 cpu | Number of CPU units for the service, like `0.5` (0.5 CPU core), `1` (1 CPU core) | string | false |  
 orderedPodManagementPolicy | Pods are created in increasing order (pod-0, then pod-1, etc) and the controller will wait until each pod is ready before continuing. Conflicts with `parallelPodManagementPolicy` | bool | true | false 
 parallelPodManagementPolicy | Pods are crated in parallel to match the desired scale without waiting, and on scale down will delete all pods at once. Conflicts with `orderedPodManagementPolicy` | [parallelPodManagementPolicy](#parallelPodManagementPolicy) | false |  
 podUpdatePolicy | indicates how pods should be updated, allows in (`ReCreate`, `InPlaceIfPossible`, `InPlaceOnly`) | string | false | ReCreate 
 inPlaceUpdateStrategy | Strategy for in-place update | [inPlaceUpdateStrategy](#inPlaceUpdateStrategy) | false |  


####### inPlaceUpdateStrategy

Name | Description | Type | Required | Default 
------------ | ------------- | ------------- | ------------- | ------------- 
 gracePeriodSeconds | The timespan between set Pod status to not-ready and update images in Pod spec when in-place update a Pod | int | false |  


###### parallelPodManagementPolicy

Name | Description | Type | Required | Default 
------------ | ------------- | ------------- | ------------- | ------------- 
 maxUnavailable | The maximum number of pods that can be unavailable during the update. `40` means `40%` of desired pods | int | false |  


### env

Name | Description | Type | Required | Default 
------------ | ------------- | ------------- | ------------- | ------------- 
 name | Environment variable name | string | true |  
 value | The value of the environment variable | string | false |  
 valueFrom | Specifies a source the value of this var should come from | [valueFrom](#valueFrom) | false |  


#### valueFrom

Name | Description | Type | Required | Default 
------------ | ------------- | ------------- | ------------- | ------------- 
 secretKeyRef | Selects a key of a secret in the pod's namespace | [secretKeyRef](#secretKeyRef) | true |  


##### secretKeyRef

Name | Description | Type | Required | Default 
------------ | ------------- | ------------- | ------------- | ------------- 
 name | The name of the secret in the pod's namespace to select from | string | true |  
 key | The key of the secret to select from. Must be a valid secret key | string | true |  
