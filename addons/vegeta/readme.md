
# Supported workload type
Vegeta Trait supports following component types: webservice、worker and cloneset.

# How to start
- Use a component typed webservice to start, keep the following to show-vegeta.yaml, then vela up -f show-vegeta.yaml
```shell
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: new-vegeta
  namespace: vegeta
spec:
  components:
    - name: new-vegeta
      type: webservice
      properties:
        exposeType: ClusterIP
        image: nginx:latest
        ports:
        - expose: true
          port: 80
          protocol: TCP
          ports: 80
      traits:
        - type: vegeta
          properties:
            dorequest: 'GET http://show-vegeta:80'
            parallelism: 1
            backofflimit: 10
```

- Check the app status and trait status
```shell
vela ls app -n vegeta
APP             COMPONENT       TYPE            TRAITS  PHASE   HEALTHY STATUS          CREATED-TIME
new-vegeta      new-vegeta      webservice      vegeta  running healthy Ready:1/1       2022-05-31 21:24:28 +0800 CST

vela status  new-vegeta  -n vegeta
About:

  Name:         new-vegeta
  Namespace:    vegeta
  Created at:   2022-05-31 21:24:28 +0800 CST
  Status:       running

Workflow:

  mode: DAG
  finished: true
  Suspend: false
  Terminated: false
  Steps
  - id:rqfzusuxgj
    name:new-vegeta
    type:apply-component
    phase:succeeded
    message:

Services:

  - Name: new-vegeta
    Cluster: local  Namespace: vegeta
    Type: webservice
    Healthy Ready:1/1
    Traits:
      ? vegeta

vela logs new-vegeta --name new-vegeta -n vegeta
? You have 2 deployed resources in your app. Please choose one:  [Use arrows to move, type to filter]
> Cluster: local | Namespace: vegeta | Kind: Deployment | Name: new-vegeta
  Cluster: local | Namespace: vegeta | Kind: Job | Name: new-vegeta

Choose the Job to show testing data logs
```

- If you want a more nice demo, use the two tools: jaggr and jplot to show the data
```shell
kubectl logs new-vegeta--1-qrh67  -n vegeta -f | jaggr @count=rps hist\[100,200,300,400,500\]:code p25,p50,p95:latency sum:bytes_in sum:bytes_out | jplot rps+code.hist.100+code.hist.200+code.hist.300+code.hist.400+code.hist.500 latency.p95+latency.p50+latency.p25 bytes_in.sum+bytes_out.sum
```

- How to install jplot and jagrr
  - https://github.com/rs/jplot 
  - https://github.com/rs/jaggr
