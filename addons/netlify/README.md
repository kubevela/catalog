
# About this workload
- Netlify is a SaaS platform that can serve website especially for frontend service, it provides free allowances that was pretty cool to be used for demo and test. We can create an addon which provides a netlify component type for frontend service.
- This workload will  launch a K8s job for deploying a fronten service to https://app.netlify.com/.

# Quick start 
- Copy the following yaml to netlify-app.yaml, then vela up -f netlify-app.yaml
- The token can be got from https://app.netlify.com/user/applications/personal, and just like the following picture  show
   - https://user-images.githubusercontent.com/2173670/168455109-b6de6fcf-6e99-48c8-928c-03ff9f47d632.png

```shell
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: netlify-app
  namespace: default
spec:
  components:
    - name: netlify-comp
      type: netlify
      properties:
         sitename: deploy-from-vela
         token: <Here needs your own token from https://app.netlify.com/user/applications/personal which you should base64 >
```

- Check the app status

```shell
vela ls netlify-app
APP             COMPONENT       TYPE    TRAITS  PHASE   HEALTHY STATUS  CREATED-TIME                 
netlify-app     netlify-comp    netlify         running healthy         2022-06-14 23:42:43 +0800 CST
```
```shell
vela status netlify-app 
About:

  Name:         netlify-app                  
  Namespace:    default                      
  Created at:   2022-06-14 23:42:43 +0800 CST
  Status:       running                      

Workflow:

  mode: DAG
  finished: true
  Suspend: false
  Terminated: false
  Steps
  - id:k25g896t2o
    name:netlify-comp
    type:apply-component
    phase:succeeded 
    message:

Services:

  - Name: netlify-comp  
    Cluster: local  Namespace: default
    Type: netlify
    Healthy 
    No trait applied	
```

- Get the website url for visit
```shell
vela logs netlify-app -n default | grep "Website URL"
netlify-comp--1-b4fcg netlify-comp 2022-06-14T15:43:30.641036980Z Website URL:       https://deploy-from-vela.netlify.app
```

- More info
  - About the netlify-cli
    -  https://docs.netlify.com/
  - About the SaaS Platform
    - https://app.netlify.com/
