"mysql-cluster": {
	annotations: {}
	attributes: {
		workload: definition: {
			apiVersion: "mysql.presslabs.org/v1alpha1"
			kind:       "MysqlCluster"
		}
		status: {
			healthPolicy: #"""
				isHealth: (context.output.status.readyNodes > 0) && (context.output.status.readyNodes == parameter.replicas)
				"""#
		}
	}
	description: ""
	labels: {}
	type: "component"
}

template: {
	output: {
		apiVersion: "mysql.presslabs.org/v1alpha1"
		kind:       "MysqlCluster"
		metadata: {
			name:      context.name
			namespace: context.namespace
		}
		spec: {
			replicas:   parameter.replicas
			secretName: _secretName

			if parameter.image != _|_ {
				image: parameter.image
			}

			if parameter.mysqlVersion != _|_ {
				mysqlVersion: parameter.mysqlVersion
			}

			if parameter.mysqlConf != _|_ {
				mysqlConf: parameter.mysqlConf
			}
			if parameter.initFileExtraSQL != _|_ {
				initFileExtraSQL: parameter.initFileExtraSQL
			}
			if parameter.queryLimits != _|_ {
				queryLimits: parameter.queryLimits
			}
			podSpec: {
				if parameter.imagePullSecrets != _|_ {
					imagePullSecrets: parameter.imagePullSecrets
				}
				if parameter.imagePullPolicy != _|_ {
					imagePullPolicy: parameter.imagePullPolicy
				}
				if parameter.cpu != _|_ {
					resources: {
						limits: cpu:   parameter.cpu
						requests: cpu: parameter.cpu
					}
				}
				if parameter.memory != _|_ {
					resources: {
						limits: memory:   parameter.memory
						requests: memory: parameter.memory
					}
				}
			}
		}
	}

	outputs: {
		mysqlSecret: {
			apiVersion: "v1"
			kind:       "Secret"
			metadata: {
				name:      _secretName
				namespace: context.namespace
			}
			type: "Opaque"
			stringData: {
				ROOT_PASSWORD: parameter.rootpassword
			}
			if parameter.database != _|_ {
				stringData: DATABASE: parameter.database
			}
			if parameter.user != _|_ {
				stringData: USER: parameter.user
			}
			if parameter.password != _|_ {
				stringData: PASSWORD: parameter.password
			}
		}
	}

	_secretName: context.name + "-mysql"

	parameter: {
		// +usage=The cluster replicas, how many nodes to deploy
		replicas: *1 | int
		// +usage=root password
		rootpassword: string
		// +usage=The database name which will be created
		database?: string
		// +usage=The name of the user that will be created
		user?: string
		// +usage=The password for the user
		password?: string
		// +usage=Specify mysql version
		mysqlVersion?: string
		// +usage=Set custom docker image or specifying mysql version, has priority over mysqlVersion
		image?: string
		// +usage=Policy for if/when to pull a container image
		imagePullSecrets?: [...string]
		// +usage=Policy for if/when to pull a container image
		imagePullPolicy?: "Always" | "Never" | "IfNotPresent"
		// +usage=Number of CPU units for
		cpu?: string
		// +usage=Specifies the attributes of the memory resource required for the container
		memory?: string
		// +usage=Configs that will be added to my.cnf for cluster
		mysqlConf?: [string]: string
		// +usage=InitFileExtraSQL is a list of extra sql commands to append to init_file
		initFileExtraSQL?: [...string]
		// +usage=For enabling and configuring pt-kill
		queryLimits?: {
			// +usage=Match queries that have been running for longer then this time, in seconds (--busy-time flag)
			maxQueryTime: string
			// +usage=Match queries that have been idle for longer then this time, in seconds (--idle-time flag)
			maxIdleTime?: string
			// +usage=The mode of which the matching queries in each class will be killed (the --victims flag)
			kill?: "oldest" | "all" | "all-but-oldest"
			// +usage=A query is matched the connection is killed (using --kill flag) or the query is killed (using --kill-query flag)
			killMode?: "query" | "connection"
			// +usage=The list of commands to be ignored
			ignoreCommand?: [...string]
			// +usage=the list of database that are ignored by pt-kill (--ignore-db flag)
			ignoreDb?: [...string]
			// +usage=The list of users to be ignored
			ignoreUser?: [...string]
		}
	}
}
