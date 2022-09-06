# Instances of exposed services using gateway-api

## Step1. Configure the app using k8s-object type
Take whoami in the directory as an example

## Step2. Enable gateway-traits addon
The gateway-traits addon provides:
- gateway-api CRD
- httproute、httpsroute、tcproute Traits
- tls certificate Component

## Step3. Enable provider addon
### - traefik
Enable traefik-gateway addon
**Note: Add at least one GatewayListeners**
Default exposed ports: http, tcp is 8000, https is 8443
To add more ports, add endpoints when enabled
**Note: When adding the tcpRoute trait later, please fill in the default port or newly added port**
> This addon saves resources, does not generate additional services for the gateway, and accesses it through the ip of the same service (traefik-gateway).

### - istio
Enable istio-gateway addon
**Note: Add at least one GatewayListeners**
> The addon will generate a service for each gateway and access it through the ip+port of each service

## Step4. Add traits and deploy and access
### - HttpRoute
#### use traefik
Config:
- Domains: traefik.example.com
- GatewayName: traefik
- Rules: Port: 80, ServiceName: whoami
- Other options use default values

*After the addition is completed, deploy, select the ip of traefik-getway to access*
```shell
# Get IP
root@bxiii:/home/bxiiiiii# kubectl get svc -n vela-system
NAME                               TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                   AGE
kubevela-cluster-gateway-service   ClusterIP   10.43.29.244    <none>        9443/TCP                  20h
vela-core-webhook                  ClusterIP   10.43.31.158    <none>        443/TCP                   20h
apiserver                          ClusterIP   10.43.157.96    <none>        8000/TCP                  20h
velaux                             ClusterIP   10.43.166.124   <none>        80/TCP                    20h
chartmuseum                        NodePort    10.43.175.124   <none>        8080:32396/TCP            19h
traefik-gateway                    ClusterIP   10.43.119.96    <none>        9000/TCP,80/TCP,443/TCP   19h

# Get Hostname
root@bxiii:/home/bxiiiiii# kubectl get httproute --all-namespaces
NAMESPACE   NAME     HOSTNAMES                 AGE
default     whoami   ["traefik.example.com"]   67s

# Access
root@bxiii:/home/bxiiiiii# curl -I -HHost:"traefik.example.com" http://10.43.119.96
HTTP/1.1 200 OK
Content-Length: 404
Content-Type: text/plain; charset=utf-8
Date: Thu, 01 Sep 2022 03:42:49 GMT
```

#### 使用 istio
Config:
- Domains: istio.example.com
- GatewayName: istio
- Rules: Port: 80, ServiceName: whoami
- Other options use default values

*After the addition is completed, deploy, select the ip+port of istio to access*
```shell
# Get IP
root@bxiii:/home/bxiiiiii# kubectl get svc -n vela-system
NAME                               TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                   AGE
kubevela-cluster-gateway-service   ClusterIP   10.43.29.244    <none>        9443/TCP                  20h
vela-core-webhook                  ClusterIP   10.43.31.158    <none>        443/TCP                   20h
apiserver                          ClusterIP   10.43.157.96    <none>        8000/TCP                  20h
velaux                             ClusterIP   10.43.166.124   <none>        80/TCP                    20h
chartmuseum                        NodePort    10.43.175.124   <none>        8080:32396/TCP            19h
traefik-gateway                    ClusterIP   10.43.119.96    <none>        9000/TCP,80/TCP,443/TCP   19h
istio                              ClusterIP   10.43.94.83     <none>        15021/TCP,8050/TCP        10s

# Get Hostname
root@bxiii:/home/bxiiiiii# kubectl get httproute --all-namespaces
NAMESPACE   NAME     HOSTNAMES               AGE
default     whoami   ["istio.example.com"]   40s

# Access
root@bxiii:/home/bxiiiiii# curl -I -HHost:"istio.example.com" http://10.43.94.83:8050
HTTP/1.1 200 OK
date: Thu, 01 Sep 2022 03:48:21 GMT
content-type: text/plain; charset=utf-8
x-envoy-upstream-service-time: 12
server: istio-envoy
transfer-encoding: chunked
```

### - HttpsRoute
**Note: need to add tls certificate in integration configuration**

### - TcpRoute
**Note: Select traefik, the default port is 8000**