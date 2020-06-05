# CloneSet Workload

oam-kubernetes-runtime supports existing third-party Kubernetes resources, this section will introduce how to use [CloneSet](https://github.com/openkruise/kruise/tree/master/docs/concepts/cloneset) workload of [OpenKruise/Kruise](https://github.com/openkruise/kruise) in oam-kubernetes-runtime.

## (Prerequisite) Install Kruise Controllers
Make sure Kruise is already installed in your Kubernetes cluster. More details refer to [Kruise Get Start](https://github.com/openkruise/kruise).

Verify Kruise-manager is running:

```shell script
$ kubectl get pods -n kruise-system
NAME                          READY   STATUS    RESTARTS   AGE
kruise-controller-manager-0   1/1     Running   0          4m11s
```

Kruise provides way to [enable specific controllers](https://github.com/openkruise/kruise#optional-enable-specific-controllers), please make sure `CloneSet` controller is enabled at least. 

## Install Components

```shell script
$ kubectl apply -f sample-cls-component.yaml
component.core.oam.dev/example-cls created
```

## Run ApplicationConfiguration

```shell script
$ kubectl apply  -f sampeapp.yaml
applicationconfiguration.core.oam.dev/example-appconfig created
```
Then `cloneset.apps.kruise.io` or shortname `clone` is created.

```shell script
$ kubectl get clone
NAME              DESIRED   UPDATED   UPDATED_READY   READY   TOTAL   AGE
nginx               1          1           1            1       1      11m
```

## Default value of `spec.replicas` 

As [kruise/cloneset CRD](https://github.com/openkruise/kruise/blob/eb63c9b2aa9fa52ba7eb2e14f9dd140d9cfa4bb2/config/crds/apps_v1alpha1_cloneset.yaml#L227) states, `spec.replicas` is a required field for cloneset, but in OAM specification this field is considered as operator-concerned characteristic which should be handled by trait, e.g. [ManualScaler trait](https://github.com/crossplane/addon-oam-kubernetes-local/tree/79a8c2e5695a757aa06247058912b4354e1c6d09/pkg/controller/core/traits/manualscalertrait).  Therefore, `spec.replicas` is invisible from component's perspective and currently [set 1 as default value](https://github.com/captainroy-hy/catalog/blob/d05e29c6f928d6b9134c7c11d709f0fc3fc6f33c/workloads/cloneset/sample-cls-component.yaml#L12).
