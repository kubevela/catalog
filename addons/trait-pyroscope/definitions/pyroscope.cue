pyroscope: {
	annotations: {}
	attributes: {
         appliesToWorkloads: ["webservice","worker","cloneset"]
		conflictsWith: []
		podDisruptive:   false
		workloadRefPath: ""
	}
	description: ""
	labels: {}
	type: "trait"
}

template: {
	outputs: 
	   "pyroscope-deployment":{
		metadata: {
			name: "pyroscope-"+context.name
			labels: {
				"app.kubernetes.io/instance": "pyroscope-"+context.name
				"app.kubernetes.io/name":     "pyroscope-"+context.name
				"app.kubernetes.io/version":  "0.17.1"
			}
			namespace: context.namespace
		}
		spec: {
			progressDeadlineSeconds: 600
			replicas:                1
			revisionHistoryLimit:    10
			selector: matchLabels: {
				"app.kubernetes.io/instance": "pyroscope-"+context.name
				"app.kubernetes.io/name":     "pyroscope-"+context.name
			}
			strategy: type: "Recreate"
			template: {
				metadata: {
					labels: {
						"app.kubernetes.io/instance": "pyroscope-"+context.name
						"app.kubernetes.io/name":     "pyroscope-"+context.name
					}
					creationTimestamp: null
				}
				spec: {
					securityContext: fsGroup: 101
					containers: [{
						name: "pyroscope-"+context.name
						args: ["server", "-config", "/tmp/config.yaml"]
						image:           "pyroscope/pyroscope:0.17.1"
						imagePullPolicy: "IfNotPresent"
						livenessProbe: {
							failureThreshold: 3
							httpGet: {
								path:   "/healthz"
								port:   4040
								scheme: "HTTP"
							}
							initialDelaySeconds: 30
							periodSeconds:       15
							successThreshold:    1
							timeoutSeconds:      30
						}
						ports: [{
							name:          "api"
							containerPort: 4040
							protocol:      "TCP"
						}]
						readinessProbe: {
							failureThreshold: 3
							httpGet: {
								path:   "/healthz"
								port:   4040
								scheme: "HTTP"
							}
							initialDelaySeconds: 30
							periodSeconds:       5
							successThreshold:    1
							timeoutSeconds:      30
						}
						resources: {}
						securityContext: {}
						terminationMessagePath:   "/dev/termination-log"
						terminationMessagePolicy: "File"
						volumeMounts: [{
							name:      "config"
							mountPath: "/tmp/config.yaml"
							subPath:   "config.yaml"
						}]
					}]
					dnsPolicy:                     "ClusterFirst"
					restartPolicy:                 "Always"
					schedulerName:                 "default-scheduler"
					serviceAccount:                "pyroscope-"+context.name
					serviceAccountName:            "pyroscope-"+context.name
					terminationGracePeriodSeconds: 30
					volumes: [{
						name: "config"
						configMap: {
							name:        "pyroscope-"+context.name
							defaultMode: 420
						}
					}]
				}
			}
		}
		apiVersion: "apps/v1"
		kind:       "Deployment"
	}
	outputs: 
	"pyroscope-cm":{
		apiVersion: "v1"
		data: "config.yaml": """
        {}
        
        """
		kind: "ConfigMap"
		metadata: {
			name: "pyroscope-"+context.name
			labels: {
				"app.kubernetes.io/instance": "pyroscope-"+context.name
				"app.kubernetes.io/name":     "pyroscope-"+context.name
			}
			namespace: context.namespace
		}
	}
	outputs:
		"pyroscope-svc":{
    		apiVersion: "v1"
    		kind:       "Service"
    		metadata: {
    			name: "pyroscope-"+context.name
    			labels: {
    				"app.kubernetes.io/instance": "pyroscope-"+context.name
    				"app.kubernetes.io/name":     "pyroscope-"+context.name
    			}
    			namespace: context.namespace
    		}
    		spec: {
    			ports: [{
    				name:       "http"
    				port:       4040
    				protocol:   "TCP"
    				targetPort: "api"
    			}]
    			selector: {
    				"app.kubernetes.io/instance": "pyroscope-"+context.name
    				"app.kubernetes.io/name":     "pyroscope-"+context.name
    			}
    			sessionAffinity: "None"
    			type:            "ClusterIP"
    		}
    	}
    	
    	outputs:
    	"pyroscope-sa": {
        		apiVersion: "v1"
        		kind:       "ServiceAccount"
        		metadata: {
        			name: "pyroscope-"+context.name
        			labels: {
        				"app.kubernetes.io/instance": "pyroscope-"+context.name
        				"app.kubernetes.io/name":     "pyroscope-"+context.name
        			}
        			namespace: context.namespace
        		}
        	}	
		parameter: {}
}
