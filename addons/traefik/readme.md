# Traefik

Traefik is a modern HTTP reverse proxy and load balancer made to deploy microservices with ease.

## Version description

* v2.6.3-1

This version depends on VelaUX with version `1.5.0-alpha.3`, because the `config-tls-certificate` configuration uses the `CertBase64` UI component.

> The traefik version is v2.6.3

## Before you enable it

Traefik serves the Kubernetes Gateway API, which the `http-route`, `https-route` and `tcp-route` traits use, so each cluster the addon deploys to needs the Gateway API v1alpha2 CRDs (Gateway API v0.4 to v0.6) first. The addon does not install them, since they are cluster-scoped and other gateways install their own. If your clusters have none yet:

```shell
for crd in gatewayclasses gateways httproutes referencegrants tcproutes tlsroutes; do
  kubectl apply --server-side -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v0.5.1/config/crd/experimental/gateway.networking.k8s.io_${crd}.yaml
done
```

## How to configure

* ServiceType

If your cluster supports the LoadBalancer, it is the best option.

* AccessLog

Enabled means the access log will be printed in stdout of the traefik container.

* ExposeDashboard

Enabled means you could access the traefik dashboard, the default address is `<IP>:9000/dashboard/`

* Autoscaling

Enabled means the traefik instances will be auto-scaling by HorizontalPodAutoscaler.

* EntryPoints

Specify the traefik entry points, the built-in values are `8443`(for HTTPS) and `8000`(for HTTP). Only configured ports can be used for the `tcp-route` trait.

This addon is maintained by barnett(barnett.zqg@gmail.com), you can connect me by github issue or email.