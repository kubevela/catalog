# IngressTrait
- If the workload type is [ContainerizedWorkload](https://github.com/crossplane/addon-oam-kubernetes-local) which has two child resources (Deployment and Service), IngressTrait can help to create corresponding ingress based on the child Service.
- If the workload type is K8S native resources ([StatefulSet](https://github.com/oam-dev/catalog/blob/master/workloads/statefulset/README.md) or [Deployment](https://github.com/oam-dev/catalog/blob/master/workloads/deployment/README.md)), IngressTrait can help to create a Service based on `spec.template.spec.contaiers` firstly, and then create corresponding ingress. 

## Supported workloads:
- ContainerizedWorkload
- StatefulSet
- Deployment

## Prerequisites
Please follow [addon-oam-kubernetes-local](https://github.com/crossplane/addon-oam-kubernetes-local) to install OAM Controllers.

## Getting started
- Get the IngressTrait project to your GOPATH
```
git clone https://github.com/oam-dev/catalog.git
```
- Install CRD to your Kubernetes cluster
```
cd catalog/traits/ingresstrait/

make install
```
- Run the IngressTrait controller
```
go run main.go
```

## Two examples

### ContainerizedWorkload
- Apply the sample ContainerizedWorkload
```
kubectl apply -f config/samples/containerized
```
In this example, we use ContainerizedWorkload to show how IngressTrait works. Because it already has a Service, we can just use this Service to create a corresponding ingress.
So we don't have to define the Service backend.

Please notice that IngressTrait's filed is a little different from K8s native ingress.
```
# ./config/samples/contaierized/sample_workload_definition.yaml
  
  ...
  definitionRef:
    name: containerizedworkloads.core.oam.dev
  childResourceKinds:
    - apiVersion: apps/v1
      kind: Deployment
    - apiVersion: v1
      kind: Service
```
```
# ./config/samples/contaierized/sample_application_config.yaml

  ...
      traits:
        - trait:
            apiVersion: core.oam.dev/v1alpha2
            kind: IngressTrait
            metadata:
              name: example-ingress-trait
            spec:
                rules:
                  - host: nginx.oam.com
                    paths:
                      - path: /
```
 
- Verify IngressTrait you should see a deployment created by ContainerizedWorkload
```
kubectl get deployment
NAME                         READY   UP-TO-DATE   AVAILABLE   AGE
example-appconfig-workload   1/1     1            1           15s
```
- And a service created by ContainerizedWorkload
```
kubectl get service
NAME                         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
example-appconfig-workload   NodePort    10.106.34.129   <none>        80:30038/TCP   22s
```
- You should see a ingress and it's rules looking like below
```
kubectl get ingress
NAME                    HOSTS           ADDRESS      PORTS   AGE
example-ingress-trait   nginx.oam.com   172.18.0.2   80      33s

kubectl describe ingress
...
Rules:
  Host           Path  Backends
  ----           ----  --------
  nginx.oam.com  
                 /   example-appconfig-workload:80 (10.244.1.19:80)
...
```
- Verrify Ingress works
```
# curl -H "host: nginx.oam.com" 172.18.0.2

<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```

### K8S native resources
- Apply the sample StatefulSet
```
kubectl apply -f config/samples/statefulset
```
In this example, we use StatefulSet to show how IngressTrait works. Because it has no Service itself, IngressTrait can create a service and a corresponding ingress.
So we don't have to define the Service backend either.

Please notice that IngressTrait's filed is a little different from K8s native ingress.
```
# ./config/samples/contaierized/sample_workload_definition.yaml
  
apiVersion: core.oam.dev/v1alpha2
kind: WorkloadDefinition
metadata:
  name: statefulsets.apps
spec:
  definitionRef:
    name: statefulsets.apps
```
```
# ./config/samples/contaierized/sample_application_config.yaml

  ...
      traits:
        - trait:
            apiVersion: core.oam.dev/v1alpha2
            kind: IngressTrait
            metadata:
              name: example-ingress-trait
            spec:
                rules:
                  - host: nginx.oam.com
                    paths:
                      - path: /
```

- Verify IngressTrait you should see a deployment created by ContainerizedWorkload
```
kubectl get statefulset
NAME   READY   AGE
web    1/1     6s
```
- And a service created by ContainerizedWorkload
```
kubectl get service
NAME   TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
test   LoadBalancer   10.96.198.230   <pending>     80:32424/TCP   19s
```
- You should see a ingress and it's rules looking like below
```
kubectl get ingress
NAME                    HOSTS           ADDRESS      PORTS   AGE
example-ingress-trait   nginx.oam.com   172.18.0.2   80      23s

kubectl describe ingress
...
Rules:
  Host           Path  Backends
  ----           ----  --------
  nginx.oam.com  
                 /   test:80 (10.244.1.20:80)
...
```
- Verrify Ingress works
```
# curl -H "host: nginx.oam.com" 172.18.0.2

<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```