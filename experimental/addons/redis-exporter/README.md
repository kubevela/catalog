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
    - name: redis-secret
      type: k8s-objects
      properties:
        objects:
          - apiVersion: v1
            kind: Secret
            metadata:
              name: redis-secret
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
        - properties:
          address: <host>:<port>
          secretName: redis-secret
          disableAnnotation: false
          name: redis-server-exporter
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
    - name: redis-secret
      type: k8s-objects
      properties:
        objects:
          - apiVersion: v1
            kind: Secret
            metadata:
              name: redis-secret
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
    - name: redis-exporter
      type: redis-exporter-server
      properties:
        address: <host>:<port>
        secretName: redis-secret
        disableAnnotation: false
        name: redis-server-exporter
```
