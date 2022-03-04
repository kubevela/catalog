# Argo CD

### Info
- This addon is built based [ArgoCD](https://argo-cd.readthedocs.io/en/stable/)
- Current ArgoCD version is v2.2.5

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

TODO:
- [argocd-resource-xclusion](https://argo-cd.readthedocs.io/en/stable/operator-manual/declarative-setup/#resource-exclusioninclusion)
- argocd-cm: SSO support
- argocd-rbac-cm: rbac support
- [argocd-ssh-known-hosts-cm](https://argo-cd.readthedocs.io/en/stable/operator-manual/declarative-setup/#ssh-known-host-public-keys)

### Limitation
- Since Argocd only watch the resource under its namespace(default argocd), all the X-definitions define above 
  should be deploying into the same namespace, otherwise it doesn't work
- Please be careful to use VelaUx to deploy argo application when binding env other than "argo" namespace, because 
  all the pre-defined component definitions of argocd hardcode namespace "argocd",  binding other env will override 
  this preset then argocd will not work properly

### Configuration Reference
- TODO