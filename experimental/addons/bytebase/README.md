# bytebase

Bytebase is an open-source database DevOps tool, it's the GitLab for managing databases throughout the application development lifecycle. It offers a web-based workspace for DBAs and Developers to collaborate and manage the database change safely and efficiently.

## Install

Add experimental registry
```
vela addon registry add experimental --type=helm --endpoint=https://addons.kubevela.net/experimental/
```

Enable this addon
```shell
$ vela addon enable bytebase
```

```shell
$ vela ls -A | grep bytebase
vela-system     addon-bytebase  ns-bytebase                             k8s-objects                                     running healthy
vela-system     ├─              deploy-bytebase                         k8s-objects                                     running healthy
vela-system     └─              svc-bytebase                            k8s-objects                                     running healthy
```

Disable this addon
```
vela addon disable bytebase
```

## Use bytebase

Verify Pods of the bytebase running or not.

```shell
$ vela status -n vela-system addon-bytebase
About:

  Name:         addon-bytebase               
  Namespace:    vela-system                  
  Created at:   2023-04-24 16:40:08 +0530 IST
  Status:       running                      

Workflow:

  mode: DAG-DAG
  finished: true
  Suspend: false
  Terminated: false
  Steps
  - id: ld7g8rjscu
    name: deploy-deploy-bytebase
    type: deploy
    phase: succeeded 

Services:

  - Name: ns-bytebase  
    Cluster: local  Namespace: bytebase
    Type: k8s-objects
    Healthy 
    No trait applied

  - Name: svc-bytebase  
    Cluster: local  Namespace: bytebase
    Type: k8s-objects
    Healthy 
    No trait applied

  - Name: deploy-bytebase  
    Cluster: local  Namespace: bytebase
    Type: k8s-objects
    Healthy 
    No trait applied
```

### Run the bytebase UI locally

There is a NodePort service running in the namespace `bytebase`, So if you want to access bytebase UI, you cab access it via NodePort service URL.

```shell
# Get url to access UI
$ vela status -n vela-system addon-bytebase --endpoint
W0424 16:43:58.427811  154634 tree.go:913] ignore list resources: EndpointSlice as no matches for kind "EndpointSlice" in version "discovery.k8s.io/v1beta1"
Please access addon-bytebase from the following endpoints:
+---------+--------------+-----------------------------------------------+---------------------------+-------+
| CLUSTER |  COMPONENT   |           REF(KIND/NAMESPACE/NAME)            |         ENDPOINT          | INNER |
+---------+--------------+-----------------------------------------------+---------------------------+-------+
| local   | svc-bytebase | Service/bytebase/bytebase-nodeport-entrypoint | http://192.168.49.2:31672 | false |
+---------+--------------+-----------------------------------------------+---------------------------+-------+
```

Visit on the obtained URL to access bytebase UI.

To configure Postgres with bytebase just set the parameter `postgresURL` as shown below.

```shell
# It's just an example.
$ vela addon enable bytebase postgresURL="postgresql://<<user>>:<<secret>>@<<host>>:<<port>>/<<dbname>>"
```

**Note: Bytebase just need a running Postgres URL to connect with in the format "postgresql://<<user>>:<<secret>>@<<host>>:<<port>>/<<dbname>>"**

To know more about bytebase visit https://www.bytebase.com/docs/.
