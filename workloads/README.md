# OAM Workloads

Currently we have OAM workloads as below:

## Core Workloads

- [ContainerizedWorkload](https://github.com/crossplane/addon-oam-kubernetes-local) is the core workload implementation of OAM.

## Experimental Workloads
### Kubernetes native workloads
- [StatefulSet Workload](statefulset/README.md) gives an example how to use the K8s native StatefulSet as OAM workload. 

### OpenKruise workloads

- [AdvancedStatefulSet Workload](advancedstatefulset/README.md) gives an example how to use [AdvancedStatefulSet](https://github.com/openkruise/kruise/tree/master/docs/concepts/astatefulset) workload of [OpenKruise](https://github.com/openkruise/kruise) as OAM workload.

- [CloneSet Workload](cloneset/README.md) gives an example how to use [CloneSet](https://github.com/openkruise/kruise/tree/master/docs/concepts/cloneset) workload of [OpenKruise](https://github.com/openkruise/kruise) as OAM workload.