package main

prometheusServer: {
	name: "prometheus-server"
	type: "webservice"
	dependsOn: ["prometheus-config"]
	properties: {
		image:           parameter["image"]
		imagePullPolicy: parameter["imagePullPolicy"]
		livenessProbe: httpGet: {
			path: "/-/healthy"
			port: 9090
		}
		readinessProbe: httpGet: {
			path: "/-/ready"
			port: 9090
		}
		ports: [{
			name: "http"
			port: 9090
		}]
		if parameter.storage == _|_ {
			volumeMounts: emptyDir: [{
				name:      "storage-volume"
				mountPath: "/data"
			}]
		}
		if parameter.storage != _|_ {
			volumeMounts: pvc: [{
				name:      "storage-volume"
				mountPath: "/data"
				claimName: "prometheus-server-storage"
			}]
		}
		_cms: [{
			name:      "bootconfig-volume"
			cmName:    "prometheus-server"
			mountPath: "/etc/bootconfig"
		}, {
			if parameter.customConfig != _|_ {
				name:      "custom-config-volume"
				cmName:    parameter.customConfig
				mountPath: "/etc/custom"
			}
		}]
		volumeMounts: configMap: [ for cm in _cms if cm.name != _|_ {cm}]
	}
	traits: [ for trait in _traits if trait.type != _|_ {trait}]
	_traits: [{
		type: "command"
		properties: args: [
			"--config.file=/etc/config/prometheus.yml",
			"--storage.tsdb.path=/data",
			"--web.console.libraries=/etc/prometheus/console_libraries",
			"--web.console.templates=/etc/prometheus/consoles",
			"--web.enable-lifecycle",
		]
	}, {
		type: "init-container"
		properties: {
			name:  "init-config"
			image: "curlimages/curl"
			args: ["sh", "-c", ##"""
                NAMESPACE=$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace)
                KUBE_TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
                DEPLOYNAME=$(echo $HOSTNAME | sed -r 's/(.+)-[^-]+-[^-]+/\1/g')
                curl -sSk -H "Authorization: Bearer $KUBE_TOKEN" \
                        https://kubernetes.default/apis/apps/v1/namespaces/$NAMESPACE/deployments/$DEPLOYNAME \
                    | grep "\"app.oam.dev/cluster\"" | sed -r 's/.+:\s+"(.*)",/\1/g' > /etc/config/cluster.name \
                && CLS=$(cat /etc/config/cluster.name) \
                && CLUSTER="${CLS:-local}" \
                && echo "cluster: $CLUSTER" \
                && sed s/\$CLUSTER/$CLUSTER/g /etc/bootconfig/prometheus.yml > /etc/config/prometheus.yml
                """##]
			mountName:     "config-volume"
			appMountPath:  "/etc/config"
			initMountPath: "/etc/config"
			extraVolumeMounts: [{
				name:      "bootconfig-volume"
				mountPath: "/etc/bootconfig"
			}]
		}
	}, {
		if parameter.customConfig != _|_ {
			type: "sidecar"
			properties: {
				name:  "prometheus-server-configmap-reload"
				image: "jimmidyson/configmap-reload:v0.5.0"
				args: ["--volume-dir=/etc/custom", "--webhook-url=http://127.0.0.1:9090/-/reload"]
				volumes: [{
					name: "custom-config-volume"
					path: "/etc/custom"
				}]
			}
		}
	}, {
		if parameter.thanos {
			type: "json-patch"
			properties: {
				operations: [{
					op:   "add"
					path: "/spec/template/spec/containers/-"
					value: {
						name:  "thanos"
						image: "quay.io/thanos/thanos:v0.8.0"
						args: ["sidecar", "--tsdb.path=/data", "--prometheus.url=http://127.0.0.1:9090"]
						env: [{
							name: "POD_NAME"
							valueFrom: fieldRef: fieldPath: "metadata.name"
						}]
						ports: [{
							name:          "http-sidecar"
							containerPort: 10902
						}, {
							name:          "grpc"
							containerPort: 10901
						}]
						livenessProbe: httpGet: {
							port: 10902
							path: "/-/healthy"
						}
						readinessProbe: httpGet: {
							port: 10902
							path: "/-/ready"
						}
						volumeMounts: [{
							name:      "storage-volume"
							mountPath: "/data"
						}]
					}
				}]
			}
		}
	}, {
		type: "service-account"
		properties: {
			name:   "prometheus-server"
			create: true
			privileges: [ for p in _clusterPrivileges {
				scope: "cluster"
				{p}
			}]
		}
	}, {
		type: "resource"
		properties: {
			cpu:    parameter["cpu"]
			memory: parameter["memory"]
		}
	}, {
		type: "expose"
		properties: {
			_ports: [{
				if !parameter.thanos {
					port: 9090
				}
			}, {
				if parameter.thanos {
					port: 10902
				}
			}, {
				if parameter.thanos {
					port: 10901
				}
			}]
			port: [ for p in _ports if p.port != _|_ {p.port}]
			type: parameter.serviceType
		}
	}]
}

_clusterPrivileges: [{
	apiGroups: [""]
	resources: ["nodes", "nodes/proxy", "nodes/metrics", "services", "endpoints", "pods", "ingresses", "configmaps"]
	verbs: ["get", "list", "watch"]
}, {
	apiGroups: ["extensions", "networking.k8s.io"]
	resources: ["ingresses/status", "ingresses"]
	verbs: ["get", "list", "watch"]
}, {
	nonResourceURLs: ["/metrics"]
	verbs: ["get"]
}, {
	apiGroups: ["apps"]
	resources: ["deployments"]
	resourceNames: ["prometheus-server"]
	verbs: ["get"]
}, {
	apiGroups: ["cluster.core.oam.dev"]
	resources: ["clustergateways", "clustergateways/proxy"]
	verbs: ["get", "list"]
}, {
	apiGroups: [""]
	resources: ["services"]
	verbs: ["get", "list"]
}]
