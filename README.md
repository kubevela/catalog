# OAM catalog

Catalog of OAM workloads, traits and scopes.

## Common pre-requisites

- [Kubernetes cluster](https://kubernetes.io/docs/setup/)
  - For example
    [Minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/),
    minimum version `v0.28+`
- [Helm 3](https://helm.sh/docs/intro/), minimum version `v3.0.0+`.
- Install Crossplane and OAM
```
helm repo add oam https://oam-dev.github.io/crossplane-oam-sample/archives/
kubectl create namespace oam-system
helm install crossplane --namespace oam-system oam/crossplane-oam
```

## Workloads

Refer to [OAM Workloads](workloads/README.md) to see currently supported workloads.

## Traits

Refer to [OAM Traits](traits/README.md) to see currently supported traits.

## Scopes

Refer to [OAM Scopes](scopes/README.md) to see currently supported scopes.
