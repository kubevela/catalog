import "strings"

"datadog": {
    type: "trait"
    annotations: {}
    labels: {}
    description: "Add required env vars, annotations and host volume mount for datadog instrumentation"
    attributes: {
        appliesToWorkloads: ["deployments.apps","cronjobs.batch"]
        podDisruptive: true
    }
}

template: {
    let envVars=[
	{ 
            name: "DD_SERVICE",
            value: parameter.serviceName
        },
	{ 
            name: "DD_ENV",
            value: parameter.env
        },
	{ 
            name: "DD_VERSION",
            value: parameter.version
        },

        if parameter.autoDependencyMap {
            let autoDepenencyList = [ for x in strings.Split(parameter.autoDependencies,",") { strings.TrimSpace(x) } ]
            let mappings = [ for x in autoDepenencyList { x + ":" + parameter.serviceName + "-dependency" }]

            {
                name: "DD_TRACE_SERVICE_MAPPING"
                value: strings.Join(mappings, ",")
            }
        }
    ]

    let volumeMount = {
        name: parameter.volumeName,
        mountPath: parameter.mountPath
    }

    let volume = {
        name: parameter.volumeName,
        hostPath: path: parameter.hostMountPath
    }

    let sourceAnnotation = {
        if parameter.source != _|_ {
            metadata: annotations: {
                ("ad.datadoghq.com/"+parameter.serviceName+".logs"): "[{\"source\": \""+parameter.source+"\"}]"
            }
        }
    }

    let patchContent= {
        spec: {
            containers: [{
                // +patchKey=name
                env: envVars,
                // +patchKey=name
                volumeMounts: [volumeMount]
            }]
            // +patchKey=name
            volumes: [volume]
        }
    }
    
    patch: { 
        sourceAnnotation

        spec: {
            if context.output.spec.template != _|_ {
                template: {
                    sourceAnnotation
                    patchContent
                }
            }
            if context.output.spec.jobTemplate != _|_ {
                jobTemplate: {
                    sourceAnnotation
                    spec: template: {
                        sourceAnnotation
                        patchContent
                    }
                }
            }
        }
    }

    parameter: {
      // +usage=DD service name
      serviceName:	string

      // +usage=DD environment
      env:		string

      // +usage=DD version
      version:		string

      // +usage=mount path in container (default /var/run/datadog)
      mountPath: *"/var/run/datadog" | string

      // +usage=mount path on host (default /var/run/datadog)
      hostMountPath: *"/var/run/datadog" | string

      // +usage=name of host mount volume (default datadog)
      volumeName: *"datadog" | string

      // +usage=source for logging (added as an annotation 'ad.datadoghq.com/<serviceName>.logs: [{"source":"<this value>"}]' )
      source?: string

      // +usage=auto-map standard dependencies to <serviceName>-dependency by setting DD_TRACE_SERVICE_MAPPING env var (default false)
      autoDependencyMap: *false | bool

      // +usage=comma-separated list of dependencies to be used by autoDependencyMap (default "http-client,redis,sql-server,kafka,faulthandlingdb")
      autoDependencies: *"http-client,redis,sql-server,kafka,faulthandlingdb" | string
    }

}
