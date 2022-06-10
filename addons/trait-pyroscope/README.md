# Supported workload type
Pyroscope Trait supports following component types: webservice、worker and cloneset.

# How to start
- Use a component typed webservice to start, keep the following to app-demo.yaml, then vela up -f app-demo.yaml
```shell
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: app-show
  namespace: real-new-ns
spec:
  components:
    - name: web-show
      type: webservice
      properties:
        exposeType: ClusterIP
        image: beellzrocks/shippingservice
        env:
        - name: PORT
          value: "50051"
        - name: APPLICATION_NAME # Application name shown in the Pyroscope UI
          value: "web-show"
        - name: SERVER_ADDRESS # To change Pyroscope Server Port change the value, the naming rule is pyroscope-<component name>
          value: "http://pyroscope-web-show:4040"
      traits:
        - type: pyroscope
```
- Check the app status
```shell
vela ls -n real-new-ns
APP             COMPONENT       TYPE            TRAITS          PHASE   HEALTHY STATUS          CREATED-TIME
app-show        web-show        webservice      pyroscope       running healthy Ready:1/1       2022-06-03 19:41:05 +0800 CST

vela status app-show -n real-new-ns
About:

  Name:         app-show
  Namespace:    real-new-ns
  Created at:   2022-06-03 19:41:05 +0800 CST
  Status:       running

Workflow:

  mode: DAG
  finished: true
  Suspend: false
  Terminated: false
  Steps
  - id:zsbjvp7fg5
    name:web-show
    type:apply-component
    phase:succeeded
    message:

Services:

  - Name: web-show
    Cluster: local  Namespace: real-new-ns
    Type: webservice
    Healthy Ready:1/1
    Traits:
      ? pyroscope
```

- Use the port-forward to visit the pyroscope UI
```shell
vela port-forward app-show 8080:4040  -n real-new-ns
? You have 3 deployed resources in your app. Please choose one: Cluster: local | Namespace: real-new-ns | Kind: Service | Name: pyroscope-web-show
Forwarding from 127.0.0.1:8080 -> 4040
Forwarding from [::1]:8080 -> 4040

Forward successfully! Opening browser ...

Failed to open browser: exec: "xdg-open": executable file not found in $PATHHandling connection for 8080
Handling connection for 8080

Then you can visit the http://<your ip>:8080 in the browser
```

