package main

vector: {
    name: "vector"
    type: "daemon"
    properties: {
        image: parameter.vectorImage
        imagePullPolicy: parameter.imagePullPolicy
        env: [{
            name: "VECTOR_SELF_NODE_NAME"
            valueFrom: fieldRef: fieldPath: "spec.nodeName"
        }, {
            name: "VECTOR_SELF_POD_NAME"
            valueFrom: fieldRef: fieldPath: "metadata.name"
        }, {
            name: "VECTOR_SELF_POD_NAMESPACE"
            valueFrom: fieldRef: fieldPath: "metadata.namespace"
        }, {
            name: "PROCFS_ROOT"
            value: "/host/proc"
        }, {
            name: "SYSFS_ROOT"
            value: "/host/sys"
        }]
        volumeMounts: {
            configMap: [{
                name: "bootconfig-volume"
                mountPath: "/etc/bootconfig"
                cmName: "vector"
            }, {
                name: "loki-endpoint-volume"
                mountPath: "/etc/loki-endpoint"
                cmName: "loki-endpoint"
            }]
            hostPath: [{
                name: "data"
                path: "/var/lib/vector"
                mountPath: "/vector-data-dir"
            }, {
                name: "var-log"
                path: "/var/log/"
                mountPath: "/var/log/"
                readOnly: true
            }, {
                name: "var-lib"
                path: "/var/lib/"
                mountPath: "/var/lib/"
                readOnly: true
            }, {
                name: "procfs"
                path:  "/proc"
                mountPath: "/host/proc"
                readOnly: true
            }, {
                name: "sysfs"
                path:  "/sys"
                mountPath: "/host/sys"
                readOnly: true
            }]
        }
    }
    traits: [{
        type: "command"
		properties: args: ["--config-dir", "/etc/config/"]
    }, {
		type: "init-container"
		properties: {
			name:  "init-config"
			image: "curlimages/curl"
			args: ["sh", "-c", ##"""
                NAMESPACE=$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace)
                KUBE_TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
                DEPLOYNAME=$(echo $HOSTNAME | sed -r 's/(.+)-[^-]+/\1/g')
                LOKIHOST=$(cat /etc/loki-endpoint/host)
                curl -sSk -H "Authorization: Bearer $KUBE_TOKEN" \
                        https://kubernetes.default/apis/apps/v1/namespaces/$NAMESPACE/daemonsets/$DEPLOYNAME \
                    | grep "\"app.oam.dev/cluster\"" | sed -r 's/.+:\s+"(.*)",/\1/g' > /etc/config/cluster.name \
                && CLS=$(cat /etc/config/cluster.name) \
                && CLUSTER="${CLS:-local}" \
                && echo "cluster: $CLUSTER" \
                && echo "loki-host: $LOKIHOST" \
                && sed s/\$CLUSTER/$CLUSTER/g /etc/bootconfig/vector.yaml > /etc/config/vector.yaml.tmp \
                && sed s/\$LOKIHOST/$LOKIHOST/g /etc/config/vector.yaml.tmp > /etc/config/vector.yaml
                """##]
			mountName:     "config-volume"
			appMountPath:  "/etc/config"
			initMountPath: "/etc/config"
			extraVolumeMounts: [{
				name:      "bootconfig-volume"
				mountPath: "/etc/bootconfig"
			}, {
				name:      "loki-endpoint-volume"
				mountPath: "/etc/loki-endpoint"
			}]
		}
	}, {
        type: "service-account"
        properties: {
            name:   "vector"
			create: true
			privileges: [{
				scope: "cluster"
				apiGroups: [""]
                resources: ["nodes", "namespaces", "pods"]
                verbs: ["watch", "list"]
			}]
        }
    }]
}