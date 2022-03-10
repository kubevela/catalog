# OCM Hub Control Plane

__TL;DR__: Our "OCM Cluster Manager" addon will be helping you to initiate 
and install the [cluster manager](https://open-cluster-management.io/getting-started/core/cluster-manager/)
(i.e. OCM's control plane) components into the hosting cluster where your 
KubeVela control plane is running. Additionally by further configuration, 
we can opt-in to delegate the (1) token rotation (2) cluster discovery to 
the OCM's original control plane. Put it another way, before enabling this 
addon, admins of KubeVela is supposed to manage the tokens manually with the 
help of `vela` command line tool and the token will be immutable which 
potentially leaves the clusters being managed by the KubeVela control plane 
under the risk of being accessed by an unwelcome client that copies the token 
due to leakage.

## Background

### About KubeVela's multi-cluster management

KubeVela's native multi-cluster functionalities is basically working over
the [cluster-gateway](https://github.com/oam-dev/cluster-gateway) which is
responsible for routing and proxying kube api requests to the "controllee
clusters". Simply put, the cluster-gateway is an aggregated apiserver that
plugs a new "clustergateways/proxy" resource into the hosting cluster where
your KubeVela controller is running, and it will help you deliver your 
requesting payload to the target cluster without direct access. By this mean,
the KubeVela controller will be able to dynamically automate the multiple 
clusters configured/discovered.

### About OCM

OCM (Open Cluster Manager) is a modular, extensible, multi-cluster
platform providing users various multi-cluster functionalities as atomic
"building blocks" to orchestrate their multi-cluster control plane.
A minimal setup of OCM (which you will get after installing this addon)
merely covers nothing other than a [registration-operator](https://github.com/open-cluster-management-io/registration-operator)
which is a typical Kubernetes operator that installs/upgrades OCM components
for you. Ideally you will walk through the journey of experiencing OCM
w/o knowing the sub-projects under the hood.

## Do I need "OCM Cluster Manager"?

As is already clarified in the head of this document, you will turn to this 
addon if you:

- Want to rotate the client credential (service-account token) periodically.
- Want KubeVela to automate the cluster discovery.

In addition to that, after setting up the OCM control plane, you also opened
the "chocolate box" of more OCM's capabilities, such as:

- [Cluster-Proxy](https://github.com/open-cluster-management-io/cluster-proxy): 
  Connecting the target clusters over Konnectivity proxy tunnel that help your
  KubeVela control plane to talk to the clusters literally __anywhere__ in the
  world regardless of VPC isolation, firewalls, etc. 
  
- [Placement](https://github.com/open-cluster-management-io/placement): 
  Enabling you to replicate resources towards multiple cluster selected from the
  powerful cluster selection primitives or even score-based scheduling.
  
## How to confirm the addon installation is all set?

The overall status of the "OCM Cluster Manager" addon is visible by the 
following command in which you can clearly see if there's anything going wrong
with the addon installation:

```shell
$ kubectl get clustermanager cluster-manager -o yaml
apiVersion: operator.open-cluster-management.io/v1
kind: ClusterManager
metadata: ...
spec: ...
status:
  conditions:
  - lastTransitionTime: "2021-12-08T09:49:26Z"
    message: Registration is managing credentials
    reason: RegistrationFunctional
    status: "False"
    type: HubRegistrationDegraded
  - lastTransitionTime: "2021-12-08T09:49:40Z"
    message: Placement is scheduling placement decisions
    reason: PlacementFunctional
    status: "False"
    type: HubPlacementDegraded
  - lastTransitionTime: "2021-12-08T09:49:05Z"
    message: Components of cluster manager is applied
    reason: ClusterManagerApplied
    status: "True"
    type: Applied
...    
```

## What's next after installation?

### Syncing up cluster metadata

For clarification, after the successful installation of the addon, sadly the OCM 
control plane cannot automatically sync up with the previously joined cluster in
KubeVela, so it's recommended to repeat the cluster joining manually with:

```shell
$ vela cluster join \
     <path to the kubeconfig of your joining managed cluster> \
     -t ocm \
     --name my-cluster
# Remember to set "--in-cluster-boostrap=false" if you want the cluster registration works over the internet
```

Then the joining cluster is supposed to be listed as a [ManagedCluster](https://open-cluster-management.io/concepts/managedcluster/)
in terms of your OCM control plane:

```shell
$ kubectl get managedclusters
NAME       HUB ACCEPTED   MANAGED CLUSTER URLS          JOINED   AVAILABLE   AGE
my-cluster true           https://x.x.x.x:6443          True     True        1h
```

### Set up dynamic cluster discovery

After your OCM environment is all set, you can delegate the cluster registration
to OCM by installation additional OCM modules including:

- [Managed Service Account](https://github.com/open-cluster-management-io/managed-serviceaccount):
  A multi-cluster service account managing framework.

- [Cluster Gateway Operator](https://github.com/oam-dev/cluster-gateway/tree/master/cmd/addon-manager):
  The operator that consistently pipes OCM's cluster metadata to KubeVela.

The further installation can be done by the following helm commands:

```shell
$ helm repo add ocm https://open-cluster-management.oss-us-west-1.aliyuncs.com
$ helm repo update
$ # install the addons
$ helm -n open-cluster-management-addon install cluster-proxy ocm/cluster-proxy --create-namespace
$ helm -n open-cluster-management-addon install managed-serviceaccount ocm/managed-serviceaccount
$ helm -n open-cluster-management-addon install cluster-gateway ocm/cluster-gateway-addon-manager
# check addon installation
$ kubectl get managedclusteraddon -n <cluster name> 
NAMESPACE           NAME                    AVAILABLE   DEGRADED   PROGRESSING
<cluster name>      cluster-proxy           True     
<cluster name>      managed-serviceaccount  True     
<cluster name>      cluster-gateway         True  
```

An illustrative instruction for registering clusters via OCM is already 
prepared for you over here:

> https://open-cluster-management.io/getting-started/quick-start/#deploy-a-klusterlet-agent-on-your-managed-cluster


## Materials

- KubeCon 2021 China - demo KubeVela x OCM integration: [https://sched.co/pcaU](https://sched.co/pcaU)
- Open-Cluster-Management home page: [https://open-cluster-management.io/](https://open-cluster-management.io/)

## Support

Please reach out to the KubeVela official dev squad for the support.

