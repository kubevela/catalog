# redis-operator

Redis Operator creates/configures/manages high availability redis with sentinel automatic failover atop Kubernetes.

This addon will give you the ability to use `redis-failover` Components in Applications.

## Quick Start

In this example, we will :
- start a high-availability Redis cluster with Sentinel
- scale it up/down
- use `redis-cli` to connect and read/write some data

Let's get started.

After you enable this addon, apply this Application yaml to create a Redis cluster:

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: redis-operator-sample
spec:
  components:
    # This component is provided by redis-operator addon.
    # In this example, 2 redis instance and 2 sentinel instance
    # will be created.
    - type: redis-failover
      # Remember this name, we will use it to find the Service to connect.
      name: ha-redis
      properties:
        # You can increase/decrease this later to add/remove instances.
        replicas: 2
```

Verify if we have 2 Redis instances available:

```shell
$ vela status redis-operator-sample --tree --detail
# DETAIL
# NAME: ha-redis  REDIS: 2  SENTINELS: 2
# AGE: 17m
```
As we can see, 2 instances are available. Great.

Scale up/down. As an example, we will scale it down to 1:

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: redis-operator-sample
spec:
  components:
    - type: redis-failover
      name: ha-redis
      properties:
        # Change this value. For example, we try to scale it down to 1.
        replicas: 1
```

After applying this yaml, we should see we only have 1 Redis instance available now:

```shell
$ vela status redis-operator-sample --tree --detail
# DETAIL
# NAME: ha-redis  REDIS: 1  SENTINELS: 1
# AGE: 34m
```

Now, we will try to connect to the Redis cluster (specifically, connect to Sentinel service). To connect, we need to know where to connect to first. Use vela status to get the Sentinel endpoint:

```shell
$ vela status redis-operator-sample --endpoint
# +---------+-----------+------------------------------+----------------------------+-------+
# | CLUSTER | COMPONENT |   REF(KIND/NAMESPACE/NAME)   |          ENDPOINT          | INNER |
# +---------+-----------+------------------------------+----------------------------+-------+
# | local   | ha-redis  | Service/default/rfs-ha-redis | rfs-ha-redis.default:26379 | true  |
# +---------+-----------+------------------------------+----------------------------+-------+
```

We know the endpoint is `rfs-ha-redis.default:26379`. To use `redis-cli`, we will attach a terminal to one of the Redis pods.

```shell
vela exec redis-operator-sample -- /bin/sh
# Choose rfr-ha-redis-0
```

Your terminal should be attached to the Pod. Inside that terminal, type:

```shell
# Connect to Sentinel
# rfs-ha-redis is the Service name of Sentinel. 
# Remember our Component name (ha-redis)? It is rfs-<component-name>. 
# And the port is 26379
redis-cli -h rfs-ha-redis.default -p 26379

# You should have redis-cli connected to Sentinel now.
# Now, find where the master is. `mymaster` is hard-coded by the operator
SENTINEL get-master-addr-by-name mymaster
# For example, you have results: 1) "172.17.0.6" 2) "6379"
# ctrl+D to exit and
# Use this info to connect to the master node.
redis-cli -h 172.17.0.6

# Try to store a value.
SET mykey "Hello, RedisFailover"

# Get the value.
GET mykey
# "Hello, RedisFailover"
```

## Notes

The operator has the ability of add persistence to Redis data. By default an emptyDir will be used, so the data is not saved.

In order to have persistence, set `persistence.enabled` to `true`.

**IMPORTANT:** By default, the persistent volume claims will be deleted when the Redis Failover is. If this is not the expected usage, set `persistence.keepAfterDeletion` to `true`.
