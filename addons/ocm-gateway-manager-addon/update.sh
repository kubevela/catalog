#!/bin/bash

RELEASE_CLUSTER_GATEWAY=v1.4.0
RELEASE_CLUSTER_PROXY=v0.2.2
RELEASE_MANAGED_SERVICE_ACCOUNT=v0.2.0

REPO_CLUSTER_PROXY=git@github.com:open-cluster-management-io/cluster-proxy.git
REPO_MANAGED_SERVICEACCOUNT=git@github.com:open-cluster-management-io/managed-serviceaccount.git
REPO_CLUSTER_GATEWAY=git@github.com:oam-dev/cluster-gateway.git

set -e -u

BASEDIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
TEMPDIR=$(mktemp -d)

rm -rf "$BASEDIR"/resources
pushd "$TEMPDIR"

# cluster proxy
git clone --branch $RELEASE_CLUSTER_PROXY $REPO_CLUSTER_PROXY
mkdir -p "${BASEDIR}"/resources/cluster-proxy/"${RELEASE_CLUSTER_PROXY}"
pushd cluster-proxy
helm template -n open-cluster-management-addon \
  ./charts/cluster-proxy/ --output-dir "${BASEDIR}"/resources/cluster-proxy/"${RELEASE_CLUSTER_PROXY}"/ \
  --set tag=${RELEASE_CLUSTER_PROXY} \
  --set proxyServerImage=quay.io/open-cluster-management/cluster-proxy:$RELEASE_CLUSTER_PROXY \
  --set proxyAgentImage=quay.io/open-cluster-management/cluster-proxy:$RELEASE_CLUSTER_PROXY
popd
rm -rf cluster-proxy

# managed service account
git clone --branch $RELEASE_MANAGED_SERVICE_ACCOUNT $REPO_MANAGED_SERVICEACCOUNT
mkdir -p "${BASEDIR}"/resources/managed-serviceaccount/"${RELEASE_MANAGED_SERVICE_ACCOUNT}"
pushd managed-serviceaccount
helm template  -n open-cluster-management-addon \
  ./charts/managed-serviceaccount/ --output-dir "${BASEDIR}"/resources/managed-serviceaccount/"${RELEASE_MANAGED_SERVICE_ACCOUNT}"/ \
  --set tag=${RELEASE_MANAGED_SERVICE_ACCOUNT}
popd
rm -rf managed-serviceaccount

# cluster-gateway
git clone --branch $RELEASE_CLUSTER_GATEWAY $REPO_CLUSTER_GATEWAY
mkdir -p "${BASEDIR}"/resources/cluster-gateway/"${RELEASE_CLUSTER_GATEWAY}"
pushd cluster-gateway
helm template  -n open-cluster-management-addon \
  ./charts/addon-manager/ --output-dir "${BASEDIR}"/resources/cluster-gateway/"${RELEASE_CLUSTER_GATEWAY}"/ \
  --set tag=${RELEASE_CLUSTER_GATEWAY} \
  --set manualSecretManagement=false \
  --set konnectivityEgress=true
popd
rm -rf cluster-gateway

popd
rmdir "$TEMPDIR"

