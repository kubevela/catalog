# Loki

Loki is a log aggregation system designed to store and query logs from all your applications and infrastructure.

This addon helps you to install loki and associated agents with multi-cluster supported.

## Installation

Install loki in the hub cluster.

```shell
vela addon enable loki
```

Install loki with vector agent to collect all logs in Kubernetes pods.

```shell
vela addon enable loki agent=vector
```

Alternatively, you can choose promtail agent.

```shell
vela addon enable loki agent=promtail
```

Install agents to all clusters and collect all logs.

```shell
vela addon enable loki agent=vector serviceType=LoadBalancer
```

Install vector agents to all clusters and use [vector controller](https://github.com/kubevela/vector-controller) to manage your log collection rules in detail.

```shell
vela addon enable loki agent=vector-controller serviceType=LoadBalancer
```

Install loki with persistent storage.

```shell
vela addon enable loki storage=1G
```