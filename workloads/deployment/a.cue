envValueFrom: {
	env:
	[ for c in parameter.configRef {
		[ for k in c.keys {
			name: k
			valueFrom: {
				secretKeyRef: {
					name: c.name
					key:  k
				}
			}
		},
		]
	}]

}

parameter: {
	configRef: [
		{name: "rds-config", keys: ["db_name", "db_host"]},
		{name: "oss-config", keys: ["bucket_name"]},
	]
}
