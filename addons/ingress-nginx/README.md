# ingress-nginx

This addon is an Ingress controller for Kubernetes using [NGINX](](https://kubernetes.github.io/ingress-nginx/)) as a reverse proxy and load balancer. If your cluster is already have any kinds of ingress controller, you don't need to enable this addon.


## Install

```shell
vela addon enable ingress-nginx
```

## Uninstall

```shell
vela addon disable ingress-nginx
```

Use this addon by deploy a application:

```yaml
cat <<EOF | vela up -f -
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: demo
spec:
  components:
  - name: demo
    type: webservice
    properties:
      image: barnett/canarydemo:v1
      ports:
      - port: 8090
    traits:
    - type: gateway
      properties:
        domain: canary-demo.com
        http:
          "/version": 8090
EOF
```

Then access the gateway's endpoint will see:

```shell
$ curl -H "Host: canary-demo.com" <ingress-nginx-endpoint>/version
Demo: V1
```