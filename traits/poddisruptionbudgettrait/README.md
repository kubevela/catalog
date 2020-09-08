# PodDisruptionBudgetTrait

Use Cron expressions to periodically scale your workload.

## Supported workloads:
- ContainerizedWorkload
- Deployment
- StatefulSet
- ReplicaSet

## Prerequisites
Please follow [common prerequisites](../../README.md) to install OAM Controllers.

## Getting started
- Get the PodDisruptionBudgetTrait project
```console
git clone https://github.com/oam-dev/catalog.git
```
- Install CRD to your Kubernetes cluster
```console
cd catalog/traits/poddisruptionbudgettrait/

make install
```
- Run the PodDisruptionBudgetTrait controller
```console
make run
```

### ContainerizedWorkload

- Apply the sample ContainerizedWorkload
```console
kubectl apply -f config/samples/containerized
```

```yaml
# ./config/samples/contaierized/sample_application_config.yaml

  ...
      traits:
        - trait:
            apiVersion: core.oam.dev/v1alpha2
            kind: PodDisruptionBudgetTrait
            metadata:
              name: example-pdb-trait
            spec:
              minAvailable: 1 # or 30%
              # maxUnavailable: 1 or 30%
```
 
- Verify PodDisruptionBudgetTrait you should see a deployment created by ContainerizedWorkload
```console
kubectl get deployment
NAME                READY   UP-TO-DATE   AVAILABLE   AGE
example-component   1/1     1            1           3s
```
- And a PodDisruptionBudgetTrait created
```console
kubectl get pdbtrait
NAME                MINAVAILABLE   MAXUNAVAILABLE   SYNCED   APPLICATIONCONFIGURATION   PODDISRUPTIONBUDGET   AGE
example-pdb-trait   1                               True     example-appconfig          example-pdb-trait     3s
```
- And a PodDisruptionBudget automatically created by PodDisruptionBudgetTrait controller
```console
kubectl get pdb
NAME                MIN AVAILABLE   MAX UNAVAILABLE   ALLOWED DISRUPTIONS   AGE
example-pdb-trait   1               N/A               0                     3s
```

# How it work?

Essentially, the PodDisruptionBudgetTrait controller will generate PodDisruptionBudget based on the workload spec.

In detail:
- If the workload type is [ContainerizedWorkload](https://github.com/crossplane/oam-kubernetes-runtime) which has two child resources (Deployment and Service), PodDisruptionBudgetTrait can help to create corresponding PodDisruptionBudget.
- If the workload type is K8S native resources ([StatefulSet](https://github.com/oam-dev/catalog/blob/master/workloads/statefulset/README.md) or [Deployment](https://github.com/oam-dev/catalog/blob/master/workloads/deployment/README.md)), PodDisruptionBudgetTrait can help to create a PodDisruptionBudget.
