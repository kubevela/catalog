#!/bin/sh

ADDONS=`ls -l addons | grep "^d" | awk '{print $9}' | sort`

echo $ADDONS
for i in $ADDONS ; do
    if [ $i == "observability" ]; then
      vela addon enable $i domain=abc.com
      elif [ $i == "model-serving" ]; then
      vela addon enable ./addons/$i serviceType=ClusterIP
      else
      vela addon enable ./addons/$i
    fi

    if [ $? -ne 0 ]; then
      echo -e "\033[31m addon $i cannot enable \033[0m"
      exit 1
    else
      echo -e "\033[32m addon $i enable successfully \033[0m"
    fi
    if [ $i != "fluxcd" ] && [ $i != "terraform" ]; then
      vela addon disable $i
    fi
done

# test rollout addon
vela addon enable experimental/addons/rollout
vela addon disable rollout

# test rollout addon
vela addon enable experimental/addons/argocd
vela addon disable argocd