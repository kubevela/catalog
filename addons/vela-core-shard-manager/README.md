# vela-core-shard-manager

The vela-core-shard-manager is a manager for slave application controllers when sharding is enabled.

## install

```shell
vela addon enable vela-core-shard-manager nShards=3
```

or

```shell
vela addon enable vela-core-shard-manager shardNames=shard-a,shard-b,shard-c
```

## Why using addon for sharding

There are various ways to enable multiple shards in KubeVela. For example, you can copy the configuration of the core controller, modify the name/shard-id and re-deploy it.

With `vela-core-shard-manager`, it is easy to duplicate the configuration of the master vela-core. This addon application will refer to the master vela-core deployment and make copies for that based on the given `nShards` or `shardNames` parameter. In this way, your duplicated slave KubeVela controller will use the same configuration as the master one, except sharding related args (like shard-id). If your master vela-core controller has upgraded its image or parameter, you can force rerun the `vela-core-shard-manager` and the updates will be automatically synced to slave controllers.