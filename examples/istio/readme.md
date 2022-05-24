#   Istio

This demo is a quick application intro to istio-addon

### Try a demo with istio trait !
Here is a quick demo using `webservice` component and `expose` `istio-gateway` trait to show you how this works.
```yaml
traits:
  # use expose trait to create a svc
- type: expose
  properties:
    port:
      - 80
- type: istio-gateway
  properties:
    hosts:
      - awesomesite.com
    # gateway: "ingressgateway-intranet"
    port: 80

```
The configuration snippet should be fairly straight forward , we add a trait `expose` to expose your traffic, and then add `istio-gateway` trait to integrate with istio.
Please be aware that values for gateway is the same selector for the istio svc which is ingressgateway by default.

Let's get it running , `vela up -f demo.yaml` and you should be able to see the status by `vela ls`
```yaml
$ vela ls                                                                                                                                                                                                                                                          
APP        	COMPONENT  	TYPE           	TRAITS              	PHASE  	HEALTHY	STATUS   	CREATED-TIME
website    	frontend   	webservice     	expose,istio-gateway	running	healthy	Ready:1/1	2022-05-18 21:22:56 +0800 CST
```
Also you can verify istio crs are successfully created:
```yaml
kubectl get vs,gw                                                                                                                                                                                                                                     
NAME                                             GATEWAYS       HOSTS                             AGE
virtualservice.networking.istio.io/frontend      ["frontend"]   ["awesomesite.com"]   14h

NAME                                   AGE
gateway.networking.istio.io/frontend   14h
```