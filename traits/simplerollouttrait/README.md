# Simple Rollout Trait
Simple-rollout trait is used to enable rollout capabilities for workloads.

More details refer to [OAM Component mutable and versioning mechanism](https://github.com/wonderflow/oam-kubernetes-runtime/blob/35c239fd88fb0b08dd3f93995a3670d880fd1f84/design/one-pager-component-mutable-and-versioning.md) and [the implementation](https://github.com/crossplane/oam-kubernetes-runtime/pull/35)

## Support workloads
- ContainerizedWorkload
- Deployment

## Prerequisites
Please follow [addon-oam-kubernetes-local](https://github.com/crossplane/addon-oam-kubernetes-local) to setup OAM runtime.

- Kubernetes v1.16+
- Helm 3
- Crossplane v0.11+ installed
- OAM controllers installed

:exclamation: Please notice that, since oam-core-controller enabled new versioning mechanism has not been released yet, you have to setup it with latest code of oam-kubernetes-runtime locally instead of installing it by [offical Helm charts](https://github.com/crossplane/addon-oam-kubernetes-local/tree/master/charts/oam-core-resources). More details refer to [Development.md](https://github.com/crossplane/oam-kubernetes-runtime)
    

## Get started
- Clone the project into your $GOPATH
```shell
git clone https://github.com/oam-dev/catalog.git
```
-  Load the CRD
```shell
cd catalog/traits/simplerollouttrait
make install
``` 
- Run the controller locally
```shell
go run main.go
```
- Apply the sample Component and ApplicationConfiguration

Two samples are prepared, based on Deployment and ContainerizedWorkload workload respectively.
```shell
cd ./config/samples/sample_containerizedworkload_workload

kubectl apply -f ./sample_component.yaml
kubectl apply -f ./sample_application_config.yaml
```

## Verify Rollout

- **Tips:** Before launch rollout, you can run below commands in 3 windows to observe resouces changing during rollout.

```shell
watch -n 1 kubectl get pods

watch -n 1 kubectl get ContainerizedWorkload

watch -n 1 kubectl get deployments
```

- Check SimpleRollouTrait config in ApplicationConfiguration
```shell
cat sample_application_config.yaml

...
        - trait:
            apiVersion: extend.oam.dev/v1alpha2
            kind: SimpleRolloutTrait
            metadata:
              name:  example-rollout-trait
            spec:
              replica: 6
              maxUnavailable: 2
              batch: 2
...
```
- Update Component to rollout a new ContainerizedWorkload instance

Apply updated component then rollout starts

```shell
kubecl apply -f ./sample_component_changed.yaml
```

- Observe rollout progress

We can observe what happens during rollout through the changing of deployments. 

```shell
watch -n 1 kubectl get deployments

## before rollout
NAME                                     READY   UP-TO-DATE   AVAILABLE   AGE
example-component-broccsh8d3b6gcr0951g   6/6     6            6           95s

## in the middle of rollout
NAME                                     READY   UP-TO-DATE   AVAILABLE   AGE
example-component-broccsh8d3b6gcr0951g   2/2     2            2           2m28s
example-component-brocg3p8d3b6gcr09520   1/3     3            1           8s

## rollout finished
NAME                                     READY   UP-TO-DATE   AVAILABLE   AGE
example-component-brocg3p8d3b6gcr09520   6/6     6            6           89s
```

When `example-component` has been updated, corresponding new workload instance, `ContainerizedWorkload`, is created immediately. As child resource of `ContainerizedWorkload`, new `deployment` will be launched and old `deployment` will be garbage collected simultaneously. Namely, there are two workload instances refering to one component at the same time.

Specifically, `SimpleRolloutTrait` will scale up new deployment and scale down old deployment gradually, along with the scaling span indicated by two parameters, `maxUnavailable` and `batch`. When old deployment is scaled down to zero and the new one comes into desired state, `SimpleRolloutTrait` will delete the old workload instance. The component instance and its child resouces enter a new state after rollout finally.    
