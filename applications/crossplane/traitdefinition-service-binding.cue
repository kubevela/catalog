patch: {
	spec: template: spec: {
		// +patchKey=name
		containers: [{
			name: context.name
			// +patchKey=name
			env: [
				for envName, v in parameter.envMappings {
					name: envName
					valueFrom: {
						secretKeyRef: {
							name: v.secret
							if v["key"] != _|_ {
								key: v.key
							}
							if v["key"] == _|_ {
								key: envName
							}
						}
					}
				},
			]
		}]
	}
}

parameter: {
	envMappings: [string]: [string]: string
}

//parameter: {
//	envMappings: {
//		DB_PASSWORD: {
//			secret: "db-conn"
//			key:    "password"
//		} // 1) If the env name is different from secret key, secret key has to be set.
//		endpoint: {
//			secret: "db-conn"
//		} // 2) If the env name is the same as the secret key, secret key can be omitted.
//		username: {
//			secret: "db-conn"
//		}
//
//		BUCKET_NAME: {
//			secret: "oss-conn"
//			key:    "Bucket"
//		}
//	}
//}
//
//context: {
//	name: "abc"
//}