# OAM Traits

Currently we have OAM traits as below:

## Core Traits

- [ManualScaler](https://github.com/crossplane/addon-oam-kubernetes-local) can enable replicas of workloads to be manually scaled.

## Standard Traits

- [trait-injector](https://github.com/oam-dev/trait-injector) can help do service binding which can inject
  resource from one to another.

## Extended Traits

- [HPATrait](hpatrait) can help create k8s HorizontalPodAutoscaler for workload.
- [CronHPATrait](cronhpatrait) can help create CronHorizontalPodAutoscaler for workload.
- [SidecarTrait](sidecartrait) can deploy sidecar for workload.
- [PodDisruptionBudgetTrait](poddisruptionbudgettrait) can help create PodDisruptionBudget for workload.