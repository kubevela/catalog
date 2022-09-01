package main

vectorConfig: {
    name: "vector-config"
    type: "k8s-objects"
    properties: objects: [{
        apiVersion: "v1"
        kind: "ConfigMap"
        metadata: name: "vector"
        data: {
            "vector.yaml": #"""
                data_dir: /vector-data-dir
                sources:
                  kubernetes-logs:
                    type: kubernetes_logs
                sinks:
                  loki:
                    type: loki
                    inputs:
                      - kubernetes-logs
                    endpoint: http://$LOKIHOST:3100
                    compression: none
                    request:
                      concurrency: 10
                    labels:
                      cluster: $CLUSTER
                      log_type: stdout
                      forward: daemon
                      pod_namespace: "{{ kubernetes.pod_namespace }}"
                      pod_name: "{{ kubernetes.pod_name }}"
                    encoding:
                      codec: json
                """#
        }
    }]
}