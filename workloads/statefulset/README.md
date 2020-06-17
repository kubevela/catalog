# StatefulSet Workload

oam-kubernetes-runtime also supports K8s native resource, this section will introduce how to use K8s StatefulSet.

## Update RBAC for OAM AppConfig Controller

Make sure your cluster-role bound has following rules:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: <your-cluster-role>
rules:
- apiGroups:
  - apps
  resources:
  - statefulsets
  # - deployments
  verbs:
  - "*"
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: oam-example-catalog
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: <your-cluster-role>
subjects:
  - kind: ServiceAccount
    name: <crossplane-name>
    namespace: <crossplane-namsepace>
```

## Install Component

```shell script
$ kubectl apply -f sample-sts-component.yaml
component.core.oam.dev/example-sts created
```

## Run AppConfig

```shell script
$ kubectl apply  -f sampeapp.yaml
applicationconfiguration.core.oam.dev/example-appconfig created
```

Then you will see a StatuefulSet app has been created.

```
$ kubectl get sts
NAME   READY   AGE
web    1/1     2m27s
```
