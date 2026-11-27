# cert-manager

[cert-manager](https://cert-manager.io) issues and renews TLS certificates in Kubernetes, from Let's Encrypt and other
ACME servers, your own CA, or self-signed. This addon installs it with its Helm chart and gives application teams two
definitions to use it:

| Definition | Type | What it does |
| --- | --- | --- |
| `issuer` | component | A ClusterIssuer or Issuer: ACME, self-signed, or a CA |
| `certificate` | trait | A Certificate for a component, written to a Secret its gateway or ingress serves |
| `cert-manager-default-issuer` | global policy, opt-in (`namespaceIssuers=true`) | Lets a namespace choose the issuer its certificates use |

Needs KubeVela 1.12 or later. On 1.11, enable the previous version: `vela addon enable cert-manager --version 2.2.0`.

Requires KubeVela 1.12 (v1.12.0-alpha.3 or later).

## Enable

```shell
vela addon enable cert-manager
```

This installs chart `v1.21.3` from `https://charts.jetstack.io` into `cert-manager`, on every cluster. It needs
Kubernetes 1.33 or later, as chart `v1.21.3` does. Pass `clusters` to choose, and the addon's parameters for the rest:

```shell
vela addon enable cert-manager clusters='{local,edge-1}' replicas=2 highAvailability=true
```

### Installing with Flux or Argo CD

The chart installs with KubeVela's built-in `helmchart` component by default. If your platform runs its charts through
Flux or Argo CD, have the addon hand cert-manager to them instead:

| `installWith` | The addon creates | Needs |
| --- | --- | --- |
| `vela` (default) | the Helm release, through `helmchart` | nothing else |
| `flux` | a HelmRepository and HelmRelease in `vela-system` | Flux 2.3 or later |
| `argo` | an Argo CD Application in `argocd` | Argo CD |

Flux adopts an existing release in place. Moving from Flux to Argo CD reinstalls cert-manager (a few seconds down; certificates and CRDs kept), and from Argo CD back to `vela` is not supported yet.

```shell
vela addon enable cert-manager installWith=flux
```

### Already running cert-manager?

| You installed it with | Enable with |
| --- | --- |
| `helm install cert-manager` into `cert-manager` | The defaults. The addon adopts the release in place. |
| Anything else: your own Flux or Argo app, OLM, your cloud provider | `chartInstall=false`: the definitions only, and the install stays yours. |

### Chart version

Each addon version pins the chart it was tested with. To take a patch release early, or install from a mirror:

```shell
vela addon enable cert-manager chart.version=v1.21.4 chart.repoURL=https://charts.example.com/jetstack
```

An override is yours to test: the definitions are checked against the pinned version. Anything older than `v1.15.0`
is refused: the chart only gained the `crds.enabled` and `crds.keep` values the addon sets in that release.

## Use

A Let's Encrypt issuer, and an application asking it for a certificate:

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: letsencrypt
  namespace: vela-system
spec:
  components:
    - name: letsencrypt
      type: issuer
      properties:
        scope: cluster
        acme:
          email: ops@example.com
          http01:
            ingressClassName: traefik
---
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: shop
spec:
  components:
    - name: shop
      type: webservice
      properties:
        image: shop:1.0
      traits:
        - type: certificate
          properties:
            dnsNames: [shop.example.com]
            issuerRef:
              name: letsencrypt
```

The certificate lands in the Secret `shop-tls`.

### The default issuer

A `certificate` trait without `issuerRef` uses the ClusterIssuer named `default`, so create the platform's default
issuer under that name (an `issuer` component called `default`, with `scope: cluster`).

With `namespaceIssuers=true` and global policies enabled (`featureGates.enableApplicationScopedPolicies` and
`featureGates.enableGlobalPolicies` on vela-core), a namespace can choose another with the annotation
`cert-manager.oam.dev/cluster-issuer: <name>`, or `cert-manager.oam.dev/issuer: <name>` for an Issuer in that namespace.
The policy runs for every Application on the cluster, which is why it is opt-in. Turning it off later leaves it in place:
`kubectl -n vela-system delete policydefinition cert-manager-default-issuer`.

## Upgrading from 2.x

3.0.0 takes over the release 2.x installed through Flux and upgrades it in place, keeping every certificate. Prepare
with the Application in [`upgrade/from-2.x.yaml`](upgrade/from-2.x.yaml), then upgrade as usual:

```shell
NS=cert-manager   # the 2.x namespace parameter, if you set one
kubectl apply -f upgrade/from-2.x.yaml
vela status cert-manager-upgrade-from-2x -n vela-system   # wait for it to be running
vela addon upgrade cert-manager releaseName=$NS-cert-manager
kubectl delete -f upgrade/from-2.x.yaml
```

It checks the namespace, then suspends the HelmRelease on every cluster 2.x deployed to. If you set the 2.x `namespace`
parameter, change `cert-manager` in the file's `NAMESPACE` variables and in the Role and RoleBinding that live in that
namespace; it refuses to run otherwise. If you set `clusters`, list the same clusters in its `every-cluster` policy.

Or by hand, suspending it on each cluster 2.x deployed to, with `--context` for each one's kubeconfig context:

```shell
NS=cert-manager   # the 2.x namespace parameter, if you set one
kubectl --context <context> -n $NS patch helmrelease cert-manager --type=merge -p '{"spec":{"suspend":true}}'
vela addon upgrade cert-manager releaseName=$NS-cert-manager
```

By hand, suspend first: otherwise Flux uninstalls cert-manager when the upgrade removes its HelmRelease. The 2.x parameters are
accepted and ignored, and what `dns01` created (the `letsencrypt` ClusterIssuer, its Certificate and token Secret, the
alidns webhook) is left running as your own. The fluxcd addon is no longer needed.

See the [cert-manager addon docs](https://kubevela.io/docs/reference/addons/cert-manager#upgrading-from-2x) for what
changes and how to remove the stored token.
