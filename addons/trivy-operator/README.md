# trivy-operator

# description
- This addon provides a vulnerability scanner that continuously scans containers deployed in a Kubernetes cluster.
- More Info is here: https://github.com/devopstales/trivy-operator/blob/main/README.md
    
## Install

```shell
vela addon enable trivy-operator
```

## Uninstall

```shell
vela addon disable trivy-operator
```

## Quick start
```shell
 vela ls -A | grep trivy
vela-system     addon-trivy-operator    trivy-operator          helm                    running healthy Fetch repository successfully, Create helm release                  2022-06-13 21:15:17 +0800 CST

vela status addon-trivy-operator -n vela-system
About:

  Name:         addon-trivy-operator         
  Namespace:    vela-system                  
  Created at:   2022-06-13 21:15:17 +0800 CST
  Status:       running                      

Workflow:

  mode: StepByStep
  finished: true
  Suspend: false
  Terminated: false
  Steps
  - id:58dtg4z65x
    name:deploy-control-plane
    type:apply-application
    phase:succeeded 
    message:
  - id:j9p8mem2m9
    name:deploy-runtime
    type:deploy2runtime
    phase:succeeded 
    message:

Services:

  - Name: trivy-operator  
    Cluster: local  Namespace: vela-system
    Type: helm
    Healthy Fetch repository successfully, Create helm release successfully
    No trait applied

vela port-forward addon-trivy-operator -n vela-system
Forwarding from 127.0.0.1:9115 -> 9115
Forwarding from [::1]:9115 -> 9115
Forward successfully! Opening browser ...

kubectl label namespaces vela-system trivy-scan=true
kubectl label namespaces vela-system trivy-operator-validation=true


curl -s http://localhost:9115/metrics | grep trivy_vulnerabilities | less
# HELP trivy_vulnerabilities Container vulnerabilities
# TYPE trivy_vulnerabilities gauge
trivy_vulnerabilities{exported_namespace="vela-system",image="devopstales/trivy-operator:2.3",installedVersion="1.34.1-r3",pkgName="busybox",pod="trivy-operator-5ff58d8f55-72lvj_trivy-operator",severity="CRITICAL",vulnerabilityId="CVE-2022-28391"} 1.0
trivy_vulnerabilities{exported_namespace="vela-system",image="devopstales/trivy-operator:2.3",installedVersion="7.80.0-r0",pkgName="curl",pod="trivy-operator-5ff58d8f55-72lvj_trivy-operator",severity="HIGH",vulnerabilityId="CVE-2022-22576"} 1.0

curl -s http://localhost:9115/metrics | grep ac_vulnerabilities 
# HELP ac_vulnerabilities Admission Controller vulnerabilities
# TYPE ac_vulnerabilities gauge

reference: https://github.com/devopstales/trivy-operator
```
