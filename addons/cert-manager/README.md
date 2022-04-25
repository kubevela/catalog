# cert-manager

This addon is for cert-manager, which is for managing the k8s certificates

# tips

Install the certificate manager on your Kubernetes cluster to enable adding the webhook component 
(only needed once per Kubernetes cluster):
The cert-manager can also install with pure k8s-object like this:
kubectl create -f https://github.com/jetstack/cert-manager/releases/download/v1.7.1/cert-manager.yaml

In this addon, the repo is from https://artifacthub.io/packages/helm/cert-manager/cert-manager/1.7.1
## install

```shell
vela addon enable cert-manager
```

## uninstall

```shell
vela addon disable cert-manager
```
