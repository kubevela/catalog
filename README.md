# KubeVela catalog

Catalog of KubeVela workloads, traits and scopes. 

Welcome to contribute this repo putting your customize vela workload/trait/scope here.

## Pre-requisites

- Install [KubeVela](https://kubevela.io/docs/install)

## Controller

### Workloads

Refer to [KubeVela Workloads](workloads/README.md) to see currently supported workloads.

### Traits

Refer to [KubeVela Traits](traits/README.md) to see currently supported traits.

### Scopes

Refer to [KubeVela Scopes](scopes/README.md) to see currently supported scopes.

## Registry

[Registry](registry) contains many workload/trait/scope definitions. You can apply them in your cluster to extend the capability of KubeVela.

Before apply those definitions, please make sure that related workload/trait controller and crds installed already.

### Usage

[You can use them as a KubeVela cap center]( https://kubevela.io/docs/developers/cap-center) or [Use them directly like this](https://kubevela.io/docs/platform-engineers/keda)