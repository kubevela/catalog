"volcano-job": {
        alias: ""
        annotations: {}
        attributes: workload: type: "autodetects.core.oam.dev"
        description: "volcano job component"
        labels: {}
        type: "component"
}

template: {
        output: {
                kind:       "Job"
                apiVersion: "batch.volcano.sh/v1alpha1"
                metadata: {
                        name:      context.name
                }
                spec: {
                    schedulerName:          parameter.schedulerName
                    minAvailable:           parameter.minAvailable
                    volumes:                parameter.volumes
                    tasks:                  parameter.tasks
                    policies:               parameter.policies
                    plugins:                parameter.plugins
                    queue:                  parameter.queue
                    maxRetry:               parameter.maxRetry
                    priorityClassName:      parameter.priorityClassName
                }
        }
        parameter: {
                //+usage=schedulerName indicates the scheduler that will schedule the job. Currently, the value can be volcano or default-scheduler, withvolcano` selected by default.
                schedulerName: *null | string
                //+usage=minAvailable represents the minimum number of running pods required to run the job. Only when the number of running pods is not less than minAvailable can the job be considered as running.
                minAvailable: *null | int
                //+usage=volumes indicates the configuration of the volume to which the job is mounted. It complies with the volume configuration requirements in Kubernetes.
                volumes: *null | [...]
                //+usage=Configure tasks.
                tasks: *null | [...]
                //+usage=policies defines the default lifecycle policy for all tasks when tasks.policies is not set.
                policies: *null | [...]
                 //+usage=plugins indicates the plugins used by Volcano when the job is scheduled.
                plugins: *null | {...}
                //+usage=queue indicates the queue to which the job belongs.
                queue: *null | string
                //+usage=priorityClassName indicates the priority of the job. It is used in preemptive scheduling.
                priorityClassName: *null | string
                //+usage=maxRetry indicates the maximum number of retries allowed by the job.
                maxRetry: *null | int
        }
}
