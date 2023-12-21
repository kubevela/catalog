import "strings"

"datadog": {
    type: "trait"
    annotations: {}
    labels: {}
    description: "Add required env vars, annotations and host volume mount for datadog instrumentation"
    attributes: {
        appliesToWorkloads: ["deployments.apps","cronjobs.batch]
        podDisruptive: true
    }
}

template: {
    let envVars=[
	{ 
            name: "DD_SERVICE"
            value: parameter.serviceName
        },
	{ 
            name: "DD_ENV"
            value: parameter.env
        },
	{ 
            name: "DD_VERSION"
            value: parameter.version
        },
    ]

    let volumeMount={
        name: datadog
        mountPath: path: parameter.mountPath
    }

    let volume = {
        name: datadog
        hostPath: path: parameter.hostMountPath
    }

    let patchContent= {
        spec: {
            containers: [
                // +patchKey=name
                env: envVars
                // +patchKey=name
                volumeMounts: [volumeMount]
            ]
            // +patchKey=name
            volumes: [volume]
        }
        if parameter.source != _|_ {
            metadata: annotations: [{
                "ad.datadoghq.com/"+parameter.serviceName+".logs": "[{\"source\": \""+parameter.source+"\"}]"
            }]
        }
    }
    
    patch: spec: {
        if context.output.spec.template != _|_ {
            template: patchContent
        }
        if context.output.spec.jobTemplate != _|_ {
            if parameter.source != _|_ {
                metadata: annotations: [{
                    "ad.datadoghq.com/"+parameter.serviceName+".logs": "[{\"source\": \""+parameter.source+"\"}]"
                }]
            }
            jobTemplate: {
                spec: template: patchContent
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

      // +usage=source for logging (add as an annotation  ad.datadoghq.com/<serviceName>.logs: [{"source":"<this value>"}]
      source?: string
    }

}
