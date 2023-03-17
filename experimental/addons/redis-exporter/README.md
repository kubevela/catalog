# Redis Exporter

Prometheus Redis metrics exporter.
> Supports Redis 2.x, 3.x, 4.x, 5.x, 6.x, and 7.x

## Installation

```shell
vela addon enable redis-exporter
```

## Usage

### Install relevant addons

> If you have already installed the `prometheus-server` and `grafana` , please skip these steps to get started.

1. Install the prometheus-server addon

```shell
vela addon enable prometheus-server
```

2. Install the grafana addon

```shell
vela addon enable grafana
```

3. Access your grafana through port-forward

```shell
kubectl port-forward svc/grafana -n o11y-system 8080:3000
```

Now you can access your grafana by access `http://localhost:8080` in your browser. The default username and password are `admin` and `kubevela` respectively.

> You can change it by adding adminUser=super-user adminPassword=PASSWORD to step 3.


### Work as a component

#### 1. Create Redis Instance

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: redis
  namespace: default
spec:
  components:
    - name: redis
      type: helm
      properties:
        repoType: "helm"
        url: "https://charts.bitnami.com/bitnami"
        chart: "redis"
        version: "17.7.3"
        values:
          global:
            redis:
              password: <password>
          master:
            persistence:
              size: 16Gi
          replica:
            persistence:
              size: 16Gi

```

#### 2. Create Redis Secret

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: <redis-secret-name>
data:
  username: <username-bash64> # default: ""
  password: <password-bash64> # default: password in base64
```

#### 3. Create Redis Exporter Server

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: redis
  namespace: default
spec:
  components:
    - type: redis-exporter-server
      name: redis-exporter
      properties:
        address: <host>:<port>
        secretName: <redis-secret-name>
        disableAnnotation: false
        name: redis-server-exporter
  traits:
    - type: prometheus-scrape
      properties:
        port: <port>
        path: /metrics
  workflow:
    steps:
      - type: deploy
        name: deploy-redis-exporter
      - type: import-grafana-dashboard
        name: import-redis-exporter-dashboard
        properties:
          uid: redis-exporter-dashboard
          title: Redis Exporter Dashboard
          url: https://github.com/oliver006/redis_exporter/blob/master/contrib/grafana_prometheus_redis_dashboard.json
```

### Work as a trait.

#### 1. Create Redis Secret

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: <redis-secret-name>
data:
  username: <username-bash64> # default: ""
  password: <password-bash64> # default: password in base64
```

#### 2. Create Redis Instance

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: redis
  namespace: default
spec:
  components:
    - type: helm
      name: redis
      properties:
        repoType: "helm"
        url: "https://charts.bitnami.com/bitnami"
        chart: "redis"
        version: "17.7.3"
        values:
          global:
            redis:
              password: <password>
          master:
            persistence:
              size: 16Gi
          replica:
            persistence:
              size: 16Gi
      traits:
        - type: redis-exporter
          properties:
              address: <host>:<port>
              secretName: <redis-secret-name>
              disableAnnotation: false
              name: redis-server-exporter
        - type: prometheus-scrape
          properties:
              port: <port>
              path: /metrics
  workflow:
    steps:
      - type: import-grafana-dashboard
        name: import-redis-exporter-dashboard
        properties:
          uid: redis-exporter-dashboard
          title: Redis Exporter Dashboard
          url: https://github.com/oliver006/redis_exporter/blob/master/contrib/grafana_prometheus_redis_dashboard.json
```

## Grafana Dashboard

You can choose to install Grafana in the Kubernetes cluster manually, or use Grafana in a simple way by installing the [Grafana addon](https://github.com/kubevela/catalog/tree/master/addons/grafana) of KubeVela. And then you can use dashboard to visualize the metrics.

Example Grafana screenshots:

![](https://cloud.githubusercontent.com/assets/1222339/19412041/dee6d7bc-92da-11e6-84f8-610c025d6182.png)

Grafana dashboard is available on [grafana.com](https://grafana.com/grafana/dashboards/763-redis-dashboard-for-prometheus-redis-exporter-1-x/) and/or [github.com](https://github.com/oliver006/redis_exporter/blob/master/contrib/grafana_prometheus_redis_dashboard.json).




