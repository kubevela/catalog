vegeta: {
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
        outputs:"vegeta":{
                metadata: {
                        name:      context.name
                        namespace: context.namespace
                }
                spec: {
                        backoffLimit: parameter.backofflimit
                        completions:  parameter.parallelism
                        parallelism:  parameter.parallelism
                        template: {
                                metadata: name: context.name
                                spec: {
                                        containers: [{
                                                name: context.name
                                                args: ["echo '" + parameter.dorequest + "'"+ "|"+parameter.vegetacli]
                                                command: ["/bin/sh", "-c"]
                                                image: parameter.image
                                        }]
                                        restartPolicy: parameter.restartPolicy
                                }
                        }
                }
                apiVersion: "batch/v1"
                kind:       "Job"
        }
        parameter: {
            backofflimit: *0|int
            parallelism:  *1|int
            image:*"quay.io/karansingh/vegeta-ubi"|string
            restartPolicy: *"OnFailure"|string
            dorequest: string
            vegetacli: *"vegeta attack -rate 5000 -duration 10000m | vegeta encode"|string
       }
}
