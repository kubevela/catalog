# Prometheus Server

[Prometheus](https://prometheus.io/), a [Cloud Native Computing Foundation](https://cncf.io/) project, is a systems and service monitoring system. It collects metrics from configured targets at given intervals, evaluates rule expressions, displays the results, and can trigger alerts if some condition is observed to be true.

This addon installs the minimal core server of Prometheus into clusters.

## Installation

Install prometheus server to all clusters with recommend parameters.

```shell
vela addon enable prometheus-server thanos=true serviceType=LoadBalancer storage=1G
```

Install prometheus server with custom config in ConfigMap. (This needs the target ConfigMap exists in the namespace o11y-system in all clusters.)

```shell
vela addon enable prometheus-server customConfig=prometheus-custom-config
```

Install prometheus server with thanos sidecar and query. This will help you get the aggregated query interface across all clusters.

```shell
vela addon enable prometheus-server thanos=true serviceType=LoadBalancer
```

Install prometheus server with persistent storage.

```shell
vela addon enable prometheus-server storage=1G
```
