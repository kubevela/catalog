# Argo CD

### Info
- This addon is built based on [ArgoCD](https://argo-cd.readthedocs.io/en/stable/)
- Current ArgoCD version is v2.3.3

### How to install

```shell
vela addon enable argocd
```

### X-Definitions

Addon argocd supports the following X-definitions:
- [argocd-application](https://argo-cd.readthedocs.io/en/stable/operator-manual/declarative-setup/#applications)
- [argocd-project](https://argo-cd.readthedocs.io/en/stable/operator-manual/declarative-setup/#projects)
- [argocd-repository-credential](https://argo-cd.readthedocs.io/en/stable/operator-manual/declarative-setup/#repositories)
- [argocd-cluster-credential](https://argo-cd.readthedocs.io/en/stable/operator-manual/declarative-setup/#clusters)
- Helm support
### Fluxcd helm support VS Argocd helm support

|       | Fluxcd  | Argocd                               |
| --------------- |---------|--------------------------------------|
| repoType        | support | git or helm support, oss not support |
| pullInterval    | support | not support                          |
| url             | support | support                              |
| secretRef       | support | not yet                              |
| timeout         | support | not support                          |
| chart           | support | support                              |
| version         | support | support                              |
| targetNamespace | support | support                              |
| releaseName     | support | support                              |
| values          | support | support                              |
| installTimeout  | support | not support                          |


TODO:
- [argocd-resource-xclusion](https://argo-cd.readthedocs.io/en/stable/operator-manual/declarative-setup/#resource-exclusioninclusion)
- argocd-rbac-cm: rbac support
- [argocd-ssh-known-hosts-cm](https://argo-cd.readthedocs.io/en/stable/operator-manual/declarative-setup/#ssh-known-host-public-keys)
- kustomize
- ksonnet

### Limitation
- Since Argocd only watch the resource under its namespace(default argocd), all the X-definitions define above 
  should be deploying into the same namespace, otherwise it doesn't work
- Please be careful to use VelaUx to deploy argo application when binding env other than "argo" namespace, because 
  all the pre-defined component definitions of argocd hardcode namespace "argocd",  binding other env will override 
  this preset then argocd will not work properly
