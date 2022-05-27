#!/bin/sh

ADDONS=`ls -l addons | grep "^d" | awk '{print $9}' | sort`

echo $ADDONS
for i in $ADDONS ; do
    if [ $i == "observability" ]; then
      vela addon enable $i domain=abc.com || vela -n vela-system status addon-$i
      elif [ $i == "model-serving" ]; then
      vela addon enable ./addons/$i serviceType=ClusterIP || vela -n vela-system status addon-$i
      elif [ $i != "ocm-gateway-manager-addon" ] && [ $i != "terraform-baidu" ] && [ $i != "dex" ] && [ $i != "flink-kubernetes-operator" ] && [ $i != "cert-manager" ]; then
      vela addon enable ./addons/$i
    fi

    if [ $? -ne 0 ]; then
      echo -e "\033[31m addon $i cannot enable \033[0m"
      kubectl get app -n vela-system addon-$i -oyaml
      exit 1
    else
      echo -e "\033[32m addon $i enable successfully \033[0m"
    fi
    if [ $i != "fluxcd" ] && [ $i != "terraform" ] && [ $i != "velaux" ]; then
      vela addon disable $i
    fi
done

# test dex addon
vela addon enable addons/dex velaux=http://velaux.com
vela addon disable dex

# test rollout addon
vela addon enable experimental/addons/argocd
vela addon disable argocd

# test istio addon
vela addon enable experimental/addons/istio
vela addon disable istio

# test dapr addon
vela addon enable experimental/addons/dapr
vela addon disable dapr

# test flink-kubernetes-operator addon
# enable flink-kubernetes-operator

declare -x DEFAULT_VELA_NS=flink
vela addon enable fluxcd
vela addon enable cert-manager
vela addon enable flink-kubernetes-operator
# set back to the DEFAULT_VELA_NS
declare -x DEFAULT_VELA_NS=vela-system
```

## Uninstall

```shell
# set the DEFAULT_VELA_NS for disabling addons
declare -x DEFAULT_VELA_NS=flink
vela addon disable flink-kubernetes-operator
vela addon disable cert-manager
vela addon disable fluxcd
# set back to the DEFAULT_VELA_NS
declare -x DEFAULT_VELA_NS=vela-system
# kubectl delete -f https://github.com/jetstack/cert-manager/releases/download/v1.7.1/cert-manager.yaml
kubectl delete ns flink
kubectl create ns flink
kubectl create -f https://github.com/jetstack/cert-manager/releases/download/v1.7.1/cert-manager.yaml
declare -x DEFAULT_VELA_NS=flink
vela addon enable fluxcd
vela addon enable flink-kubernetes-operator
# set back to the DEFAULT_VELA_NS
declare -x DEFAULT_VELA_NS=vela-system

# disable flink-kubernetes-operator
declare -x DEFAULT_VELA_NS=flink
vela addon disable flink-kubernetes-operator
vela addon disable fluxcd
# set back to the DEFAULT_VELA_NS
declare -x DEFAULT_VELA_NS=vela-system
kubectl delete -f https://github.com/jetstack/cert-manager/releases/download/v1.7.1/cert-manager.yaml
kubectl delete ns flink

# enable mysql-operator
kubectl create ns mysql-operator
declare -x DEFAULT_VELA_NS=mysql-operator
vela addon enable fluxcd
vela addon enable mysql-operator
declare -x DEFAULT_VELA_NS=vela-system

# disable mysql-operator
declare -x DEFAULT_VELA_NS=mysql-operator
vela addon disable mysql-operator
vela addon disable fluxcd
declare -x DEFAULT_VELA_NS=vela-system
kubectl delete ns mysql-operator