# postgres-operator

This is an addon template. Check how to build your own addon: https://kubevela.net/docs/platform-engineers/addon/intro

## Install

Add experimental registry
```
vela addon registry add experimental --type=helm --endpoint=https://addons.kubevela.net/experimental/
```

Enable this addon
```
vela addon enable postgres-operator
```

```shell
$ vela ls -A | grep postgres
vela-system     addon-postgres-operator          ns-postgres-operator     k8s-objects                             running healthy                                                               
vela-system     └─                              postgres-operator         helm                                    running 
healthy Fetch repository successfully, Create helm release
```

Disable this addon
```
vela addon disable postgres-operator
```

## Use
## postgres-operator

After you enable this addon, create a namespace `prod`:

```shell
$ kubectl create namespace prod
```

Then apply this Application yaml to create a postgres cluster:

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: postgres-operator-sample
spec:
  components:
    - type: "postgres-cluster"
      namespace: prod
      name: postgres
      properties:
        replicas: 3
```

If you want to create a service to access Postgres, So apply below YAML:

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: postgres-operator-sample
spec:
  components:
    - type: "postgres-cluster"
      name: "postgres"
      namespace: "default"
      properties:
        replicas: 3 # By default it's set to 2.
      traits:
        - type: postgres-expose
          properties:
            type: NodePort    # Change this field if you want diffrent type of service.
            port: 5432
            targetPort: 5432
```

```shell
$ kubectl get po  -n prod  -o wide
NAME         READY   STATUS    RESTARTS   AGE     IP            NODE       NOMINATED NODE   READINESS GATES
postgres-0   1/1     Running   0          2m30s   10.244.1.73   minikube   <none>           <none>
postgres-1   1/1     Running   0          2m20s   10.244.1.74   minikube   <none>           <none>
postgres-2   1/1     Running   0          105s    10.244.1.75   minikube   <none>           <none>
```

### Connect to PostgreSQL via psql

With a port-forward on one of the database pods (e.g. the master) you can connect to the PostgreSQL database from your machine. Use labels to filter for the master pod of our test cluster.

```shell
# get name of master pod of acid-minimal-cluster
$ export PGMASTER=$(kubectl get pods -n prod -o jsonpath={.items..metadata.name} -l application=spilo,cluster-name=postgres,spilo-role=master -n prod)

# set up port forward
kubectl port-forward $PGMASTER -n prod 5432:5432 -n prod
```

Open another CLI and connect to the database using e.g. the psql client. When connecting with a manifest role like foo_user user, read its password from the K8s secret which was generated when creating acid-minimal-cluster. As non-encrypted connections are rejected by default set SSL mode to require:

```shell
$ export PGPASSWORD=$(kubectl get secret -n prod postgres.postgres.credentials.postgresql.acid.zalan.do -o 'jsonpath={.data.password}' | base64 -d)
$ export PGSSLMODE=require
$ psql -U postgres -h localhost -p 5432
```
