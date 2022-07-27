# kube-state-metrics

[kube-state-metrics](https://github.com/kubernetes/kube-state-metrics) is a simple service that listens to the Kubernetes API server and generates metrics about the state of the objects.

The metrics are exported on the HTTP endpoint /metrics on the listening port (8080).

## Installation

```shell
vela addon enable kube-state-metrics
```
