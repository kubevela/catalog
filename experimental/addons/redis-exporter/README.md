# Redis Exporter

Prometheus Redis metrics exporter.
> Supports Redis 2.x, 3.x, 4.x, 5.x, 6.x, and 7.x

## Quick Start

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



## Other use case example

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
        - properties:
          address: <host>:<port>
          secretName: <redis-secret-name>
          disableAnnotation: false
          name: redis-server-exporter
```