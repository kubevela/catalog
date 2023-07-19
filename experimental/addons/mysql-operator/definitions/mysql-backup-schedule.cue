"mysql-backup-schedule": {
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
		backupSecretName: _backupSecretName
		backupSchedule:   parameter.backupSchedule
		backupURL:        parameter.backupURL
		if parameter.backupScheduleJobsHistoryLimit != _|_ {
			backupScheduleJobsHistoryLimit: parameter.backupScheduleJobsHistoryLimit
		}
		if parameter.backupRemoteDeletePolicy != _|_ {
			backupRemoteDeletePolicy: parameter.backupRemoteDeletePolicy
		}
	}

	patchOutputs: {
		"mysql-secret": {
			if parameter.s3 != _|_ {
				stringData: parameter.s3
			}
			if parameter.googleCloud != _|_ {
				stringData: parameter.googleCloud
			}
			if parameter.http != _|_ {
				stringData: parameter.http
			}
			if parameter.googleDriver != _|_ {
				stringData: parameter.googleDriver
			}
			if parameter.azure != _|_ {
				stringData: parameter.azure
			}
		}
	}

	// outputs: {
	//  "backupCredentials": {
	//   apiVersion: "v1"
	//   kind:       "Secret"
	//   metadata: {
	//    name:      _backupSecretName
	//    namespace: context.namespace
	//   }
	//   type: "Opaque"

	//   if parameter.s3 != _|_ {
	//    stringData: parameter.s3
	//   }
	//   if parameter.googleCloud != _|_ {
	//    stringData: parameter.googleCloud
	//   }
	//   if parameter.http != _|_ {
	//    stringData: parameter.http
	//   }
	//   if parameter.googleDriver != _|_ {
	//    stringData: parameter.googleDriver
	//   }
	//   if parameter.azure != _|_ {
	//    stringData: parameter.azure
	//   }
	//  }
	// }

	// _backupSecretName: context.name + "-mysql-backup-schedule"
	_backupSecretName: context.outputs.mysqlSecret.metadata.name

	parameter: {
		//+usage=Represents the time and frequency of making cluster backups, in a cron format with seconds
		backupSchedule: string
		//+usage=The bucket URL where to put the backup
		backupURL: string
		//+usage=backup target storage type
		backupTarget: *"s3" | "googleCloud" | "http" | "googleDriver" | "azure"
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
		//+usage=The number of many backups to keep
		backupScheduleJobsHistoryLimit?: int
		//+usage=Specify how to treat the data from remote storage
		backupRemoteDeletePolicy?: "retain" | "delete"
		//+usage=Command to use for compressing the backup
		backupCompressCommand?: [...string]
		//+usage=Command to use for decompressing the backup
		backupDecompressCommand?: [...string]
		//+usage=Add extra arguments to rclone
		rcloneExtraArgs?: [...string]
		//+usage=Add extra arguments to xbstream
		xbstreamExtraArgs?: [...string]
		//+usage=Add extra arguments to xtrabackup
		xtrabackupExtraArgs?: [...string]
		//+usage=Add extra arguments to xtrabackup during --prepare
		xtrabackupPrepareExtraArgs?: [...string]
	}
}
