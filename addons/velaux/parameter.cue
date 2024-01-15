parameter: {
	// +usage=Specify the image hub of velaux
	repo?: string
	// +usage=Specify the database type, current support KubeAPI(default), MongoDB, MySQL, Postgres.
	dbType: *"kubeapi" | "mongodb" | "mysql" | "postgres"
	// +usage=Specify the database name, for the kubeapi db type, it represents namespace.
	database?: string
	// +usage=Specify the Database connection URL. it is not used when dbType is "kubeapi", Format reference: https://kubevela.io/docs/reference/addons/velaux/
	dbURL?: string
	// +usage=Specify the domain, if set, ingress will be created if the gateway driver is nginx.
	domain?: string
	// +usage=Specify the name of the certificate cecret, if set, means enable the HTTPs.
	secretName?: string
	// +usage=Specify the gateway type.
	gatewayDriver: *"nginx" | "traefik" | _
	// +usage=Specify the serviceAccountName for apiserver
	serviceAccountName: *"kubevela-ux" | string
	// +usage=Specify the service type.
	serviceType: *"ClusterIP" | "NodePort" | "LoadBalancer"
	// +usage=Specify the names of imagePullSecret for private image registry, eg. "{a,b,c}"
	imagePullSecrets?: [...string]
	// +usage=Specify the replicas.
	replicas: *1 | int
	// +usage=Specify nodeport. This will be ignored if serviceType is not NodePort.
	nodePort: *30000 | int
	// +usage=Enable impersonation means impersonating the login user to request the KubeAPI.
	enableImpersonation: true | *false
}
