
# Datadog Trait

Sets up the annotations and environment variables to assist a webservice 
component to have correct collection of logs and apm stats by a datadog agent
installed on the host nodes.

The Datadog agent must already be install on the cluster nodes.

The expectation is that the datadog volume is `/var/run/datadog` on the host,
and will be mounted as `/var/run/datadog` in the container, though this can
be changed (not recommended).

## Simple use case example

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: myapp
spec:
  components:
  - name: myapp
    type: webservice
    properties:
      image: me/myapp:1.0.15
    traits:
      - type: datadog
        properties:
          serviceName: "myService"
          env:         "prod"
          version:     "1.0.15"
```

## Comprehensive use case example

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: myapp
spec:
  components:
  - name: myapp
    type: webservice
    properties:
      image: me/myapp:1.0.17
    traits:
      - type: datadog
        properties:
          serviceName:                     "myService"
          env:                             "dev"
          version:                         "1.0.17"
          source:                          "csharp"
          hostMountPath:                   "/var/run/custom-datadog"
          mountPath:                       "/usr/var/run/datadog"
          volumeName:                      "customdatadog"
          autoDependencyMap:               true
          autoDependencies:                "http-client,sql-server,firestore"
          logDirectSubmissionIntegrations: "Serilog"
     
          
```
