output: {
	{
		module: {
			rds: {
				source:           "terraform-alicloud-modules/rds/alicloud"
				engine:           parameter.engine
				engine_version:   parameter.engine_version
				instance_type:    parameter.instance_type
				instance_storage: "20"
				instance_name:    parameter.name
				account_name:     parameter.user
				password:         parameter.password
			}
		}
		output: {
			db_name: {
				value: "${module.rds.this_db_instance_name}"
			}
			DB_USER: {
				value: "${module.rds.this_db_database_account}"
			}
			db_port: {
				value: "${module.rds.this_db_instance_port}"
			}
			DB_HOST: {
				value: "${module.rds.this_db_instance_connection_string}"
			}
			DB_PASSWORD: {
				value: "${module.rds.this_db_instance_port}"
			}
		}
	}
}

parameter: {
	engine:         *"MySQL" | string
	engine_version: *"8.0" | string
	instance_type:  *"rds.mysql.c1.large" | string
	name:           string
	user:           string
	password:       string
}
