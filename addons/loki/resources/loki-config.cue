package main

lokiConfig: {
	name: "loki-config"
	type: "k8s-objects"
	properties: objects: [{
		apiVersion: "v1"
		kind:       "ConfigMap"
		metadata: name: "loki"
		data: {
			"loki.yaml": #"""
				auth_enabled: false
				chunk_store_config:
				  max_look_back_period: 0s
				compactor:
				  shared_store: filesystem
				  working_directory: /data/loki/boltdb-shipper-compactor
				ingester:
				  chunk_block_size: 262144
				  chunk_idle_period: 3m
				  chunk_retain_period: 1m
				  lifecycler:
				    ring:
				      replication_factor: 1
				  max_transfer_retries: 0
				  wal:
				    dir: /data/loki/wal
				limits_config:
				  enforce_metric_name: false
				  max_entries_limit_per_query: 5000
				  reject_old_samples: true
				  reject_old_samples_max_age: 168h
				memberlist:
				  join_members:
				  - 'loki'
				schema_config:
				  configs:
				  - from: "2020-10-24"
				    index:
				      period: 24h
				      prefix: index_
				    object_store: filesystem
				    schema: v11
				    store: boltdb-shipper
				server:
				  grpc_listen_port: 9095
				  http_listen_port: 3100
				storage_config:
				  boltdb_shipper:
				    active_index_directory: /data/loki/boltdb-shipper-active
				    cache_location: /data/loki/boltdb-shipper-cache
				    cache_ttl: 24h
				    shared_store: filesystem
				  filesystem:
				    directory: /data/loki/chunks
				table_manager:
				  retention_deletes_enabled: false
				  retention_period: 0s
				frontend:
				  max_outstanding_per_tenant: 4096
				query_range:
				  parallelise_shardable_queries: false
				"""#
		}
	}]
}
