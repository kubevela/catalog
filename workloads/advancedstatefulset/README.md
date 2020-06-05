# AdvancedStatefulSet Workload

oam-kubernetes-runtime supports existing third-party Kubernetes resources, this section will introduce how to use [AdvancedStatefulSet](https://github.com/openkruise/kruise/tree/master/docs/concepts/astatefulset) workload of [OpenKruise/Kruise](https://github.com/openkruise/kruise) in oam-kubernetes-runtime.

## (Prerequisite) Install Kruise Controllers
Make sure Kruise is already installed in your Kubernetes cluster. More details refer to [Kruise Get Start](https://github.com/openkruise/kruise/tree/master/docs).

Verify Kruise-manager is running:

```shell script
$ kubectl get pods -n kruise-system
NAME                          READY   STATUS    RESTARTS   AGE
kruise-controller-manager-0   1/1     Running   0          4m11s
```

Kruise provides way to [enable specific controllers](https://github.com/openkruise/kruise#optional-enable-specific-controllers), please make sure `AdvancedStatefulSet` controller is enabled at least. 

## Install Components

```shell script
$ kubectl apply -f sample-asts-component.yaml
component.core.oam.dev/example-asts created
```

## Run ApplicationConfiguration

```shell script
$ kubectl apply  -f sampeapp.yaml
applicationconfiguration.core.oam.dev/example-appconfig created
```
Then `sts.apps.kruise.io` or shortname `sts.apps.kruise.io` is created. `app.kruise.io` postfix needs to be appended due to naming collision with Kubernetes native `statefulset` kind.

```bash
$ kubectl get sts.apps.kruise.io
NAME              DESIRED   UPDATED   UPDATED_READY   READY   TOTAL   AGE
nginx               1          1           1            1       1      11m
```