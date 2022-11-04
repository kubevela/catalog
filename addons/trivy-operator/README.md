# trivy-operator

# description
- This addon provides a vulnerability scanner that continuously scans containers deployed in a Kubernetes cluster.
- More Info is here: https://github.com/devopstales/trivy-operator/blob/main/README.md
    
## Install

```shell
vela addon enable trivy-operator
```

## Uninstall

```shell
vela addon disable trivy-operator
```

## Quick start

After the addon is enabled, check the status of trivy addon:

```shell
$ vela status addon-trivy-operator -n vela-system --tree --detail
CLUSTER       NAMESPACE        RESOURCE                                    STATUS    APPLY_TIME          DETAIL
local     ─┬─ -            ─── Namespace/trivy-system                      updated   2022-11-04 03:30:07 Status: Active  Age: 2m10s
           └─ trivy-system ─┬─ Service/trivy-system-helm-prometheus-scrape updated   2022-11-04 03:30:12 Type: ClusterIP  Cluster-IP: 10.43.21.81  External-IP: <none>  Port(s): 9115/TCP  Age: 2m5s
                            ├─ HelmRelease/trivy-system-helm               updated   2022-11-04 03:30:12 Ready: True  Status: Release reconciliation succeeded  Age: 2m5s
                            └─ HelmRepository/trivy-system-helm            updated   2022-11-04 03:30:12 URL: https://devopstales.github.io/helm-charts  Age: 2m5s  Ready: True
                                                                                                         Status: stored artifact for revision 'd120de77328f9ccbaaf5bfe8737220cac718bf34e98493d63b94ae20a4d0b92d'
```

Create a new namespace for image-scan or use your exist namespace:

```shell
vela env init image-scan --namespace image-scan
```

Set the scan label for your namespace:

```shell
vela env set image-scan --labels trivy-operator-validation=true
vela env set image-scan --labels trivy-scan=true
```

Apply an application to scan your image, following application will first deploy a `webservice` with a risky image, then scan the image and send the image result with notification.

> Check out [Notification docs](https://kubevela.io/docs/end-user/workflow/built-in-workflow-defs#notification) to see how to configure your notification.

```shell
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: example
  namespace: image-scan
spec:
  components:
    - name: frontend
      type: webservice
      properties:
        port: 8000
        image: docker.io/nginxinc/nginx-unprivileged:latest
  workflow:
    steps:
      - name: apply-comp
        type: apply-component
        properties:
          component: frontend
      - name: image-scan
        type: trivy-check
        outputs:
          - name: image-scan-result
            valueFrom: result.message
        properties:
          image: docker.io/nginxinc/nginx-unprivileged:latest
      - name: notification
        type: notification
        inputs:
          - from: image-scan-result
            parameterKey: slack.message.text
        if: always
        properties:
          slack:
            url:
              value: <slack-url>
```

Deploy this application:

```shell
vela up -f example.yaml
```

Checkout the application status:

```
$ vela status example
About:

  Name:      	example
  Namespace: 	image-scan
  Created at:	2022-11-04 12:04:10 +0800 CST
  Status:    	running

Workflow:

  mode: StepByStep-DAG
  finished: true
  Suspend: false
  Terminated: false
  Steps
  - id: dr6vd9i5dz
    name: apply-comp
    type: apply-component
    phase: succeeded
  - id: skvs1l1m9z
    name: image-scan
    type: trivy-check
    phase: succeeded
  - id: 3gvsx3bsc9
    name: notification
    type: notification
    phase: succeeded

Services:

  - Name: frontend
    Cluster: local  Namespace: image-scan
    Type: webservice
    Healthy Ready:1/1
    No trait applied
```

All the steps are successful! Trivy-operator will scan the image and send the result with CVE info to your slack channel like:

![](../../examples/trivy-operator/trivy.png)

## More

If you want to check out the scan data in raw, you can check the metrics of trivy:

```shell
kubectl port-forward service/trivy-system-trivy-system-helm-trivy-operator 9999:9115 -n trivy-system
Forwarding from 127.0.0.1:9999 -> 9115
Forwarding from [::1]:9999 -> 9115

curl -s http://localhost:9115/metrics | grep trivy_vulnerabilities

curl -s http://localhost:9115/metrics | grep ac_vulnerabilities 
```

## Reference

https://github.com/devopstales/trivy-operator
