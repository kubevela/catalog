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
vela-system     addon-trivy-operator    trivy-system-ns         k8s-objects                     running healthy                                                               2022-08-14 11:26:53 +0800 CST
vela-system     └─                      trivy-system-helm       helm                            running healthy Fetch repository successfully, Create helm release            2022-08-14 11:26:53 +0800 CST



vela env set vela-system --labels trivy-operator-validation=true
vela env set vela-system --labels trivy-scan=true


kubectl get svc -n trivy-system
NAME                                            TYPE        CLUSTER-IP        EXTERNAL-IP   PORT(S)    AGE
trivy-image-validator                           ClusterIP   192.168.113.102   <none>        443/TCP    13m
trivy-system-trivy-system-helm-trivy-operator   ClusterIP   192.168.163.69    <none>        9115/TCP   13m
kubectl port-forward service/trivy-system-trivy-system-helm-trivy-operator 9999:9115 -n trivy-system
Forwarding from 127.0.0.1:9999 -> 9115
Forwarding from [::1]:9999 -> 9115


curl -s http://localhost:9115/metrics | grep trivy_vulnerabilities

curl -s http://localhost:9115/metrics | grep ac_vulnerabilities 

reference: https://github.com/devopstales/trivy-operator
```
