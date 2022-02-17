#!/bin/sh

ADDONS=`ls -l addons | grep "^d" | awk '{print $9}' | sort`

echo $ADDONS
for i in $ADDONS ; do
    if [ $i == "observability" ]; then
      vela addon enable $i domain=abc.com
      else if [ $i == "model-serving" ]; then
        vela addon enable ./addons/$i serviceType=ClusterIP
      else
      vela addon enable ./addons/$i
    fi

    kubectl get app addon-$i -n vela-system

    if [ $? -ne 0 ]; then
      echo -e "\033[31m addon $i cannot enable \033[0m"
      exit 1
    else
      echo -e "\033[32m addon $i enable successfully \033[0m"
    fi
done

# test rollout addon
vela addon enable experimental/addons/rollout