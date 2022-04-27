#!/bin/bash

regex="v?([0-9]+)(\.[0-9]+)?(\.[0-9]+)?(-([0-9A-Za-z\-]+(\.[0-9A-Za-z\-]+)*))?(\+([0-9A-Za-z\-]+(\.[0-9A-Za-z\-]+)*))?"

ADDONS=`ls -l addons | grep "^d" | awk '{print $9}' | sort`

echo $ADDONS

for i in $ADDONS ; do

version=$(cat addons/$i/metadata.yaml | grep "version"| awk '{print $2}')

if [[ $version =~ $regex ]];then
    echo "$i" "$version" is a semantic version
    else
      echo "$i" "$version" not a semantic version
      exit 1
fi;
done