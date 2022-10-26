# Grafana

[Grafana](https://grafana.com/) is an open source, feature rich metrics dashboard and graph editor for Graphite, Elasticsearch, OpenTSDB, Prometheus and InfluxDB.

## Installation

```shell
vela addon enable grafana
```

If you want to expose your grafana service to public, you can use the `serviceType` parameter.

```shell
vela addon enable grafana serviceType=LoadBalancer
```

If you want to add persistent storage to it, you can use the `storage` parameter.

```shell
vela addon enable grafana storage=1G
```

By default, the Grafana addon will install grafana in your cluster and add GrafanaDatasource & GrafanaDashboards to it.
If you already have your Grafana installed, or using cloud services, you can register your Grafana through the prism Grafana object or KubeVela config managment. Then you can install datasources and dashboards by the following command.

```shell
vela addon enable grafana install=false kubeEndpoint=https://<your kubernetes apiserver endpoint>
```

**Notice!**
If your KubeVela's version `<1.6.0-alpha.4`, please use this command to enable grafana-definitions addon first.

```shell
vela addon enable grafana-definitions --version v0.1.0
```