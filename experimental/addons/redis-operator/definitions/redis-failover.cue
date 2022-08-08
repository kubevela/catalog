"redis-failover": {
	alias: "rf"
	annotations: {}
	attributes: {
		workload: type: "autodetects.core.oam.dev"
		// Currently, health checks are not achievable, because RedisFailover itself
		// don't hava any fields to determine it is healthy or not (no status or anything similar). 
		//
		// The only way I can think of is to inspect the status of Redis ReplicaSets. But
		// that is not possible without VelaQL.
		//
		// TODO(charlie0129): add status checks once RedisFailover have `status` field
		//     or we can use VelaQL in healthPolicy.
		//
		// status: {}
	}
	description: "RedisFailover represents a Redis failover"
	labels: {}
	type: "component"
}

template: {
	output: {
		apiVersion: "databases.spotahome.com/v1"
		kind:       "RedisFailover"
		metadata: name: context.name
		spec: {
			redis: {
				replicas: parameter.replicas
				if parameter.persistence.enabled {
					storage: {
						keepAfterDeletion: parameter.persistence.keepAfterDeletion
						persistentVolumeClaim: {
							metadata: name: "redisfailover-persistent-" + context.name
							spec: {
								accessModes: ["ReadWriteOnce"]
								if parameter.persistence.size != _|_ {
									resources: requests: storage: parameter.persistence.size
								}
							}
						}
					}
				}
			}
			sentinel: {
				replicas: parameter.replicas
			}
			if parameter.authSecret != _|_ {
				auth: secretPath: parameter.authSecret
			}
		}
	}
	outputs: {}
	parameter: {
		//+usage=Number of replicas for redis and sentinel instances.
		replicas: *3 | int
		//+usage=Persistence-related settings.
		persistence: {
			//+usage=Persist to pvc. Note that data will still be deleted once redis-failover is deleted.
			enabled: *false | bool
			//+usage=pvc size.
			size?: =~"^([1-9][0-9]{0,63})(E|P|T|G|M|K|Ei|Pi|Ti|Gi|Mi|Ki)$"
			//+usage=Keep pvc even if redis-failover is deleted.
			keepAfterDeletion: *false | bool
		}
		//+usage=Secret name that holds redis password. You need to create a secret with a password field first.
		authSecret?: string
	}
}
