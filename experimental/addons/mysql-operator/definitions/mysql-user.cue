"mysql-user": {
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
		"mysql-user": {
			apiVersion: "mysql.presslabs.org/v1alpha1"
			kind:       "MysqlUser"
			metadata: {
				name:      parameter.name
				namespace: context.namespace
			}
			spec: {
				clusterRef: {
					name:      context.name
					namespace: context.namespace
				}
				user: parameter.name
				password: {
					name: _userPasswordSecretName
					key:  "PASSWORD"
				}
				allowedHosts: parameter.allowedHosts
				if parameter.permissions != _|_ {
					permissions: parameter.permissions
				}
			}
		}

		"userPassword": {
			apiVersion: "v1"
			kind:       "Secret"
			metadata: {
				name:      _userPasswordSecretName
				namespace: context.namespace
			}
			type: "Opaque"
			stringData: {
				PASSWORD: parameter.password
			}
		}
	}

	_userPasswordSecretName: context.name + "-mysql-" + parameter.name + "-password"

	parameter: {
		//+usage=The name of the user that will be created, this field should be immutable
		name: string
		//+usage=The password for the user
		password: string
		//+usage=Allowed host to connect from
		allowedHosts: [...string]
		//+usage: The list of roles that user has in the specified database
		permissions?: [...{
			//+usage=The schema to which the permission applies
			schema: string
			//+usage=The tables inside the schema to which the permission applies
			tables: [...string]
			//+usage=The permissions granted on the schema/tables
			permissions: [...string]
		}]
	}
}
