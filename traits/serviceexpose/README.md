# ServiceExpose
You can use ServiceExpose to create a k8s service for workload on a Kubernetes cluster.

## Supported workloads:
- ContainerizedWorkload
- StatefulSet
- Deployment

## Prerequisites
- Please follow [addon-oam-kubernetes-local](https://github.com/crossplane/addon-oam-kubernetes-local) to install OAM Controllers.

## Getting started
- Get the project to your $GOPATH
```
git clone https://github.com/oam-dev/catalog.git
```
- Install CRD to your Kubernetes cluster
```
cd catalog/traits/serviceexpose/

make install
```
- Run the serviceexpose controller
```
go run main.go
```
- Apply a sample application configuration
```
kubectl apply -f config/samples/
```
In the `sample_application_config.yaml`, you can see how to define fields for ServiceExpose. Please notice that under the field `template` you can define all fields of K8S native service which you want. 
```
./config/samples/sample_application_config.yaml
...
kind: ServiceExpose
metadata:
  name:  example-appconfig-trait
spec:
  template:
    type: NodePort
    ports:
      - port: 80
        name: nginx
        targetPort: 80
...
```

## Verify generated resources
- You should see OAM resources looking like below
```
kubectl get applicationconfiguration
NAME                AGE
example-appconfig   45s
```
```
kubectl get component
NAME          WORKLOAD-KIND
example-sts   StatefulSet
```
```
kubectl get serviceexpose
NAME                      AGE
example-appconfig-trait   95s
```
- You should see corresponding K8S natice resources looking like below
```
kubectl get statefulset
NAME  READY   AGE
web   1/1     19s
```
```
kubectl get pod
NAME    READY   STATUS    RESTARTS   AGE
web-0   1/1     Running   0          31s
```
```
kubectl get service
NAME   TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
test   NodePort    10.103.191.25   <none>        80:32502/TCP   45s
```

## Verify Service works
- You can access the nginx service through Service
```
curl <Node-IP>:32502
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
<p>If you see this page, the nginx web server is successfully installed and working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```
