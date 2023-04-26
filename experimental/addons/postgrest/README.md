# postgrest

PostgREST is a standalone web server that turns your PostgreSQL database directly into a RESTful API. The structural constraints and permissions in the database determine the API endpoints and operations. For more visit https://postgrest.org/en/stable/

## Install

Add experimental registry
```
vela addon registry add experimental --type=helm --endpoint=https://addons.kubevela.net/experimental/
```

Enable this addon
```
$ vela addon enable postgrest
```

```shell
$ vela ls -A | grep postgrest
vela-system             addon-postgrest                 postgrest                               webservice                                              running healthy Ready:1/1
vela-system             └─                              svc-postgrest                           k8s-objects                                             running healthy
```

Disable this addon
```
vela addon disable postgrest
```

## Use postgrest

Verify Pods of the postgrest running or not.

```shell
$ vela status -n vela-system addon-postgrest
About:

  Name:         addon-postgrest              
  Namespace:    vela-system                  
  Created at:   2023-04-26 17:15:56 +0530 IST
  Status:       running                      

Workflow:

  mode: DAG-DAG
  finished: true
  Suspend: false
  Terminated: false
  Steps
  - id: iw7rsv2fq6
    name: deploy-deploy-postgrest
    type: deploy
    phase: succeeded 

Services:

  - Name: svc-postgrest  
    Cluster: local  Namespace: prod
    Type: k8s-objects
    Healthy 
    No trait applied

  - Name: postgrest  
    Cluster: local  Namespace: prod
    Type: webservice
    Healthy Ready:1/1
    No trait applied
```

### Run the postgrest

There is a NodePort service running in the namespace `prod`, So if you want to access postgrest UI, you can access it via NodePort service URL.

```shell
# Get url to access UI
$ vela status -n vela-system addon-postgrest --endpoint
W0426 17:40:12.814922  874502 tree.go:913] ignore list resources: EndpointSlice as no matches for kind "EndpointSlice" in version "discovery.k8s.io/v1beta1"
Please access addon-postgrest from the following endpoints:
+---------+---------------+--------------------------------------------+--------------------+-------+
| CLUSTER |   COMPONENT   |          REF(KIND/NAMESPACE/NAME)          |      ENDPOINT      | INNER |
+---------+---------------+--------------------------------------------+--------------------+-------+
| local   | svc-postgrest | Service/prod/postgrest-nodeport-entrypoint | 192.168.49.2:31426 | false |
+---------+---------------+--------------------------------------------+--------------------+-------+
```

Visit on the obtained URL to access postgrest web server.

To configure Postgres with Postgrest just set the parameter `PGRST_DB_URI` as shown below.

```shell
# It's just an example.
$ vela addon enable postgrest PGRST_DB_URI="postgresql://<<user>>:<<secret>>@<<host>>:<<port>>/<<dbname>>"
```

**Note: Postgrest just need a running Postgres URL to connect with in the format "postgresql://<<user>>:<<secret>>@<<host>>:<<port>>/<<dbname>>"**

To know more about postgrest visit https://postgrest.org/en/stable/.
