parameter: {
	// +usage=Specify image to use for deploying
	"image.repository": *"pyroscope/pyroscope" | string
	// +usage=Specify tag for pyroscope image to use
	"image.tag": *"0.17.1" | string
	// +usage=Specify image pull policy
	"image.pullPolicy": *"IfNotPresent" | string
	// +usage=Specify image pull secrets
	"imagePullSecrets": *[] | [...string]

	// +usage=Specify enables Ingress
	"ingress.enabled": *false | bool
	// +usage=Specify ingress accepted hostnames
	"ingress.hosts": #host
	// +usage=Specify ingress custom rules. Take precedence over chart built-ins.
	"ingress.rules": *[] | [...string]
	// +usage=Specify ingress TLS configuration
	"ingress.tls": *[] | [...string]

	// +usage=Specify persistence access modes
	"persistence.accessModes": *"ReadWriteOnce" | string
	// +usage=Specify use persistent volume to store data
	"persistence.enabled": *false | bool
	// +usage=Specify persistentVolumeClaim finalizers
	"persistence.finalizers": *["kubernetes.io/pvc-protection"] | [...string]
	// +usage=Specify size of persistent volume claim
	"persistence.size": *"10Gi" | string

	// +usage=Specify pyroscope server configuration. Please refer to https://pyroscope.io/docs/server-configuration
	"pyroscopeConfigs": *{} | #map

	// +usage=Specify extra rules for created cluster role
	"rbac.clusterRole.extraRules": *[] | [...string]
	// +usage=Specify cluster role name. If not set, the fully qualified app name is used
	"rbac.clusterRole.name": *"" | string
	// +usage=Specify cluster role binding name. If not set, the fully qualified app name is used
	"rbac.clusterRoleBinding.name": *"" | string
	// +usage=Specify creates Pyroscope cluster role and binds service account to it; requires service account to be created
	"rbac.create": *false | bool

	// +usage=Specify kubernetes port where service is exposed
	"service.port": *4040 | int
	// +usage=Specify service type
	"serviceType": *"ClusterIP" | string
	// +usage=Specify create service account
	"serviceAccount.create": *true | bool
	// +usage=Specify service account name to use, when empty will be set to created account if serviceAccount.create is set else to default
	"serviceAccount.name": *"" | string
}

#host: [...{
	"host":  *"chart-example.local" | string
	"paths": #paths
}]

#paths: [...{
	"path":     *"/" | string
	"pathType": *"Prefix" | string
}]

#map: [string]: string
