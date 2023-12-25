
# Datadog Trait

Sets up the annotations and environment variables to assist a webservice 
component to have correct collection of logs and apm stats by a datadog agent
installed on the host nodes.

The Datadog agent must already be install on the cluster nodes.

## Use case example

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
      image: me/myapp:latest
    traits:
      - type: datadog
        properties:
          serviceName: myService
          env:         prod
          version:     1.0.15
          source:      csharp
```

