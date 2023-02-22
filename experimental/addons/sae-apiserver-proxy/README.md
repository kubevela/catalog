# sae-apiserver-proxy

This is a proxy server that implements the Kubernetes aggregated APIServer and provide proxy access to SAE APIServer.

It can be used natively as a cluster in ClusterGateway. Therefore, it wraps the SAE APIServer into a Kubernetes cluster for ClusterGateway. It is possible for KubeVela related projects (including Core Controller, CommandLine Tools and Workflow Controller) to leverage the multi-cluster management capabilities, such as deploying KubeVela application to SAE.

## Feedback

If you have any questions or feedback during use, please raise issues at [https://github.com/kubevela-contrib/sae-apiserver-proxy/issues](https://github.com/kubevela-contrib/sae-apiserver-proxy/issues).

## Install

```shell
vela addon enable sae-apiserver-proxy
```

## Usage

To register a SAE APIServer Proxy, apply the following YAML.

```yaml
apiVersion: sae.alibaba-cloud.oam.dev/v1alpha1
kind: SAEAPIServer
metadata:
  name: sae
spec:
  accessKeyId: <your aliyun accessKeyId>
  accessKeySecret: <your aliyun accessKeySecret>
  region: <the SAE APIServer region>
```

You can check it through running `kubectl get saeapiserver` and see

```shell
NAME    REGION        AK
sae     cn-hangzhou   <your aliyun accessKeyId>
```

Now you can see a new cluster shown with running `vela cluster list`.

```shell
CLUSTER   ALIAS   TYPE                ENDPOINT                                              ACCEPTED        LABELS                                                
local             Internal            -                                                     true                                                                  
sae               ServiceAccountToken https://.../apis/sae.alibaba-cloud.oam.dev/v1al...    true            sae.alibaba-cloud.oam.dev/apiserver=true              
                                                                                                            sae.alibaba-cloud.oam.dev/apiserver-region=cn-hangzhou
```

Start your journey with KubeVela application!

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: sae-app
  namespace: default
spec:
  components:
    - type: webservice
      name: sae-app
      properties:
        image: nginx
      traits:
        - type: expose
          properties:
            port: [80]
            type: LoadBalancer
        - type: scaler
          properties:
            replicas: 3
  policies:
    - type: topology
      name: sae
      properties:
        clusters: ["sae"]
```

## Uninstall

```shell
vela addon disable sae-apiserver-proxy
```
