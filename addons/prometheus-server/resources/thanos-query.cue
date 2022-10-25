package main

thanosQuery: {
	name: "thanos-query"
	type: "webservice"
	properties: {
		image:      "quay.io/thanos/thanos:v0.8.0"
		exposeType: parameter.serviceType
		ports: [{
			name:   "http"
			port:   9090
			expose: parameter.serviceType != ""
		}]
		livenessProbe: httpGet: {
			port: 9090
			path: "/-/healthy"
		}
		readinessProbe: httpGet: {
			port: 9090
			path: "/-/ready"
		}
	}
	traits: [{
		type: "command"
		properties: {
			args: [
				"query",
				"--http-address=0.0.0.0:9090",
				"--log.level=debug",
				"--query.replica-label=replica",
				"--store.sd-files=/etc/config/targets.yaml",
			]
		}
	}, {
		type: "init-container"
		properties: {
			name:  "init-config"
			image: "curlimages/curl"
			args: ["sh", "-c", ##"""
				NAMESPACE=$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace)
				KUBE_TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
				curl -sSk -H "Authorization: Bearer $KUBE_TOKEN" \
				        https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_PORT_443_TCP_PORT/api/v1/namespaces/$NAMESPACE/services?labelSelector=addons.oam.dev/name=prometheus-server,app.oam.dev\/component=prometheus-server \
				    | grep "\"ip\"" | sed -r 's/.+:\s+"(.*)"/\1/g' > /etc/config/prom-endpoints
				curl -sSk -H "Authorization: Bearer $KUBE_TOKEN" \
				        https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_PORT_443_TCP_PORT/apis/cluster.core.oam.dev/v1alpha1/clustergateways \
				    | grep "\"name\"" | sed -r 's/.+:\s+"(.*)",/\1/g' > /etc/config/clusters
				while read cls; do
				curl -sSk -H "Authorization: Bearer $KUBE_TOKEN" \
				        https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_PORT_443_TCP_PORT/apis/cluster.core.oam.dev/v1alpha1/clustergateways/$cls/proxy/api/v1/namespaces/$NAMESPACE/services?labelSelector=addons.oam.dev/name=prometheus-server,app.oam.dev\/component=prometheus-server \
				    | grep "\"ip\"" | sed -r 's/.+:\s+"(.*)"/\1/g' >> /etc/config/prom-endpoints
				done < /etc/config/clusters
				echo "- targets:" > /etc/config/targets.yaml
				while read ip; do
				echo "  - $ip:10901" >> /etc/config/targets.yaml
				done < /etc/config/prom-endpoints
				"""##]
			mountName:     "config-volume"
			appMountPath:  "/etc/config"
			initMountPath: "/etc/config"
		}
	}, {
		type: "service-account"
		properties: name: "prometheus-server"
	}]
}
