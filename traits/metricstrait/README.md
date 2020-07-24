# Deployment Workload

This example show case how one can use a metricsTrait to add prometheus monitoring capability to any workload that
 emits metrics data through a service.

## Install OAM controller
```shell script
kubectl create ns oam-system
helm install oam --namespace oam-system crossplane-master/oam-kubernetes-runtime --devel
```

## Install Prometheus operator
```shell script
helm repo add stable https://kubernetes-charts.storage.googleapis.com
kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.38/example/prometheus-operator-crd/monitoring.coreos.com_alertmanagers.yaml
kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.38/example/prometheus-operator-crd/monitoring.coreos.com_podmonitors.yaml
kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.38/example/prometheus-operator-crd/monitoring.coreos.com_prometheuses.yaml
kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.38/example/prometheus-operator-crd/monitoring.coreos.com_prometheusrules.yaml
kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.38/example/prometheus-operator-crd/monitoring.coreos.com_servicemonitors.yaml
kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.38/example/prometheus-operator-crd/monitoring.coreos.com_thanosrulers.yaml
kubectl apply  -f config/oam/
helm install monitoring -n oam-monitoring stable/prometheus-operator
```

## Install WorkLoad/Trait Definitions

```shell script
kubectl apply -f config/samples/application/definitions.yaml
workloaddefinition.core.oam.dev/deployments.apps created
traitdefinition.core.oam.dev/services created
traitdefinition.core.oam.dev/metricstraits.standard.oam.dev created
```

## Install Component

```shell script
kubectl apply -f config/samples/application/sample-deployment-component.yaml
component.core.oam.dev/sample-application created
```

## Install the metrics trait controller
```shell script
make docker-build
make deploy
```

## Run ApplicationConfiguration

```shell script
kubectl apply -f config/samples/application/sample-applicationconfiguration.yaml
applicationconfiguration.core.oam.dev/sample-application-with-metrics created
```

## Verify that the metrics are collected on prometheus
```shell script
kubectl --namespace oam-monitoring port-forward svc/prometheus-oam  9090
```
Then access the prometheus dashboard via http://localhost:9090

## Verify that the metrics showing up on grafana
```shell script
kubectl --namespace oam-monitoring port-forward svc/monitoring-grafana 3000
```
Then access the grafana dashboard via http://localhost:3000.  You shall set the data source URL as `http://prometheus
-oam:4848`

## Setup Grafana Panel and Alert
How to set up a Grafana dashboard https://grafana.com/docs/grafana/latest/features/dashboard/dashboards/

How to set up a Grafana alert https://grafana.com/docs/grafana/latest/alerting/alerts-overview/. One caveat is that
 only one alert is supported for each panel.

How to set up a DingDing robot as the Grafana notification channel https://ding-doc.dingtalk.com/doc#/serverapi2/qf2nxq