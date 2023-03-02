"spark-workload": {
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
		// +usage=Specify the policy on if and in which conditions the controller should restart an application
		restartPolicy?: {
			// +usage=Type value option: "Always", "Never", "OnFailure"
			type: string
			// +usage=Specify the number of times to retry submitting an application before giving up. This is best effort and actual retry attempts can be >= the value specified due to caching. These are required if RestartPolicy is OnFailure
			onSubmissionFailureRetries?: int
			// +usage=Specify the number of times to retry running an application before giving up
			onFailureRetries?: int
			// +usage=Specify the interval in seconds between retries on failed submissions
			onSubmissionFailureRetryInterval?: int
			// +usage=Specify the interval in seconds between retries on failed runs
			onFailureRetryInterval?: int
		}
		// +usage=Specify the driver sepc request for the driver pod
		driver: {
			// +usage=Specify the cores maps to spark.driver.cores or spark.executor.cores for the driver and executors, respectively
			cores?: int
			// +usage=Specify a hard limit on CPU cores for the pod
			coreLimit?: string
			// +usage=Specify the amount of memory to request for the pod
			memory?: string
			// +usage=Specify the Kubernetes labels to be added to the pod
			labels?: [string]: string
			// +usage=Specify the volumes listed in “.spec.volumes” to mount into the main container’s filesystem
			volumeMounts?: [...{
				name:      string
				mountPath: string
			}]
		}
		// +usage=Specify the executor spec request for the executor pod
		executor: {
			// +usage=Specify the cores maps to spark.driver.cores or spark.executor.cores for the driver and executors, respectively
			cores?: int
			// +usage=Specify a hard limit on CPU cores for the pod
			coreLimit?: string
			// +usage=Specify the amount of memory to request for the pod
			memory?:    string
			instances?: int
			// +usage=Specify the Kubernetes labels to be added to the pod
			labels?: [string]: string
			// +usage=Specify the volumes listed in “.spec.volumes” to mount into the main container’s filesystem
			volumeMounts?: [...{
				name:      string
				mountPath: string
			}]
		}
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
		// +usage=Specify the list of Kubernetes volumes that can be mounted by the driver and/or executors
		volumes?: [...{
			name: string
			hostPath: {
				path: string
				type: *"Directory" | string
			}
		}]
		// +usage=Specify the dependencies captures all possible types of dependencies of a Spark application
		deps?: {
			// +usage=Specify a list of JAR files the Spark application depends on
			jars?: [...string]
			// +usage=Specify a list of files the Spark application depends on
			files?: [...string]
			// +usage=Specify a list of Python files the Spark application depends on
			pyFiles?: [...string]
			// +usage=Specify a list of maven coordinates of jars to include on the driver and executor classpaths. This will search the local maven repo, then maven central and any additional remote repositories given by the “repositories” option. Each package should be of the form “groupId:artifactId:version”
			packages?: [...string]
			// +usage=Specify a list of “groupId:artifactId”, to exclude while resolving the dependencies provided in Packages to avoid dependency conflicts
			excludePackages?: [...string]
			// +usage=Specify a list of additional remote repositories to search for the maven coordinate given with the “packages” option
			repositories?: [...string]
		}
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
				driver:              parameter.driver
				executor:            parameter.executor
				if parameter.volumes != _|_ {
					volumes: parameter.volumes
				}

			}
		}
	}
}
