# keda

keda addon is based on the [`KEDA`](keda.sh) project, a Kubernetes-based Event Driven Autoscaling component. It provides event driven scale for any container running in Kubernetes.

## Install

```
vela addon enable keda
```

## Use it in application

1. Define cron hpa with the [cron trigger](https://keda.sh/docs/2.8/scalers/cron/).

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: scaler-eg-app
spec:
  components:
    - name: hello-world-scaler
      type: webservice
      properties:
        image: oamdev/hello-world
        ports:
         - port: 8000
           expose: true        
      traits:
        # This Trait used for initializing the replica
        - type: scaler
          properties:
            replicas: 1
        - type: keda-auto-scaler
          properties:
            triggers:
            - type: cron
              metadata:
                timezone: Asia/Hong_Kong  # The acceptable values would be a value from the IANA Time Zone Database.
                start: 00 * * * *       # Every hour on the 30th minute
                end: 10 * * * *         # Every hour on the 45th minute
                desiredReplicas: "3"

  policies:
    - name: apply-once
      type: apply-once
      properties:
        enable: true
        rules:
        - strategy:
            path: ["spec.replicas"]
          selector:
            resourceTypes: ["Deployment"]
```

2. Define [CPU based Trigger](https://keda.sh/docs/2.8/scalers/cpu/)


You must follow the prerequisite of this tigger:

KEDA uses standard `cpu` and `memory` metrics from the Kubernetes Metrics Server, which is not installed by default on certain Kubernetes deployments such as EKS on AWS. Additionally, the resources section of the relevant Kubernetes Pods must include limits (at a minimum).

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: scaler-eg-app
spec:
  components:
    - name: frontend
      type: webservice
      properties:
        image: oamdev/testapp:v1
        cmd: ["node", "server.js"]
        cpu: "0.1"
        ports:
          - port: 8080
            expose: true
      traits:
        # This Trait used for initializing the replica
        - type: scaler
          properties:
            replicas: 1
        - type: gateway
          properties:
            class: traefik
            classInSpec: true
            domain: test.my.domain
            http:
              "/": 8080
        - type: keda-auto-scaler
          properties:
            minReplicaCount: 1
            maxReplicaCount: 10
            cooldownPeriod: 10
            pollingInterval: 10
            triggers:
            - type: cpu
              metricType: Utilization
              metadata:
                value: "80"
  policies:
    - name: apply-once
      type: apply-once
      properties:
        enable: true
        rules:
        - strategy:
            path: ["spec.replicas"]
          selector:
            resourceTypes: ["Deployment"]
```

Expose the service entrypoint of the application

  ```
  $ vela status scaler-eg-app --endpoint
    Please access scaler-eg-app from the following endpoints:
    +---------+-----------+--------------------------+------------------------------+-------+
    | CLUSTER | COMPONENT | REF(KIND/NAMESPACE/NAME) |           ENDPOINT           | INNER |
    +---------+-----------+--------------------------+------------------------------+-------+
    | local   | frontend  | Service/default/frontend | http://frontend.default:8080 | true  |
    | local   | frontend  | Ingress/default/frontend | http://test.my.domain        | false |
    +---------+-----------+--------------------------+------------------------------+-------+
  ```

Please configure the `/etc/hosts` for ingress:

```
ab -n 300000 -c 200  http://test.my.domain/
```

Use the following command to check the replica change:

```
kubectl get deploy frontend -w
```
**video demo**

<video src="../example/keda/cpu_based_trigger_demo.mp4"></video>

The triggers and their spec align with [the official docs](https://keda.sh/docs/2.8/scalers/).