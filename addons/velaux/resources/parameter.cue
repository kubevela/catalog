parameter: {
	// +usage=Specify the version of velaux.
	version: *"v1.2.4" | string
	// +usage=Specify the image hub of velaux, eg. "acr.kubevela.net"
	repo?: string
	// +usage=Specify the database type, current support KubeAPI(default) and MongoDB.
	dbType: *"kubeapi" | "mongodb"
	// +usage=Specify the database name, for the kubeapi db type, it represents namespace.
	database?: string
	// +usage=Specify the MongoDB URL. it only enabled where DB type is MongoDB.
	dbURL?: string
	// +usage=Specify the domain, if set, Ingress will be created
	domain?: string
	// +usage=Specify the serviceAccountName for apiserver
	serviceAccountName: *"kubevela-vela-core" | string
	// +usage=Specify the service type.
	serviceType: *"ClusterIP" | "NodePort" | "LoadBalancer" | "ExternalName"
	// +usage=Specify the names of imagePullSecret for private image registry, eg. "{a,b,c}"
	imagePullSecrets?: [...string]
}
