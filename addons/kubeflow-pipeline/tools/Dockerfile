FROM ubuntu:20.04

# common environemnt variables
ENV SHELL /bin/bash

# args - software versions
ARG KUBECTL_ARCH="amd64"
ARG KUBECTL_VERSION=v1.21.0

WORKDIR /downloads

# install - usefull linux packages
RUN export DEBIAN_FRONTEND=noninteractive \
  && apt-get -yq update \
  && apt-get -yq install --no-install-recommends \
      bash \
      ca-certificates \
      software-properties-common \
      bzip2 \
      git \
      curl \
      wget \
      jq \
      python3-pip \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# install - kubectl
RUN curl -sL "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${KUBECTL_ARCH}/kubectl" -o /usr/local/bin/kubectl \
  && curl -sL "https://dl.k8s.io/${KUBECTL_VERSION}/bin/linux/${KUBECTL_ARCH}/kubectl.sha256" -o /tmp/kubectl.sha256 \
  && echo "$(cat /tmp/kubectl.sha256) /usr/local/bin/kubectl" | sha256sum --check \
  && rm /tmp/kubectl.sha256 \
  && chmod +x /usr/local/bin/kubectl

# install Kubeflow Pipeline SDK
RUN pip3 install kfp --upgrade

# add script to build and upload the pipeline
COPY run.sh /entrypoint/run.sh
RUN chmod +x /entrypoint/run.sh
