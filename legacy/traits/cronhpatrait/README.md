# CronHPATrait

Use Cron expressions to periodically scale your workload.

## Supported workloads:
- ContainerizedWorkload
- Deployment
- StatefulSet

## Prerequisites
1. Please follow [common prerequisites](../../README.md) to install OAM Controllers.
2. Please install [kubernetes-cronhpa-controller](https://github.com/AliyunContainerService/kubernetes-cronhpa-controller).

## Getting started
- Get the CronHPATrait project to your GOPATH
```console
git clone https://github.com/oam-dev/catalog.git
```
- Install CRD to your Kubernetes cluster
```console
cd catalog/traits/cronhpatrait/

make install
```
- Run the CronHPATrait controller
```console
go run main.go
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
            kind: CronHPATrait
            metadata:
              name: example-cronhpa-trait
            spec:
              jobs:
                - name: "scale-down"
                  schedule: "30 */1 * * * *"
                  targetSize: 1
                - name: "scale-up"
                  schedule: "0 */1 * * * *"
                  targetSize: 3
```
 
- Verify CronHPATrait you should see a deployment created by ContainerizedWorkload
```console
kubectl get deployment
NAME                                    READY   UP-TO-DATE   AVAILABLE   AGE
example-appconfig-workload-deployment   1/1     1            1           3s
```
- And a CronHPA automatically created by CronHPATrait controller
```console
kubectl get cronhpa
NAME                    AGE
example-cronhpa-trait   35s
```
- You should see a CronHPA and it's spec looking like below
```console
kubectl get cronhpa
NAME                    AGE
example-cronhpa-trait   2m18s

kubectl describe cronhpa
...
  Exclude Dates:  <nil>
  Jobs:
    Name:         scale-down
    Run Once:     false
    Schedule:     30 */1 * * * *
    Target Size:  1
    Name:         scale-up
    Run Once:     false
    Schedule:     0 */1 * * * *
    Target Size:  3
...
```
- Verrify CronHPA works
```console
# kubectl get deployment -w

NAME                                    READY   UP-TO-DATE   AVAILABLE   AGE
example-appconfig-workload-deployment   1/1     1            1           2m
example-appconfig-workload-deployment   1/3     1            1           2m
example-appconfig-workload-deployment   1/3     1            1           2m
example-appconfig-workload-deployment   1/3     1            1           2m
example-appconfig-workload-deployment   1/3     3            1           2m
example-appconfig-workload-deployment   2/3     3            2           2m
example-appconfig-workload-deployment   2/3     3            2           2m
example-appconfig-workload-deployment   3/3     3            3           2m
example-appconfig-workload-deployment   3/1     3            3           2m
example-appconfig-workload-deployment   3/1     3            3           2m
example-appconfig-workload-deployment   3/1     3            3           2m
example-appconfig-workload-deployment   1/1     1            1           2m
```

### K8s Deployment

- Apply the sample Deployment
```console
kubectl apply -f config/samples/deployment
```

```yaml
# ./config/samples/deployment/sample_workload_definition.yaml
  
apiVersion: core.oam.dev/v1alpha2
kind: WorkloadDefinition
metadata:
  name: deployments.apps
spec:
  definitionRef:
    name: deployments.apps
```
```yaml
# ./config/samples/deployment/sample_application_config.yaml

  ...
      traits:
        - trait:
            apiVersion: core.oam.dev/v1alpha2
            kind: CronHPATrait
            metadata:
              name: example-cronhpa-trait
            spec:
              jobs:
                - name: "scale-down"
                  schedule: "30 */1 * * * *"
                  targetSize: 1
                  runOnce: true
                - name: "scale-up"
                  schedule: "0 */1 * * * *"
                  targetSize: 3
                  runOnce: true
              excludeDates:
                # exclude November 15th
                - "* * * 15 11 *"
                # exclude every Friday
                - "* * * * * 5"
```
- Verify CronHPATrait you should see a deployment looking like below
```console
kubectl get deployment
NAME   READY   UP-TO-DATE   AVAILABLE   AGE
web    1/1     1            1           15s
```
- And a CronHPA automatically created by CronHPATrait controller
```console
kubectl get cronhpa
NAME                    AGE
example-cronhpa-trait   28s
```
- You should see a CronHPA and it's spec looking like below
```console
kubectl get cronhpa
NAME                    AGE
example-cronhpa-trait   28s

kubectl describe cronhpa
...
  Exclude Dates:
    * * * 15 11 *
    * * * * * 5
  Jobs:
    Name:         scale-down
    Run Once:     true
    Schedule:     30 */1 * * * *
    Target Size:  1
    Name:         scale-up
    Run Once:     true
    Schedule:     0 */1 * * * *
    Target Size:  3
  Scale Target Ref:
    API Version:  apps/v1
    Kind:         Deployment
    Name:         web
...
```
- Verrify CronHPA works and the result is same as ContainerizedWorkload

### K8s StatefulSet

- Apply the sample StatefulSet
```console
kubectl apply -f config/samples/statefulset
```

```yaml
# ./config/samples/statefulset/sample_workload_definition.yaml
  
apiVersion: core.oam.dev/v1alpha2
kind: WorkloadDefinition
metadata:
  name: statefulsets.apps
spec:
  definitionRef:
    name: statefulsets.apps
```
```yaml
# ./config/samples/statefulset/sample_application_config.yaml

  ...
      traits:
        - trait:
            apiVersion: core.oam.dev/v1alpha2
            kind: CronHPATrait
            metadata:
              name: example-cronhpa-trait
            spec:
              jobs:
                - name: "scale-down"
                  schedule: "30 */1 * * * *"
                  targetSize: 1
                - name: "scale-up"
                  schedule: "0 */1 * * * *"
                  targetSize: 3
```

- Verify CronHPATrait you should see a statefulset looking like below
```console
kubectl get statefulset
NAME   READY   AGE
web    1/1     22s
```
- And a CronHPA automatically created by CronHPATrait controller
```console
kubectl get cronhpa
NAME                    AGE
example-cronhpa-trait   62s
```
- You should see a CronHPA and it's spec looking like below
```console
kubectl get cronhpa
NAME                    AGE
example-cronhpa-trait   62s

kubectl describe cronhpa
...
  Exclude Dates:  <nil>
  Jobs:
    Name:         scale-down
    Run Once:     false
    Schedule:     30 */1 * * * *
    Target Size:  1
    Name:         scale-up
    Run Once:     false
    Schedule:     0 */1 * * * *
    Target Size:  3
...
```
- Verrify CronHPA works and the result is same as ContainerizedWorkload


# How it work?

Essentially, the CronHPATrait controller will generate CronHPA based on the workload spec.

In detail:
- If the workload type is [ContainerizedWorkload](https://github.com/crossplane/oam-kubernetes-runtime) which has two child resources (Deployment and Service), CronHPATrait can help to create corresponding CronHPA.
- If the workload type is K8S native resources ([StatefulSet](https://github.com/oam-dev/catalog/blob/master/workloads/statefulset/README.md) or [Deployment](https://github.com/oam-dev/catalog/blob/master/workloads/deployment/README.md)), CronHPATrait can help to create a CronHPA.
