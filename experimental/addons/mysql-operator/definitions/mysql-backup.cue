"mysql-backup": {
	alias: ""
	annotations: {}
	attributes: {
		appliesToWorkloads: ["mysqlclusters.mysql.presslabs.org"]
		podDisruptive: false
		status: {
			healthPolicy: #"""
				isHealth: context.outputs."mysql-backup".status.completed
				"""#
		}
	}
	description: ""
	labels: {}
	type: "trait"
}

template: {
	outputs: {
		"mysql-backup": {
			apiVersion: "mysql.presslabs.org/v1alpha1"
			kind:       "MysqlBackup"
			metadata: {
				name:      parameter.name
				namespace: context.namespace
			}
			spec: {
				clusterName: context.name
				if parameter.backupURL != _|_ {
					backupURL: parameter.backupURL
				}
				if parameter.remoteDeletePolicy != _|_ {
					remoteDeletePolicy: parameter.remoteDeletePolicy
				}
				if parameter.backupCredentials != _|_ {
					backupSecretName: _backupSecretName
				}
			}
		}

		if parameter.backupCredentials != _|_ {
			"backupCredentials": {
				apiVersion: "v1"
				kind:       "Secret"
				metadata: {
					name:      _backupSecretName
					namespace: context.namespace
				}
				type: "Opaque"

				if parameter.backupCredentials.s3 != _|_ {
					stringData: parameter.backupCredentials.s3
				}
				if parameter.backupCredentials.googleCloud != _|_ {
					stringData: parameter.backupCredentials.googleCloud
				}
				if parameter.backupCredentials.http != _|_ {
					stringData: parameter.backupCredentials.http
				}
				if parameter.backupCredentials.googleDriver != _|_ {
					stringData: parameter.backupCredentials.googleDriver
				}
				if parameter.backupCredentials.azure != _|_ {
					stringData: parameter.backupCredentials.azure
				}
			}
		}
	}

	_backupSecretName: context.name + "-mysql-backup"

	parameter: {
		//+usage=The backup name
		name: string
		//+usage=The URL to the backup location, can be partially specifyied, if not set, used the one specified in the cluster
		backupURL?: string
		//+usage=specify how to treat the data from remote storage
		remoteDeletePolicy?: *"retain" | "delete"
		//+usage=Credentials to access the bucket, if not set, used backup schedule credentials
		backupCredentials?: {
			//+usage=Use s3 https://rclone.org/s3/
			s3?: {
				S3_PROVIDER:           *"AWS" | "Minio" | "Ceph"
				S3_ENDPOINT:           string
				AWS_ACCESS_KEY_ID:     string
				AWS_SECRET_ACCESS_KEY: string
				AWS_REGION?:           string
				AWS_ACL?:              string
				AWS_STORAGE_CLASS?:    string
				AWS_SESSION_TOKEN?:    string
			}
			//+usage=Use google cloud storage https://rclone.org/googlecloudstorage/
			googleCloud?: {
				GCS_SERVICE_ACCOUNT_JSON_KEY: string
				GCS_PROJECT_ID?:              string
				GCS_OBJECT_ACL?:              string
				GCS_BUCKET_ACL?:              string
				GCS_LOCATION?:                string
				GCS_STORAGE_CLASS?:           string
			}
			//+usage=Use http https://rclone.org/http/
			http?: {
				HTTP_URL: string
			}
			//+usage=Use google drive https://rclone.org/drive/
			googleDriver?: {
				GDRIVE_CLIENT_ID:       string
				GDRIVE_ROOT_FOLDER_ID?: string
				GDRIVE_IMPERSONATOR?:   string
			}
			//+usage=Use azure https://rclone.org/azureblob/
			azure?: {
				AZUREBLOB_ACCOUNT: string
				AZUREBLOB_KEY:     string
			}
		}
	}
}
