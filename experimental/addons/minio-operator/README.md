# minio-operator

MinIO is a Kubernetes-native high performance object store with an S3-compatible API. The MinIO Kubernetes Operator supports deploying MinIO Tenants onto private and public cloud infrastructures ("Hybrid" Cloud).

## Install

Add experimental registry
```
vela addon registry add experimental --type=helm --endpoint=https://addons.kubevela.net/experimental/
```

Enable this addon
```
vela addon enable minio-operator
```

```shell
$ vela ls -A | grep minio
default         tenant-sample           minio-tenant                            minio-tenant                                    rendering       healthy
vela-system     addon-minio-operator    ns-minio-operator                       k8s-objects                                     running         healthy
vela-system     └─                      minio-operator                          helm                                            running         healthy Fetch repository successfully, Create helm release
```

Disable this addon
```
vela addon disable minio-operator
```

## Use minio-operator

### Access the Operator Console to interact with tenant.

Run the following command to create a local proxy to the MinIO Operator Console:

```shell
# Get JWT Token to access the console
$ kubectl get secret -n minio-operator console-sa-secret -o=jsonpath='{.data.token}' | base64 --decode
eyJhbGciOiJSUzI1NiIsImtpZCI6ImZoSFNZMFdzUEt3WWpFVFFJdEZwSHZ1ZG9qN1ZwSy1vNC1WUi04b2tpODQifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJtaW5pby1vcGVyYXRvciIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJjb25zb2xlLXNhLXNlY3JldCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50Lm5hbWUiOiJjb25zb2xlLXNhIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQudWlkIjoiYTU3YWZmNmQtZTM5Ni00MGE3LTk0NTAtOTc4OTRkNGViY2MyIiwic3ViIjoic3lzdGVtOnNlcnZpY2VhY2NvdW50Om1pbmlvLW9wZXJhdG9yOmNvbnNvbGUtc2EifQ.h3JageNqfiWBjvMZo2XuDvEIZPwZDh2FBu_R9yAiCM248Lso7h1VVorr3yICInOnk5WcpkX6vbY3iTL-VIuNan4Ehx0WDnup4ctnbOjxGin5TJdJuuQKeIVX5adwVDd7jDPD_Pn6YGVbF2kA4538vFQNjauMw3ykmusyQINcjfq1KudwZRvw4ZCLeUVX0MLIVydQDYc2u6J5pX7OwvCUvyIgd711T9T6hLSdr9Hbp9NqrrqaWizfIlhAKlbdv202QG0U3W--BCj81TrPMZdgvF6N-djavGKB0hGlxBiyUeYJ5ncpzdnFD9ncHzj5y7giKCRBp91ctE1pOWLLFcglPA

# Port forward the console
$ kubectl port-forward -n minio-operator svc/console 9090:9090
```

Access the console on port 9090.

Each MinIO tenant represents an independent MinIO Object Store within the Kubernetes cluster

### Build the Tenant Configuration

The Operator Console **Create New Tenant** walkthrough builds out
a MinIO Tenant. The following list describes the basic configuration sections.

- **Name** - Specify the *Name*, *Namespace*, and *Storage Class* for the new Tenant.

  The *Storage Class* must correspond to a [Storage Class](#default-storage-class) that corresponds
  to [Local Persistent Volumes](#local-persistent-volumes) that can support the MinIO Tenant.

  The *Namespace* must correspond to an existing [Namespace](#minio-tenant-namespace) that does *not* contain any other
  MinIO Tenant.

  Enable *Advanced Mode* to access additional advanced configuration options.

- **Tenant Size** - Specify the *Number of Servers*, *Number of Drives per Server*, and *Total Size* of the Tenant.

  The *Resource Allocation* section summarizes the Tenant configuration
  based on the inputs above.

  Additional configuration inputs may be visible if *Advanced Mode* was enabled
  in the previous step.

- **Preview Configuration** - summarizes the details of the new Tenant.

After configuring the Tenant to your requirements, click **Create** to create the new tenant.

The Operator Console displays credentials for connecting to the MinIO Tenant. You *must* download and secure these
credentials at this stage. You cannot trivially retrieve these credentials later.

You can monitor Tenant creation from the Operator Console.

### Connect to the Tenant

Use the following command to list the services created by the MinIO
Operator:

```sh
kubectl get svc -n NAMESPACE
```

Replace `NAMESPACE` with the namespace for the MinIO Tenant. The output
resembles the following:

```sh
NAME                             TYPE            CLUSTER-IP        EXTERNAL-IP   PORT(S)      
minio                            LoadBalancer    10.104.10.9       <pending>     443:31834/TCP
myminio-console                  LoadBalancer    10.104.216.5      <pending>     9443:31425/TCP
myminio-hl                       ClusterIP       None              <none>        9000/TCP
myminio-log-hl-svc               ClusterIP       None              <none>        5432/TCP
myminio-log-search-api           ClusterIP       10.102.151.239    <none>        8080/TCP
myminio-prometheus-hl-svc        ClusterIP       None              <none>        9090/TCP
```

Applications *internal* to the Kubernetes cluster should use the `minio` service for performing object storage
operations on the Tenant.

Administrators of the Tenant should use the `minio-tenant-1-console` service to access the MinIO Console and manage the
Tenant, such as provisioning users, groups, and policies for the Tenant.

MinIO Tenants deploy with TLS enabled by default, where the MinIO Operator uses the
Kubernetes `certificates.k8s.io` API to generate the required x.509 certificates. Each
certificate is signed using the Kubernetes Certificate Authority (CA) configured during
cluster deployment. While Kubernetes mounts this CA on Pods in the cluster, Pods do
*not* trust that CA by default. You must copy the CA to a directory such that the
`update-ca-certificates` utility can find and add it to the system trust store to
enable validation of MinIO TLS certificates:

```sh

cp /var/run/secrets/kubernetes.io/serviceaccount/ca.crt /usr/local/share/ca-certificates/
update-ca-certificates
```

For applications *external* to the Kubernetes cluster, you must configure
[Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) or a
[Load Balancer](https://kubernetes.io/docs/concepts/services-networking/service/#loadbalancer) to
expose the MinIO Tenant services. Alternatively, you can use the `kubectl port-forward` command
to temporarily forward traffic from the local host to the MinIO Tenant.

For more please visit https://min.io/docs/minio/kubernetes/upstream/operations/deploy-manage-tenants.html.
