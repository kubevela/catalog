
# Mysql Exporter

Prometheus exporter for MySQL server metrics.

Supported versions:

MySQL >= 5.6.
MariaDB >= 10.3

> NOTE: Not all collection methods are supported on MySQL/MariaDB < 5.6

## Use case example

* Work as a trait.

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: mysql
  namespace: default
spec:
  components:
  - name: mysql
    type: helm
    properties:
      chart: mysql
      repoType: helm
      retries: 3
      secretRef: ""
      url: https://charts.bitnami.com/bitnami
      values:
        auth:
          rootPassword: yueda123
        primary:
          persistence:
            enabled: false
        secondary:
          persistence:
            enabled: false
      version: 9.2.0
    traits:
    - properties:
        disableAnnotation: false
        mysqlHost: mysql
        mysqlPort: 3306
        name: mysql-server-exporter
        password: yueda123
        username: root
        version: v0.14.0
      type: mysql-exporter
```

* Work as a component.

> This mode also is suitable the mysql server is not managed by KubeVela.

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: mysql
  namespace: default
spec:
  components:
  - name: mysql
    type: helm
    properties:
      chart: mysql
      repoType: helm
      retries: 3
      secretRef: ""
      url: https://charts.bitnami.com/bitnami
      values:
        auth:
          rootPassword: yueda123
        primary:
          persistence:
            enabled: false
        secondary:
          persistence:
            enabled: false
      version: 9.2.0
  - name: mysql-exporter
    properties:
      disableAnnotation: false
      mysqlHost: mysql-server
      mysqlPort: 3306
      name: mysql-server-exporter
      password: yueda123
      username: root
      version: v0.14.0
    type: mysql-exporter-server
```
