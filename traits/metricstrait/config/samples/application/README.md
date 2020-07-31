# Quick start

This example show case how one can use a metricsTrait to add prometheus monitoring capability to any workload that
 emits metrics data.

## Install OAM controller
```shell script
kubectl create ns oam-system
helm install oam --namespace oam-system crossplane-master/oam-kubernetes-runtime --devel
```

## Install Prometheus operator helm chart
```shell script
kubectl apply  -f config/oam/monitoring-namespace.yaml
helm repo add stable https://kubernetes-charts.storage.googleapis.com
helm install monitoring -n oam-monitoring stable/prometheus-operator
```

## Install OAM Prometheus
```shell script
kubectl apply  -f config/oam/prometheus-oam.yaml
kubectl apply  -f config/oam/grafana-oam.yaml
```

## Install the cert-manager
```shell script
kubectl create namespace cert-manager
helm install cert-manager jetstack/cert-manager --namespace cert-manager  --version v0.16.0 --set installCRDs=true
```

## Install the metrics trait controller and webhook
```shell script
make docker-build
make deploy
```

## Run ApplicationConfiguration

```shell script
kubectl apply -f config/samples/application/
workloaddefinition.core.oam.dev/deployments.apps created
traitdefinition.core.oam.dev/services created
traitdefinition.core.oam.dev/metricstraits.standard.oam.dev created
component.core.oam.dev/sample-application created
applicationconfiguration.core.oam.dev/sample-application-with-metrics created
```

## Verify that the metrics are collected on prometheus
```shell script
kubectl --namespace oam-monitoring port-forward svc/prometheus-oam  4848
```
Then access the prometheus dashboard via http://localhost:4848

## Verify that the metrics showing up on grafana
```shell script
kubectl --namespace oam-monitoring port-forward deploy/monitoring-grafana 3000
```
Then access the grafana dashboard via http://localhost:3000.  You shall set the data source URL as `http://prometheus-oam:4848`

## Setup Grafana Panel and Alert
How to set up a Grafana dashboard https://grafana.com/docs/grafana/latest/features/dashboard/dashboards/

Import the dashboard stored in config/samples/application

How to set up a Grafana alert https://grafana.com/docs/grafana/latest/alerting/alerts-overview/. One caveat is that
 only one alert is supported for each panel.

How to set up a DingDing robot as the Grafana notification channel https://ding-doc.dingtalk.com/doc#/serverapi2/qf2nxq