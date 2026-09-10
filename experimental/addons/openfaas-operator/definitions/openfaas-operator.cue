"openfaas-operator": {
    alias: ""
    annotations: {}
    attributes: workload: type: "autodetects.core.oam.dev"
    description: "openfaas operator component"
    labels: {}
    type: "component"
}

template: {
    output: {
        apiVersion: "openfaas.com/v1"
        kind:       "Openfaas"
        metadata: {
        	name:      context.name//"nodeinfo"
        	namespace: context.namespace//"openfaas-fn"
        }
        spec: {
            environment:	parameter.env
            handler: 		parameter.handler//"node main.js"
            image:   		parameter.image//"functions/nodeinfo:latest"
            labels: 		parameter.labels
            limits: 		parameter.limits
            name: 		    parameter.name//"nodeinfo"
            requests: 		parameter.requests
        }
    }
    parameter: {
        //+usage=The environment of debugging write rule.
        env: write_debug: *"true" | string
        //+usage=The nhandler of Openfaas nodes
        handler: *"node main.js" | string
        //+usage=The Openfaas image reference.
        image: *"functions/nodeinfo:latest" | string
        //+usage=configure respurces.
        labels: {
            //+usage=The capacity of the persistent volume, expressed as a Kubernetes resource quantity. Set to `0` to deactivate persistence altogether (this may be convenient in CI/CD and test deloyments that should always start fresh).
            "com.openfaas.scale.max": *"15" | string
            //+usage=The name of the Kubernetes StorageClass that will be used to request Persistent Volumes.
            "com.openfaas.scale.min": *"2" | string
        }
        //+usage=configure resources.
        limits: {
            //+usage=The CPU units used to calculate the share of CPU time available to the Openfaas container per 100 ms.
            cpu: *"2000m" | string
            //+usage=The memory limit allowed to be used by Openfaas container. The container won't be allowed to use more than this limit.
            memory: *"256Mi" | string
        }
        requests: {
            //+usage=The CPU units required by the Kubernetes scheduler for the container running Openfaas.
            cpu: *"10m" | string
            //+usage=The memory units required by the Kubernetes scheduler for the container running Openfaas.
            memory: *"128Mi" | string
        }
        name : *"" | string
    }
}

