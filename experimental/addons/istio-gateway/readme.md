# Istio

This addon provides istio support for gateway.

## How to configure

* GatewayType

Defaults to ClusterIP. If your cluster supports the LoadBalancer, it is the best option.

* GatewayNamespace

Specify the gateway namespace.

* EntryPoints

Specify the istio entry points.

* GatewayListeners

Specify the gateway listeners. Only configured listeners can be used.

