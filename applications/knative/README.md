# Integrate Knative into KubeVela

These demonstrations show how KubeVela integrates Knative Configuration/Route to deploy and manage applications.

> The demonstrations are verified in Alibaba Kubernetes Cluster v1.18.8 of Hongkong region.

## Prerequisites
- kubectl
  
- KubeVela v0.3.5+
  
  Refer to [Installation](https://kubevela.io/#/en/install?id=install-kubevela) to install KubeVela.
  
- Knative Serving v0.21
  
  Refer to [Install Knative](https://knative.dev/docs/install/any-kubernetes-cluster/) to install Knative. Remember to 1) pick 
`Istio` as the networking layer and 2) choose `Magic DNS (xip.io)` to configure DNS.
  

## Demo1: Deploy application with Knative Serving Workload, then interact with it using cURL requests

### Prepare WorkloadDefinition `knative-serving`

Convert Kind `Service` from Knative `serving.knative.dev/v1` as WorkloadDefinition `knative-serving` in [workloaddefinition-knative-serving.yaml](./workloaddefinition-knative-serving.yaml),
and deploy it.

```yaml
apiVersion: core.oam.dev/v1alpha2
kind: WorkloadDefinition
metadata:
  name: knative-serving
  annotations:
    definition.oam.dev/description: "Knative serving."
spec:
  definitionRef:
    name: services.serving.knative.dev
  schematic:
    cue:
      template: |
        output: {
        	apiVersion: "serving.knative.dev/v1"
        	kind:       "Service"
        	spec: {
        		template:
        			spec:
        				containers: [{
        					image: parameter.image
        					env:   parameter.env
        				}]
        	}
        }
        parameter: {
        	image: string
        	env?: [...{
        		// +usage=Environment variable name
        		name: string
        		// +usage=The value of the environment variable
        		value?: string
        		// +usage=Specifies a source the value of this var should come from
        		valueFrom?: {
        			// +usage=Selects a key of a secret in the pod's namespace
        			secretKeyRef: {
        				// +usage=The name of the secret in the pod's namespace to select from
        				name: string
        				// +usage=The key of the secret to select from. Must be a valid secret key
        				key: string
        			}
        		}
        	}]
        }
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
