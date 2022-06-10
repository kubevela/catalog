# Ingress controller

[Ingress controller](https://kubernetes.github.io/ingress-nginx/) is an Ingress controller for Kubernetes using NGINX as a reverse proxy and load balancer.

## Install

```shell
vela addon enable ingrss-controller
```

## Uninstall

```shell
vela addon disable ingrss-controller
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
$ curl -H "Host: canary-demo.com" <ingress-controller-endpoint>/version
Demo: V1
```