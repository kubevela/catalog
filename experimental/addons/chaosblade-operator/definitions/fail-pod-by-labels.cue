"fail-pod-by-labels": {
        alias: ""
        annotations: {}
        attributes: {
                appliesToWorkloads: []
                conflictsWith: []
                definitionRef:   ""
                podDisruptive:   false
                workloadRefPath: ""
        }
        description: "inject fail image to  select pod"
        labels: {}
        type: "trait"
}

template: {
       outputs:"fail-pod-by-labels":{
                apiVersion: "chaosblade.io/v1alpha1"
                kind:       "ChaosBlade"
                metadata: name: parameter.bladeName
                spec: experiments: [{
                        action: "fail"
                        desc:   "inject fail image to  select pod"
                        matchers: [{
                                name: "labels"
                                value: parameter.labels //key=value
                        }, {
                                name: "namespace"
                                value: parameter.nsName
                        }]
                        scope:  "pod"
                        target: "pod"
                }]
        }
        parameter: {
            // +usage=Specify the name for ChaosBlade
            bladeName:string
            // +usage=Specify the labels
            labels:[...string]
            // +usage=Specify the ns names
            nsName:[...string]
        }
}
