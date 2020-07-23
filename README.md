# OAM catalog

Catalog of OAM workloads, traits and scopes.

## Common pre-requisites

- [Kubernetes cluster](https://kubernetes.io/docs/setup/)
  - For example
    [Minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/),
    minimum version `v0.28+`
- [Helm 3](https://helm.sh/docs/intro/), minimum version `v3.0.0+`.
- Install OAM Runtime
```
helm repo add crossplane-master https://charts.crossplane.io/master/
kubectl create namespace oam-system
helm install oam --namespace oam-system crossplane-master/oam-kubernetes-runtime --devel
```

## Workloads

Refer to [OAM Workloads](workloads/README.md) to see currently supported workloads.

## Traits

Refer to [OAM Traits](traits/README.md) to see currently supported traits.

## Scopes

Refer to [OAM Scopes](scopes/README.md) to see currently supported scopes.
