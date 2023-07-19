"mysql-restore": {
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
	patch: spec: {
		initBucketSecretName: _restoreSecretName
		initBucketURL:        parameter.initBucketURL
	}

	outputs: {
		if parameter.restoreCredentials != _|_ {
			"restoreCredentials": {
				apiVersion: "v1"
				kind:       "Secret"
				metadata: {
					name:      _restoreSecretName
					namespace: context.namespace
				}
				type: "Opaque"

				if parameter.restoreCredentials.s3 != _|_ {
					stringData: parameter.restoreCredentials.s3
				}
				if parameter.restoreCredentials.googleCloud != _|_ {
					stringData: parameter.restoreCredentials.googleCloud
				}
				if parameter.restoreCredentials.http != _|_ {
					stringData: parameter.restoreCredentials.http
				}
				if parameter.restoreCredentials.googleDriver != _|_ {
					stringData: parameter.restoreCredentials.googleDriver
				}
				if parameter.restoreCredentials.azure != _|_ {
					stringData: parameter.restoreCredentials.azure
				}
			}
		}
	}

	_restoreSecretName: string
	if parameter.restoreCredentials == _|_ {
		_restoreSecretName: context.name + "-mysql-backup-schedule"
	}
	if parameter.restoreCredentials != _|_ {
		_restoreSecretName: context.name + "-mysql-restore"
	}

	parameter: {
		//+usage=The S3 URL that the cluster initialization backup is taken from
		initBucketURL: string
		//+usage=Credentials for the initialization are read from, if not set, use backup schedule credentials
		restoreCredentials?: {
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
