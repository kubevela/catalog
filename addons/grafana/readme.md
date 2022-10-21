# Grafana

[Grafana](https://grafana.com/) is an open source, feature rich metrics dashboard and graph editor for Graphite, Elasticsearch, OpenTSDB, Prometheus and InfluxDB.

## Installation

```shell
vela addon enable grafana
```

**Notice!**
If your KubeVela's version `<1.6.0-alpha.4`, please use this command to enable grafana-definitions addon first.

```shell
vela addon enable grafana-definitions --version v0.1.0
```