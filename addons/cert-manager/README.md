# cert-manager

This addon is for cert-manager, which is managing the kubernetes certificates

# tips

Install the certificate manager on your Kubernetes cluster to enable adding the webhook component 
(only needed once per Kubernetes cluster)

In this addon, the repo is from https://artifacthub.io/packages/helm/cert-manager/cert-manager/1.7.1
## install

```shell
vela addon enable cert-manager
```

## uninstall

```shell
vela addon disable cert-manager
```
