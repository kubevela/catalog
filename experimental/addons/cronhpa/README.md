# cronhpa

This addon is built based [kubernetes-cronhpa-controller](https://github.com/AliyunContainerService/kubernetes-cronhpa-controller/)

## install
```shell
vela addon enable cronhpa
```

## usage

This addon exposes one Trait "cronhpa", it provides cron horizontal pod autoscaler controller using crontab like scheme.

### properties  

```shell

# properties
+------------------+---------------------------------------------------------------------------------------------+-----------------------+----------+------------+
|       NAME       |                                         DESCRIPTION                                         |         TYPE          | REQUIRED |  DEFAULT   |
+------------------+---------------------------------------------------------------------------------------------+-----------------------+----------+------------+
| targetAPIVersion | Specify the apiVersion of scale target.                                                     | string                | false    | apps/v1    |
| targetKind       | Specify the kind of scale target.                                                           | string                | false    | Deployment |
| excludeDates     | Specify the job will skip the execution when the dates is matched. The minimum unit is day. | []string              | false    |            |
| hpaJobs          | Specify multiple cron hpa jobs.                                                             | [[]hpaJobs](#hpajobs) | true     |            |
+------------------+---------------------------------------------------------------------------------------------+-----------------------+----------+------------+


## hpaJobs
+------------+------------------------------------------------------------------------------------------------------+--------+----------+---------+
|    NAME    |                                             DESCRIPTION                                              |  TYPE  | REQUIRED | DEFAULT |
+------------+------------------------------------------------------------------------------------------------------+--------+----------+---------+
| name       | Specify the name of hpa job, should be unique in one cronhpa spec.                                   | string | true     |         |
| schedule   | Specify the cron schedule strategy.                                                                  | string | true     |         |
| targetSize | Specify the size you desired to scale when the scheduled time arrive.                                | int    | true     |         |
| runOnce    | Specify if this job need executed repeatly, if runOnce is true then the job will only run and exit   | bool   | false    | false   |
|            | after the first execution.                                                                           |        |          |         |
+------------+------------------------------------------------------------------------------------------------------+--------+----------+---------+
```

sample as below:
```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: helloworld
spec:
  components:
    - name: helloworld
      type: webservice
      properties:
        cpu: "0.5"
        exposeType: ClusterIP
        image: oamdev/hello-world
        memory: 1024Mi
        ports:
          - expose: true
            port: 80
            protocol: TCP
      traits:
        - type: cronhpa
          properties:
            targetAPIVersion: apps/v1
            targetKind: Deployment
            excludeDates:
              - '* * * 15 11 *'
              - '* * * * * 5'
            hpaJobs:
              - name: scale-down
                runOnce: false
                schedule: "30 */1 * * * *"
                targetSize: 1
              - name: scale-up
                runOnce: false
                schedule: "0 */1 * * * *"
                targetSize: 3
  policies:
    - name: apply-once
      type: apply-once
      properties:
        enable: true
        rules:
          - strategy:
              path: ["spec.replicas"]
            selector:
              resourceTypes: ["Deployment","StatefulSet"]
```