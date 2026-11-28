---
title: Guide
sidebar_position: 20
displayed_sidebar: addons
---

<!-- The addon's README at release/kube-state-metrics/v0.3.0. -->

[kube-state-metrics](https://github.com/kubernetes/kube-state-metrics) is a simple service that listens to the Kubernetes API server and generates metrics about the state of the objects.

The metrics are exported on the HTTP endpoint /metrics on the listening port (8080).

## Installation

```shell
vela addon enable kube-state-metrics
```
