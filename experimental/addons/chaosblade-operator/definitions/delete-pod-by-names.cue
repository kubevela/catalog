"delete-pod-by-names": {
        alias: ""
        annotations: {}
        attributes: {
                appliesToWorkloads:["webservice","worker","cloneset"]
                conflictsWith:[]
                podDisruptive:false
                workloadRefPath:""
        }
        description:"delete pod by names"
        labels: {}
        type: "trait"
}

template: {
        outputs:"delete-pod-by-names":{
                apiVersion: "chaosblade.io/v1alpha1"
                kind:       "ChaosBlade"
                metadata: name:parameter.bladeName
                spec: experiments: [{
                        action: "delete"
                        desc:   "delete pod by names"
                        matchers: [{
                                name: "names"
                                value:parameter.podName
                        }, {
                                name: "namespace"
                                value:parameter.nsName
                        }]
                        scope:  "pod"
                        target: "pod"
                }]
        }

        parameter: {
            // +usage=Specify the name for ChaosBlade
            bladeName:string
            // +usage=Specify the pod names
            podName:[...string]
            // +usage=Specify the ns names
            nsName:[...string]
        }
}

