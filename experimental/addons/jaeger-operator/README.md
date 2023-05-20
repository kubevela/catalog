# jaeger-operator

This is an addon template. Check how to build your own addon: https://kubevela.net/docs/platform-engineers/addon/intro

## Install

Add experimental registry
```
vela addon registry add experimental --type=helm --endpoint=https://addons.kubevela.net/experimental/
```

Enable this addon
```
vela addon enable jaeger-operator
```

```shell
$ vela ls -A | grep jaeger
vela-system     addon-jaeger-operator   ns-jaeger-operator                      k8s-objects                                     running         healthy
vela-system     └─                      jaeger-operator                         k8s-objects                                     running         healthy
```

Disable this addon
```
vela addon disable jaeger-operator
```

## Use jaeger-operator

Apply below Application yaml in the namespace `jaeger-operator` to create a jaeger instance:

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: jaeger-operator-sample
spec:
  components:
    - type: "jaeger"
      name: "jaeger-instance"
      properties:
```

```shell
$ kubectl get po  -n jaeger-operator  -o wide
NAME                      READY   STATUS    RESTARTS        AGE    IP             NODE       NOMINATED NODE   READINESS GATES
jaeger-6d5cd9d876-lccxg   1/1     Running   0               160m   10.244.6.202   minikube   <none>           <none>
```

The Jaeger UI is served via the Ingress, like

```shell
$ kubectl get -n jaeger-operator ingress
NAME             HOSTS     ADDRESS          PORTS     AGE
simplest-query   *         192.168.122.34   80        3m
```

In this example, the Jaeger UI is available at http://192.168.122.34.

The official documentation for the Jaeger Operator, including all its customization options, are available under the main Jaeger Documentation.
