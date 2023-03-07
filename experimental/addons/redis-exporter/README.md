# Redis Exporter

Prometheus Redis metrics exporter.
> Supports Redis 2.x, 3.x, 4.x, 5.x, 6.x, and 7.x

## Work as a component

### 1. Create Redis Instance

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

### 2. Create Redis Secret

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: <redis-secret-name>
data:
  username: <username-bash64> # default: ""
  password: <password-bash64> # default: password in base64
```

### 3. Enable Redis Exporter Addon

```shell
vela addon enable redis-exporter
```

### 4. Create Redis Exporter Server

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: redis
  namespace: default
spec:
  components:
    - name: redis-exporter
      type: redis-exporter-server
      properties:
        address: <host>:<port>
        secretName: <redis-secret-name>
        disableAnnotation: false
        name: redis-server-exporter
```

## Work as a trait.

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: redis
  namespace: default
spec:
  components:
    - name: redis-secret
      type: k8s-objects
      properties:
        objects:
          - apiVersion: v1
            kind: Secret
            metadata:
              name: <redis-secret-name>
            data:
              username: <username-bash64> # default: ""
              password: <password-bash64> # default: password in base64
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
      traits:
        - type: redis-exporter
          properties:
          address: <host>:<port>
          secretName: <redis-secret-name>
          disableAnnotation: false
          name: redis-server-exporter
```

## Exposed Metrics

### Access by `port-forward`

Base use case above, you can get the metrics exposed from exporter by `vela port-forward`:

```shell
vela port-forward <app-name> 9121:9121
```

Then select the `redis-server-exporter` service:

```shell
vela port-forward redis 9121:9121
? There are 4 services match your filter conditions. Please choose one:
Cluster | Component | Service  [Use arrows to move, type to filter]
  local | redis | redis-headless
  local | redis | redis-master
  local | redis | redis-replicas
> local | redis-exporter | redis-exporter
```

After that, you can access the metrics by `http://localhost:9121/metrics`.

```
...
# HELP redis_active_defrag_running active_defrag_running metric
# TYPE redis_active_defrag_running gauge
redis_active_defrag_running 0
# HELP redis_allocator_active_bytes allocator_active_bytes metric
# TYPE redis_allocator_active_bytes gauge
redis_allocator_active_bytes 1.728512e+06
# HELP redis_allocator_allocated_bytes allocator_allocated_bytes metric
# TYPE redis_allocator_allocated_bytes gauge
redis_allocator_allocated_bytes 1.340704e+06
# HELP redis_allocator_frag_bytes allocator_frag_bytes metric
# TYPE redis_allocator_frag_bytes gauge
redis_allocator_frag_bytes 387808
# HELP redis_allocator_frag_ratio allocator_frag_ratio metric
# TYPE redis_allocator_frag_ratio gauge
redis_allocator_frag_ratio 1.29
...
```

### Grafana Dashboard

You can choose to install Grafana in the Kubernetes cluster manually, or use Grafana in a simple way by installing the [Grafana addon](https://github.com/kubevela/catalog/tree/master/addons/grafana) of KubeVela. And then you can use dashboard to visualize the metrics.

Example Grafana screenshots:

![](https://cloud.githubusercontent.com/assets/1222339/19412041/dee6d7bc-92da-11e6-84f8-610c025d6182.png)

Grafana dashboard is available on [grafana.com](https://grafana.com/grafana/dashboards/763-redis-dashboard-for-prometheus-redis-exporter-1-x/) and/or [github.com](https://github.com/oliver006/redis_exporter/blob/master/contrib/grafana_prometheus_redis_dashboard.json).