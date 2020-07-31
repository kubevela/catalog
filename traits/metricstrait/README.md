# OAM Metrics Trait
This trait is designed to provide an easy way for an OAM application operator to collect metrics from any workload
 that emits metrics through an endpoint reachable from within the cluster. The metrics traits relies on [Prometheus operator]() and
 [Prometheus helm chart]() 
 
## Collect metrics through an existing service

```yaml
 apiVersion: standard.oam.dev/v1alpha1
 kind: MetricsTrait
 metadata:
   name: metricstrait-sample-with-service
 spec:
   scrapeService:
     format: "prometheus"
     portName: http
     path: "/metrics"
     scheme:  "http"
     enabled: true
```


## Collect metrics without an existing service

```yaml
 apiVersion: standard.oam.dev/v1alpha1
 kind: MetricsTrait
 metadata:
   name: metricstrait-sample-without-service
 spec:
   scrapeService:
     format: "prometheus"
     targetPort: 8080
     selector:
       app: sample-app
     path: "/metrics"
     scheme:  "http"
     enabled: true
```

For details, please refer to an application [example](config/samples/application/README.md).

## License
By contributing to the OAM category repository, you agree that your contributions will be licensed under its [Apache 2.0
 License](https://github.com/oam-dev/catalog/blob/master/LICENSE).