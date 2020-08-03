# SidecarTrait

Deploy sidecar to workload or kubernetes native resources

## Supported workloads:
- Pod
- ReplicaSet
- StatefulSet
- Deployment
- ContainerizedWorkload

## Prerequisites
Please follow [common prerequisites](../../README.md) to install OAM Controllers.

## Getting started
- Get the SidecarTrait project to your GOPATH
```console
git clone https://github.com/oam-dev/catalog.git
```
- Install CRD to your Kubernetes cluster
```console
cd catalog/traits/sidecartrait/

make install
```
- Run the SidecarTrait controller
```console
go run main.go
```

### ContainerizedWorkload

- Apply the sample ContainerizedWorkload
```console
$ kubectl create namespace sidecar-test
$ kubectl -n sidecar-test apply -f config/samples/containerized-workload/difinition
$ kubectl -n sidecar-test apply -f config/samples/containerized-workload/sample_component.yaml
$ kubectl -n sidecar-test apply -f config/samples/containerized-workload/sample_application_config.yaml
```

```yaml
# ./config/samples/contaierized/sample_application_config.yaml

  ...
      traits:
        - trait:
            apiVersion: core.oam.dev/v1alpha2
            kind: SidecarTrait
            metadata:
              name: sample-sidecart
            spec:
              container:
                name: nginx-sidecar
                image: nginx:1.13.12
                ports:
                  - containerPort: 8080
                    name: sidecarport
              volumes:
                - name: data
                  emptyDir : {}
                - name: data2
                  emptyDir: {}
```
 
- Verify SidecarTrait you should see a deployment created by ContainerizedWorkload
```console
$ kubectl -n sidecar-test  get deployment
NAME                         READY   UP-TO-DATE   AVAILABLE   AGE
example-component   1/1     1            1           15s
```
```console
$ kubectl -n sidecar-test get deployment -o yaml

  ...
      spec:
        containers:
        - env:
          - name: ALLOW_EMPTY_PASSWORD
            value: "yes"
          image: bitnami/redis:latest
          name: redis-main
          ports:
          - containerPort: 6379
            name: redisport
            protocol: TCP
        - image: nginx:1.13.12
          name: nginx-sidecar
          ports:
          - containerPort: 8080
            name: sidecarport
            protocol: TCP

        volumes:
        - emptyDir: {}
          name: data
        - emptyDir: {}
          name: data2
  ...
```
# How it work?

Essentially, the SidecarTrait controller will patch the corresponding resources based on the workload spec.

In detail:
- If the workload type is [ContainerizedWorkload](https://github.com/crossplane/addon-oam-kubernetes-local) which has two child resources (Deployment and Service), SidecarTrait can deploy sidecar to Deployment
- If the workload type is K8S native resources ([StatefulSet](https://github.com/oam-dev/catalog/blob/master/workloads/statefulset/README.md), [Deployment](https://github.com/oam-dev/catalog/blob/master/workloads/deployment/README.md), Pod, ReplicaSet), SidecarTrait can deploy sidecar based on `spec.template.spec.containers` or `spec.containers`. 
