package main

import "strconv"

_targetNamespace: string

chart: {
	name: "addon-velero"
	type: "helm"
	properties: {
		repoType:        "helm"
		url:             parameter.chartUrl
		chart:           "velero"
		version:         "3.1.2"
		targetNamespace: _targetNamespace
		values: {
			snapshotsEnabled: parameter.snapshotsEnabled
			credentials: {
				name: "velero-credentials"
				if parameter.aws != _|_ {
					secretContents: cloud: "[default]\naws_access_key_id=\(parameter.aws.accessKeyId)\naws_secret_access_key=\(parameter.aws.secretAccessKey)"
				}
			}
			initContainers: [
				if parameter.aws != _|_ {
					name:            "velero-plugin-for-aws"
					image:           "velero/velero-plugin-for-aws:v1.6.1"
					imagePullPolicy: "IfNotPresent"
					volumeMounts: [{
						mountPath: "/target"
						name:      "plugins"
					}]
				},
			]
			configuration: {
				if parameter.aws != _|_ {
					provider: "aws"
				}
				backupStorageLocation: {
					if parameter.aws != _|_ {
						bucket: parameter.aws.bucket
						if parameter.aws.prefix != _|_ {
							prefix: parameter.aws.prefix
						}
						config: {
							if parameter.aws.region != _|_ {
								region: parameter.aws.region
							}
							if parameter.aws.s3ForcePathStyle != _|_ {
								s3ForcePathStyle: strconv.FormatBool(parameter.aws.s3ForcePathStyle)
							}
							if parameter.aws.s3Url != _|_ {
								s3Url: parameter.aws.s3Url
							}
							if parameter.aws.insecureSkipTLSVerify != _|_ {
								insecureSkipTLSVerify: strconv.FormatBool(parameter.aws.insecureSkipTLSVerify)
							}
						}
					}
				}
			}
		}
	}
}
