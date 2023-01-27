# Redis Exporter

Prometheus Redis metrics exporter.



## Use case example

* Work as a trait.

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
        version: "16.8.5"
        values:
          master:
            persistence:
              size: 16Gi
          replica:
            persistence:
              size: 16Gi
      traits:
        - properties:
          address: <host>:<port>
          password: <password>
          disableAnnotation: false
          name: redis-server-exporter
          type: redis-exporter
```

* Work as a component.

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
        version: "16.8.5"
        values:
          master:
            persistence:
              size: 16Gi
          replica:
            persistence:
              size: 16Gi
    - name: redis-exporter
      properties:
        address: <host>:<port>
        password: <password>
        disableAnnotation: false
        name: redis-server-exporter
      type: redis-exporter-server
```
