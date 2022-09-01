package main

promtail: {
    name: "promtail"
    type: "daemon"
    properties: {
        image: parameter.promtailImage
        imagePullPolicy: parameter.imagePullPolicy
        env: [{
            name: "HOSTNAME"
            valueFrom: fieldRef: fieldPath: "spec.nodeName"
        }]
        volumeMounts: {
            configMap: [{
                name: "bootconfig-volume"
                mountPath: "/etc/bootconfig"
                cmName: "promtail"
            }, {
                name: "loki-endpoint-volume"
                mountPath: "/etc/loki-endpoint"
                cmName: "loki-endpoint"
            }]
            hostPath: [{
                name: "run"
                path: "/run/promtail"
                mountPath: "/run/promtail"
            }, {
                name: "containers"
                path: "/var/lib/docker/containers"
                mountPath: "/var/lib/docker/containers"
                readOnly: true
            }, {
                name: "pods"
                path:  "/var/log/pods"
                mountPath: "/var/log/pods"
                readOnly: true
            }]
        }
        readinessProbe: {
			httpGet: {
				path: "/ready"
				port: 3101
			}
			initialDelaySeconds: 10
		}
    }
    traits: [{
        type: "command"
		properties: args: ["-config.file=/etc/config/promtail.yaml"]
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
                && sed s/\$CLUSTER/$CLUSTER/g /etc/bootconfig/promtail.yaml > /etc/config/promtail.yaml.tmp \
                && sed s/\$LOKIHOST/$LOKIHOST/g /etc/config/promtail.yaml.tmp > /etc/config/promtail.yaml
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
            name:   "promtail"
			create: true
			privileges: [{
				scope: "cluster"
				apiGroups: [""]
                resources: ["nodes", "nodes/proxy", "services", "endpoints", "pods"]
                verbs: ["get", "watch", "list"]
			}, {
                scope: "namespace"
                apiGroups: ["apps"]
                resources: ["daemonsets"]
                resourceNames: ["promtail"]
                verbs: ["get"]
            }]
        }
    }, {
        type: "json-patch"
        properties: operations: [{
            op: "add"
            path: "/spec/template/spec/containers/0/securityContext"
            value: {
                allowPrivilegeEscalation: false
                capabilities: drop: ["ALL"]
                readOnlyRootFilesystem: true
            }
        }]
    }]
}