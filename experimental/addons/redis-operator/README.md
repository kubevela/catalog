# redis-operator

Redis Operator creates/configures/manages high availability redis with sentinel automatic failover atop Kubernetes.

This addon will give you the ability to use `redis-failover` Components in Applications.

## Quick Start

In this example, we will :
- start a high-availability Redis cluster with Sentinel
- scale it up/down
- use `redis-cli` to connect and read/write some data

Let's get started.

After you enable this addon, apply this yaml:

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
$ kubectl get pods -l 'app.oam.dev/name=redis-operator-sample'
NAME                            READY   STATUS    RESTARTS   AGE
rfr-ha-redis-0                  1/1     Running   0          2m7s
rfr-ha-redis-1                  1/1     Running   0          2m7s
rfs-ha-redis-5c49b8947d-lcqhx   1/1     Running   0          2m7s
rfs-ha-redis-5c49b8947d-vn6gs   1/1     Running   0          2m7s
```

As we can see, 2 instances are available. `rfr` refers to RedisFailoverRedis. `rfs` refers to RedisFailoverSentinel.

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
$ kubectl get pods -l 'app.oam.dev/name=redis-operator-sample'
NAME                            READY   STATUS    RESTARTS   AGE
rfr-ha-redis-0                  1/1     Running   0          68s
rfs-ha-redis-7fd59f4758-g6dng   1/1     Running   0          80s
```

Now, we will try to connect to the Redis cluster (specifically, connect to Sentinel service). To use `redis-cli`, we will attach a terminal to the `redis-cli` Pod so that we hava a `redis-cli` available.

```shell
# Launch a pod with redis-cli in it.
kubectl run redis-cli --rm --restart=Never \
  --image=goodsmileduck/redis-cli -it \
  --command -- /bin/sh
```

Your terminal should be attached to the Pod. Inside that terminal, type:

```shell
# Connect to Sentinel
# rfs-ha-redis is the Service name of Sentinel. 
# Remember our Component name (ha-redis)? It is rfs-<component-name>. 
# And the port is 26379
redis-cli -h rfs-ha-redis.default.svc -p 26379

# You should have redis-cli connected to Sentinel now.
# Now, find where the master is. `mymaster` is hard-coded by the operator
SENTINEL get-master-addr-by-name mymaster
# For example, you have results: 1) "172.17.0.6" 2) "6379"

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