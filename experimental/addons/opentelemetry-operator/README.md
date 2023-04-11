# opentelemetry-operator

This is an addon template. Check how to build your own addon: https://kubevela.net/docs/platform-engineers/addon/intro

## Install

Add experimental registry
```
vela addon registry add experimental --type=helm --endpoint=https://addons.kubevela.net/experimental/
```

Enable this addon
```
vela addon enable opentelemetry-operator
```

```shell
$ vela ls -A | grep opentelemetry
vela-system     addon-opentelemetry-operator    ns-opentelemetry-operator               k8s-objects                                     running healthy
vela-system     └─                              opentelemetry-operator                  helm                                            running healthy Fetch repository successfully, Create helm release
```

Disable this addon
```
vela addon disable opentelemetry-operator
```

