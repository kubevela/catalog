# Traefik

Traefik is a modern HTTP reverse proxy and load balancer made to deploy microservices with ease.

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