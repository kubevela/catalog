"koordinator-pod-migration-job": {
        alias: ""
        annotations: {}
        attributes: workload: type: "autodetects.core.oam.dev"
        description: "koordinator pod migration job component"
        labels: {}
        type: "component"
}

template: {
        output: {
                kind:       "PodMigrationJob"
                apiVersion: "scheduling.koordinator.sh/v1alpha1"
                metadata: {
                    name:      context.name
                }
                spec: {
                    paused:                       parameter.paused
                    ttl:                          parameter.ttl
                    mode:                         parameter.mode
                    podRef:                       parameter.podRef
                    reservationOptions:           parameter.reservationOptions
                    deleteOptions:                parameter.deleteOptions
                }
        }
        parameter: {
                //+usage=Paused indicates whether the PodMigrationJob should to work or not.
                paused: *false | bool
                //+usage=TTL controls the PodMigrationJob timeout duration.
                ttl: *null | string
                //+usage=Mode represents the operating mode of the Job.
                mode: *"PodMigrationJobModeReservationFirst" | string
                //+usage=PodRef represents the Pod that be migrated.
                podRef: *null | {...}
                //+usage=ReservationOptions defines the Reservation options for migrated Pod.
                reservationOptions: *null | {...}
                //+usage=DeleteOptions defines the deleting options for the migrated Pod and preempted Pods.
                deleteOptions: *null | {...}
        }
}
