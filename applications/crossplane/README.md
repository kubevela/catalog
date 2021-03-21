# Crossplane cloud resource provisioning and consuming 

These demonstrations show how KubeVela integrates Knative Configuration/Route to deploy and manage applications.

> The demonstrations are verified in Alibaba Kubernetes Cluster v1.18.8 of Hongkong region.

## Prerequisites
- kubectl
  
- Crossplane provider-alibaba v0.5.0
  
  Refer to [Installation](https://github.com/crossplane/provider-alibaba/releases/tag/v0.6.0-rc.0) to install KubeVela.
  
### Install and configure Crossplane Alibaba provider

```shell
$ kubectl crossplane install provider crossplane/provider-alibaba:v0.5.0

$ kubectl create secret generic alibaba-account-creds -n crossplane-system --from-literal=accessKeyId=xxx --from-literal=accessKeySecret=yyy

$ kubectl apply -f provider.yaml

```



### Prepare WorkloadDefinition `knative-serving`

Apply [workloaddefinition-rds.yaml](./workloaddefinition-rds.yaml).

```yaml

```

```shell
✗ k get workloaddefinition
NAME          DEFINITION-NAME
alibaba-rds   rdsinstances.database.alibaba.crossplane.io
```

### Prepare Application

Write Application `webapp` in [application-v1.yaml](./application-v1.yaml) and deploy it.

```yaml
apiVersion: core.oam.dev/v1alpha2
kind: Application
metadata:
  name: webapp
spec:
  components:
    - name: backend
      type: knative-serving
      settings:
        image: gcr.io/knative-samples/helloworld-go
        env:
          - name: TARGET
            value: "Go Sample v1"
```


### Interact with the application

```shell
$ kubectl get application
NAME     AGE
webapp   24m

$ kubectl get ksvc
NAME            URL                                                 LATESTCREATED         LATESTREADY           READY   REASON
backend-v1      http://backend-v1.default.47.242.55.215.xip.io      backend-v1-00001      backend-v1-00001      True

$ curl http://backend-v1.default.47.242.55.215.xip.io
Hello Go Sample v1!
```


Have fun with KubeVela and Knative.



```shell
➜  /Users/zhouzhengxi/Downloads k get component
NAME             WORKLOAD-KIND   AGE
express-server   Deployment      28m
sample-db        RDSInstance     28m
➜  /Users/zhouzhengxi/Downloads k get rdsinstance
NAME           READY   SYNCED   STATE     ENGINE   VERSION   AGE
poc            True    False    Running   mysql    8.0       9m37s

```