package main

agentInitContainer: {
	type: "init-container"
	properties: {
		name:            "init-config"
		image:           "curlimages/curl"
		imagePullPolicy: "IfNotPresent"
		args: ["sh", "-c", ##"""
			NAMESPACE=$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace)
			KUBE_TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
			DEPLOYNAME=$(echo $HOSTNAME | sed -r 's/(.+)-[^-]+/\1/g')
			curl -sSk -H "Authorization: Bearer $KUBE_TOKEN" \
			        https://kubernetes.default/apis/apps/v1/namespaces/$NAMESPACE/daemonsets/$DEPLOYNAME \
			    | grep "\"app.oam.dev/cluster\"" | sed -r 's/.+:\s+"(.*)",/\1/g' > /etc/config/cluster.name \
			&& CLS=$(cat /etc/config/cluster.name) \
			&& CLUSTER="${CLS:-local}" \
			&& echo "cluster: $CLUSTER" \
			&& sed s/\$CLUSTER/$CLUSTER/g /etc/bootconfig/agent.yaml > /etc/config/agent.yaml
			"""##]
		mountName:     "config-volume"
		appMountPath:  "/etc/config"
		initMountPath: "/etc/config"
		extraVolumeMounts: [{
			name:      "bootconfig-volume"
			mountPath: "/etc/bootconfig"
		}]
	}
}

agentServiceAccount: {
	type: "service-account"
	properties: {
		create: true
		privileges: [{
			scope: "cluster"
			apiGroups: [""]
			resources: ["nodes", "nodes/proxy", "services", "endpoints", "pods", "namespaces"]
			verbs: ["get", "watch", "list"]
		}, {
			scope: "namespace"
			apiGroups: ["apps"]
			resources: ["daemonsets"]
			resourceNames: ["promtail", "vector"]
			verbs: ["get"]
		}]
	}
}

agent:              *{} | {...}
agentConfig:        *{} | {...}
agentComponents:    *[] | [...{...}]
agentPolicies:      *[] | [...{...}]
agentWorkflowSteps: *[] | [...{...}]
loki: {...}

vector: {...}
vectorConfig: {...}
promtail: {...}
promtailConfig: {...}
vectorController: {...}
vectorControllerAgentConfig: {...}
vectorControllerAgent:{...}
vectorCRDComponent: {...}

if parameter.agent == "vector" {
	agent:       vector
	agentConfig: vectorConfig
}

if parameter.agent == "promtail" {
	agent:       promtail
	agentConfig: promtailConfig
}

if parameter.agent == "vector-controller-agent" {
	agent:       vectorControllerAgent
  agentConfig: vectorControllerAgentConfig
  vectorController: vectorController
  vectorCRDComponent: vectorCRDComponent
}

if parameter.agent != "" {
	agentComponents: [agent, agentConfig]  + [vectorController, vectorCRDComponent]
	agentPolicies: [{
		type: "override"
		name: "agent-components"
		properties: selector: [for comp in agentComponents if comp.name != _|_ {comp.name}]
	}]
	agentWorkflowSteps: [{
		type: "deploy"
		name: "deploy-agent"
		properties: policies: ["deploy-multi-cluster", "agent-components"]
	}]
}
