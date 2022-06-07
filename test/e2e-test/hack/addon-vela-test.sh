#!/bin/sh

# test dependencies-addon install
vela addon enable fluxcd
vela addon enable terraform
vela addon enable cert-manager
vela addon enable velaux


# test common-addon install and unInstall
ADDONS=`ls -l addons | grep "^d" | awk '{print $9}' | sort`
echo $ADDONS
for i in $ADDONS ; do
    if [ $i == "observability" ]; then
      vela addon enable $i domain=abc.com || vela -n vela-system status addon-$i
      elif [ $i == "model-serving" ]; then
      vela addon enable ./addons/$i serviceType=ClusterIP || vela -n vela-system status addon-$i
      elif  [ $i != "ocm-gateway-manager-addon" ] && [ $i != "terraform-baidu" ] && [ $i != "fluxcd" ] && [ $i != "terraform" ] && [ $i != "velaux" ] && [ $i != "dex" ] && [ $i != "cert-manager" ] && [ $i != "flink-kubernetes-operator" ]; then
      vela addon enable ./addons/$i
    fi

    if [ $? -ne 0 ]; then
      echo -e "\033[31m addon $i cannot enable \033[0m"
      kubectl get app -n vela-system addon-$i -oyaml
      exit 1
    else
      echo -e "\033[32m addon $i enable successfully \033[0m"
    fi
    if [ $i != "fluxcd" ] && [ $i != "terraform" ] && [ $i != "velaux" ] && [ $i != "dex" ] && [ $i != "cert-manager" ] && [ $i != "flink-kubernetes-operator" ]; then
      vela addon disable $i
    fi
done


## test ns-dependencies-addon install and unInstall
# flink-kubernetes-operator
kubectl create ns flink
declare -x DEFAULT_VELA_NS=flink
vela addon enable flink-kubernetes-operator
vela addon disable flink-kubernetes-operator
declare -x DEFAULT_VELA_NS=vela-system
kubectl delete ns flink

# mysql-operator addon
kubectl create ns mysql-operator
declare -x DEFAULT_VELA_NS=mysql-operator
vela addon enable mysql-operator
vela addon disable mysql-operator
declare -x DEFAULT_VELA_NS=vela-system
kubectl delete ns mysql-operator


## test extra-addon install and unInstall
vela addon enable addons/dex velaux=http://velaux.com
vela addon disable dex


## test experimental-addon install and unInstall
# rollout
vela addon enable experimental/addons/argocd
vela addon disable argocd

# istio
vela addon enable experimental/addons/istio
vela addon disable istio

# dapr
vela addon enable experimental/addons/dapr
vela addon disable dapr


## test dependencies-addon unInstall
for i in $(seq 1 1 5)
do
  echo "the $i time retry"
  vela addon disable velaux
  vela addon disable cert-manager
  vela addon disable terraform
  vela addon disable fluxcd
  sleep 5s
done