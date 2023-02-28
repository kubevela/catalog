"spark-application": {
	annotations: {}
	attributes: workload: type: "autodetects.core.oam.dev"
	description: "Describes a containerized spark application that can specify resource spec."
	labels: {}
	type: "component"
}

template: {
	parameter: {
		// +usage=Specify the spark application name
		name: string
		// +usage=Specify the namespace for spark application to install
		namespace: string
		// +usage=Specify the application language type, e.g. "Scala", "Python", "Java" or "R"
		type: string
		// +usage=Specify the python version 
		pythonVersion?: string
		// +usage=Specify the deploy mode, e.go "cluster", "client" or "in-cluster-client"
		mode: string
		// +usage=Specify the container image for the driver, executor, and init-container
		image: string
		// +usage=Specify the image pull policy for the driver, executor, and init-container
		imagePullPolicy: string
		// +usage=Specify the fully-qualified main class of the Spark application
		mainClass: string
		// +usage=Specify the path to a bundled JAR, Python, or R file of the application
		mainApplicationFile: string
		// +usage=Specify the version of Spark the application uses
		sparkVersion: string
		// +usage=Specify the number of CPU cores to request for the driver pod
		driverCores: int
		// +usage=Specify the number of CPU cores to request for the executor pod
		executorCores: int
		// +usage=Specify a list of arguments to be passed to the application
		arguments?: [...string]
		// +usage=Specify the config information carries user-specified Spark configuration properties as they would use the  "--conf" option in spark-submit
		sparkConf?: [string]: string
		// +usage=Specify the config information carries user-specified Hadoop configuration properties as they would use the  the "--conf" option in spark-submit.  The SparkApplication controller automatically adds prefix "spark.hadoop." to Hadoop configuration properties
		hadoopConf?: [string]: string
		// +usage=Specify the name of the ConfigMap containing Spark configuration files such as log4j.properties. The controller will add environment variable SPARK_CONF_DIR to the path where the ConfigMap is mounted to
		sparkConfigMap?: string
		// +usage=Specify the name of the ConfigMap containing Hadoop configuration files such as core-site.xml. The controller will add environment variable HADOOP_CONF_DIR to the path where the ConfigMap is mounted to
		hadoopConfigMap?: string
	}

	output: {
		kind:       "ClusterRoleBinding"
		apiVersion: "rbac.authorization.k8s.io/v1"
		metadata: name: parameter.name
		roleRef: {
			name:     "edit"
			apiGroup: "rbac.authorization.k8s.io"
			kind:     "ClusterRole"
		}
		subjects: [{
			name:      "default"
			kind:      "ServiceAccount"
			namespace: parameter.namespace
		}]
	}

	outputs: {

		"spark": {
			kind:       "SparkApplication"
			apiVersion: "sparkoperator.k8s.io/v1beta2"
			metadata: {
				name:      parameter.name
				namespace: parameter.namespace
			}
			spec: {
				type:                parameter.type
				mode:                parameter.mode
				image:               parameter.image
				imagePullPolicy:     parameter.imagePullPolicy
				mainClass:           parameter.mainClass
				mainApplicationFile: parameter.mainApplicationFile
				sparkVersion:        parameter.sparkVersion
				driver: {
					cores: parameter.driverCores
				}
				executor: {
					cores: parameter.executorCores
				}
			}
		}
	}
}
