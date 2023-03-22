parameter: {
	// +usage=Specify the image hub of velaux, eg. "acr.kubevela.net"
	repo?: string
	// +usage=Specify the database type, current support KubeAPI(default) and MongoDB.
	dbType: *"kubeapi" | "mongodb"
	// +usage=Specify the database name, for the kubeapi db type, it represents namespace.
	database?: string
	// +usage=Specify the MongoDB URL. it only enabled where DB type is MongoDB.
	dbURL?: string
	// +usage=Specify the domain, if set, ingress will be created if the gateway driver is nginx.
	domain?: string
	// +usage=Specify the name of the certificate cecret, if set, means enable the HTTPs.
	secretName?: string
	// +usage=Specify the gateway type.
	gatewayDriver: "nginx" | "traefik-gateway" | "traefik-ingress"
	// +usage=Specify the serviceAccountName for apiserver
	serviceAccountName: *"kubevela-ux" | string
	// +usage=Specify the service type.
	serviceType: *"ClusterIP" | "NodePort" | "LoadBalancer"
	// +usage=Specify the names of imagePullSecret for private image registry, eg. "{a,b,c}"
	imagePullSecrets?: [...string]
	// +usage=Specify whether to enable the dex
	dex: *false | bool
	// +usage=Specify the replicas.
	replicas: *1 | int
	// +usage=Specify nodeport. This will be ignored if serviceType is not NodePort.
	nodePort: *30000 | int
	// +usage=Enable impersonation means impersonating the login user to request the KubeAPI.
	enableImpersonation: true | *false

}
