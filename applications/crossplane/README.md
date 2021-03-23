# Crossplane cloud resource provisioning and consuming 

These demonstrations show how cloud resourced are provisioned by Crossplane provider, and consumed by KubeVela applications.

> The demonstrations are verified in Alibaba Kubernetes Cluster v1.18.8 in Hongkong region.

## Prerequisites
- kubectl

- KubeVela v1.0.0-rc
  
- Crossplane provider-alibaba v0.5.0
  
  Refer to [Installation](https://github.com/crossplane/provider-alibaba/releases/tag/v0.5.0) to install Crossplane Alibaba provider.

    ```
    $ kubectl crossplane install provider crossplane/provider-alibaba:v0.5.0

    $ kubectl create secret generic alibaba-account-creds -n crossplane-system --from-literal=accessKeyId=xxx --from-literal=accessKeySecret=yyy

    $ kubectl apply -f provider.yaml
    ```

## Provision cloud resources

### Prepare ComponentDefinition `alibaba-rds`

[componentdefinition-rds.yaml](./componentdefinition-rds.yaml) is the ComponentDefinition for Alibaba RDS cloud resource,
which aims to create an RDS instance from Alibaba Cloud by Crossplane Alibaba provider.

```yaml
apiVersion: core.oam.dev/v1alpha2
kind: ComponentDefinition
metadata:
  name: alibaba-rds
  namespace: vela-system
  annotations:
    definition.oam.dev/description: "Alibaba Cloud RDS Resource"
spec:
  workload:
    definition:
      apiVersion: database.alibaba.crossplane.io/v1alpha1
      kind: RDSInstance
  schematic:
    cue:
      template: |
        output: {
        	apiVersion: "database.alibaba.crossplane.io/v1alpha1"
        	kind:       "RDSInstance"
        	spec: {
        		forProvider: {
        			engine:                parameter.engine
        			engineVersion:         parameter.engineVersion
        			dbInstanceClass:       parameter.instanceClass
        			dbInstanceStorageInGB: 20
        			securityIPList:        "0.0.0.0/0"
        			masterUsername:        parameter.username
        		}
        		writeConnectionSecretToRef: {
        			namespace: context.namespace
        			name:      context.appName + "-" + parameter.name
        		}
        		providerConfigRef: {
        			name: "default"
        		}
        		deletionPolicy: "Delete"
        	}
        }
        parameter: {
        	engine:          *"mysql" | string
        	engineVersion:   *"8.0" | string
        	instanceClass:   *"rds.mysql.c1.large" | string
        	username:        string
        }

```

### Deploy an application

The application [application-v1-provision-cloud-resource.yaml](./application-v1-provision-cloud-resource.yaml) will just include
a component based the ComponentDefiniton above to create an RDS instance.

```yaml
apiVersion: core.oam.dev/v1alpha2
kind: Application
metadata:
  name: webapp
spec:
  components:
    - name: sample-db
      type: alibaba-rds
      settings:
        name: sample-db
        engine: mysql
        engineVersion: "8.0"
        instanceClass: rds.mysql.c1.large
        username: oamtest
        outputSecretName: db-conn

```

Apply it and watch the cloud resource provisioning. A secret `webapp-sample-db` will also be create in the same namespace as the application.

```shell
$ kubectl apply -f application-provision-cloud-resource.yaml

$ kubectl get component
NAME             WORKLOAD-KIND   AGE
sample-db        RDSInstance     12h

$ kubectl get rdsinstance
NAME           READY   SYNCED   STATE     ENGINE   VERSION   AGE
sample-db-v1   True    True     Running   mysql    8.0       11h

$ kubectl get secret
NAME                                              TYPE                                  DATA   AGE
webapp-sample-db                                  connection.crossplane.io/v1alpha1     3      11h
```

The outputSecretName `db-conn` will be stored in `context` as a key to context.outputSecretName (`map[string]string` type),
whose value is in the format `$appName-$componentName`, ie, `webapp-sample-db` in this example.

## Consume cloud resources

Add business component `express-server` in the application [application-v2-consume-cloud-resource.yaml](./application-v2-consume-cloud-resource.yaml).
It states the outputSecret `db-conn` from component `sample-db` will be used, and its required environments are `username`, `endpoint` and `port`.

```yaml
apiVersion: core.oam.dev/v1alpha2
kind: Application
metadata:
  name: webapp
spec:
  components:
    - name: express-server
      type: deployment
      settings:
        image: zzxwill/flask-web-application:v0.3.1-crossplane
        ports: 80
        secretRef:
          - name: db-conn
            environment:
              - username
              - endpoint
              - port

    - name: sample-db
      ...
      settings:
        outputSecretName: db-conn
      ...
```

Here are two ways to consume the RDS instance. Option 1) is recommended.

1) Extract `parameter.secretRef` in ComponentDefinition.

In the ComponentDefinition of component `express-server` [componentdefinition-deployment.yaml](./componentdefinition-deployment.yaml), we extract `parameter.secretRef`
to the standard format of `spec.template.spec.containers.0.env` field.

```cue
      import "list"

      output: {
      	apiVersion: "apps/v1"
      	kind:       "Deployment"
      	spec: {
      		template: {
      			spec: {
      				containers: [{
      					if parameter["secretRef"] != _|_ {
      						env:
      							list.FlattenN([ for c in parameter.secretRef {
      								[ for k in c.environment {
      									name: k
      									valueFrom: {
      										secretKeyRef: {
      											name: context.outputSecretName[c.name]
      											key:  k
      										}
      									}
      								},
      								]
      							}], 1)
      					}
      				}]
      		}
      		}
      	}
      }

      parameter: {
      	// +usage=Referred config
      	secretRef?: [...{
      		// +usage=Referred secret name
      		name: string
      		// +usage=Key from KubeVela config
      		environment: [...string]
      	}]
      }
```

Apply the ComponentDefinition and updated Application, and see the cloud resource is successfully consumed by business component.

```shell
$ kubectl apply -f componentdefinition-deployment.yaml

$ kubectl apply -f application-v2-consume-cloud-resource.yaml

$ kubectl port-forward deployment/express-server-v5 80:80
```

![](./visit-application.jpg)

In all, platform builders is recommended to add the following Cuelang template to field `spec.template.spec.containers.*`.

```cue
if parameter["secretRef"] != _|_ {
  env:
   list.FlattenN([ for c in parameter.secretRef {
     [ for k in c.environment {
       name: k
       valueFrom: {
         secretKeyRef: {
           name: context.outputSecretName[c.name]
           key:  k
         }
      }
     },
     ]
   }], 1)
}
```

2) Literally use standard env mapping

```yaml
apiVersion: core.oam.dev/v1alpha2
kind: Application
metadata:
  name: webapp
spec:
  components:
    - name: express-server
      type: webservice
      settings:
        image: zzxwill/flask-web-application:v0.3.1-crossplane
        ports: 80
        env:
          - name: username
            valueFrom:
              secretKeyRef: 
                name: context.outputSecretName["db-conn"]
                key:  username
          - name: endpoint
            valueFrom:
              secretKeyRef:
                name: context.outputSecretName["db-conn"]
                key:  endpoint
          - name: port
            valueFrom:
              secretKeyRef:
                name: context.outputSecretName["db-conn"]
                key:  port

    - name: sample-db
      type: alibaba-rds
      settings:
        outputSecretName: db-conn
```
