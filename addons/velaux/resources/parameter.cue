package resources

parameter: {
	// +usage=Specify the version of velaux.
	version: "1.2.0"
	// +usage=Specify the image hub of velaux.
	repo: "acr.kubevela.net/"
	// +usage=Specify the database type, current support KubeAPI(default) and MongoDB.
	dbType: "kubeapi" | "mongodb"
	// +usage=Specify the database name, for the kubeapi db type, it represents namespace.
	database?: string
	// +usage=Specify the MongoDB URL. it only enabled where DB type is MongoDB.
	dbURL?: string
	// +usage=Specify the domain, if set, Ingress will be created
	domain?: string
}
