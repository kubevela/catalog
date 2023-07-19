"mysql-database": {
	alias: ""
	annotations: {}
	attributes: {
		appliesToWorkloads: ["mysqlclusters.mysql.presslabs.org"]
		podDisruptive: false
	}
	description: ""
	labels: {}
	type: "trait"
}

template: {
	outputs: {
		"mysql-database": {
			apiVersion: "mysql.presslabs.org/v1alpha1"
			kind:       "MysqlDatabase"
			metadata: {
				name:      parameter.name
				namespace: context.namespace
			}
			spec: {
				clusterRef: {
					name:      context.name
					namespace: context.namespace
				}
				database: parameter.name
			}
		}
	}

	_backupSecretName: context.name + "-mysql-backup"

	parameter: {
		//+usage=The database name which will be created
		name: string
		//+usage=Charset name used when database is created
		characterSet?: string
		//+usage=Collation name used as default database collation
		collation?: string
	}
}
