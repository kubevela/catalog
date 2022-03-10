# OCM Cluster-Gateway Manager Addon

__TL;DR__: "OCM Cluster-Gateway Manager" addon installs an operator component
into the hub cluster that help the administrator to easily operate the 
configuration of cluster-gateway instances via "ClusterGatewayConfiguration"
custom resource. *WARNING* this addon will restart the cluster-gateway 
instances upon the first-time installation.

## What does "Cluster-Gateway Manager" do?

Basically it helps us to sustainably operate the cluster-gateway instances from
the following aspects:

* Automatic cluster-gateway's server TLS certificate rotation.
* Automatic cluster discovery.
* Structurize the component configuration for cluster-gateway.
* Manages the "egress identity" for cluster-gateway to access each clusters.
  
Note that the requests proxied by cluster-gateway will use the identity of 
`open-cluster-management-managed-serviceaccount/cluster-gateway` to access
the managed clusters, and by default w/ cluster-admin permission, so please
be mindful of that.


### How to confirm if the addon installation is working?

Run the following commands to check the healthiness of the addons:

```shell
$ kubectl -n <cluster> get managedclusteraddon
kubectl get managedclusteraddon -A
NAMESPACE   NAME                     AVAILABLE   DEGRADED   PROGRESSING
<cluster>   cluster-gateway          True                   
<cluster>   cluster-proxy            True                   
<cluster>   managed-serviceaccount   True 
```

In case you have too many clusters to browse at a time, install the command-line
binary via:

```shell
curl -L https://raw.githubusercontent.com/open-cluster-management-io/clusteradm/main/install.sh | bash
```

Then run the following commands to see the details of the addon:

```shell
$ clusteradm get addon
<ManagedCluster>
└── managed1
    └── cluster-gateway
    │   ├── <Status>
    │   │   ├── Available -> true
    │   │   ├── ...
    │   ├── <ManifestWork>
    │       └── clusterrolebindings.rbac.authorization.k8s.io
    │       │   ├── open-cluster-management:cluster-gateway:default (applied)
    │       └── ...
    └── cluster-proxy
    │   ├── <Status>
    │   │   ├── Available -> true
    │   │   ├── ...
    │   ├── <ManifestWork>
    │       └── ...
    └── managed-serviceaccount
        └── <Status>
        │   ├── Available -> true
        │   ├── ...
        └── <ManifestWork>
            └── ...
```

### Sample of ClusterGatewayConfiguration API

You can read or edit the overall configuration of cluster-gateway deployments
via the following command:

```shell
$ kubectl get clustergatewayconfiguration -o yaml
apiVersion: v1
kind: List
items:
- apiVersion: proxy.open-cluster-management.io/v1alpha1
  kind: ClusterGatewayConfiguration
  metadata: ...
  spec:
    egress:
      clusterProxy:
        credentials:
          namespace: open-cluster-management-addon
          proxyClientCASecretName: proxy-server-ca
          proxyClientSecretName: proxy-client
        proxyServerHost: proxy-entrypoint.open-cluster-management-addon
        proxyServerPort: 8090
      type: ClusterProxy
    image: oamdev/cluster-gateway:v1.1.11
    installNamespace: vela-system
    secretManagement:
      managedServiceAccount:
        name: cluster-gateway
      type: ManagedServiceAccount
    secretNamespace: open-cluster-management-credentials
```
