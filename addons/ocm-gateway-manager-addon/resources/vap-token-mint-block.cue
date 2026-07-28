package main

// Ships a ValidatingAdmissionPolicy (+ Binding) to every managed cluster, via
// the OCM addon-framework Placement `global` (namespace
// open-cluster-management-addon) that managed-serviceaccount itself uses.
//
// Deployed only when parameter.includeAdmissionPolicy is true (default:
// true — see parameter.cue). ValidatingAdmissionPolicy requires Kubernetes
// >=1.30.

clusterManagementAddOnTokenMintBlock: {
	apiVersion: "addon.open-cluster-management.io/v1alpha1"
	kind:       "ClusterManagementAddOn"
	metadata: name: "cluster-gateway-token-mint-block"
	spec: {
		addOnMeta: {
			displayName: "cluster-gateway-token-mint-block"
			description: "Blocks the cluster-gateway ServiceAccount from minting its own ServiceAccount tokens via a cluster-wide ValidatingAdmissionPolicy."
		}
		installStrategy: {
			type: "Placements"
			placements: [
				{
					name:      "global"
					namespace: "open-cluster-management-addon"
					rolloutStrategy: type: "All"
				},
			]
		}
		supportedConfigs: [
			{
				group:    "addon.open-cluster-management.io"
				resource: "addontemplates"
				defaultConfig: name: "cluster-gateway-token-mint-block"
			},
		]
	}
}

addOnTemplateTokenMintBlock: {
	apiVersion: "addon.open-cluster-management.io/v1alpha1"
	kind:       "AddOnTemplate"
	metadata: name: "cluster-gateway-token-mint-block"
	spec: {
		addonName: "cluster-gateway-token-mint-block"
		registration: [
			{type: "KubeClient"},
		]
		agentSpec: workload: manifests: [
			{
				apiVersion: "rbac.authorization.k8s.io/v1"
				kind:       "ClusterRole"
				metadata: {
					name: "open-cluster-management:klusterlet-work:cluster-gateway-token-mint-block"
					labels: "open-cluster-management.io/aggregate-to-work": "true"
				}
				rules: [
					{
						apiGroups: ["admissionregistration.k8s.io"]
						resources: ["validatingadmissionpolicies", "validatingadmissionpolicybindings"]
						verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]
					},
				]
			},
			{
				apiVersion: "admissionregistration.k8s.io/v1"
				kind:       "ValidatingAdmissionPolicy"
				metadata: name: "cluster-gateway-block-token-mint"
				spec: {
					failurePolicy: "Fail"
					matchConstraints: resourceRules: [
						{
							apiGroups:   [""]
							apiVersions: ["v1"]
							operations: ["CREATE"]
							resources: ["serviceaccounts/token"]
						},
					]
					variables: [
						{
							name:       "isClusterGatewayToken"
							expression: "request.namespace == 'open-cluster-management-agent-addon' && request.name == 'cluster-gateway'"
						},
						{
							name:       "isTokenMinter"
							expression: "request.userInfo.username == 'system:serviceaccount:open-cluster-management-agent-addon:managed-serviceaccount'"
						},
					]
					validations: [
						{
							expression: "!(variables.isClusterGatewayToken && !variables.isTokenMinter)"
							message:    "tokens for the cluster-gateway ServiceAccount may only be minted by the managed-serviceaccount addon-agent"
							reason:     "Forbidden"
						},
					]
				}
			},
			{
				apiVersion: "admissionregistration.k8s.io/v1"
				kind:       "ValidatingAdmissionPolicyBinding"
				metadata: name: "cluster-gateway-block-token-mint-binding"
				spec: {
					policyName: "cluster-gateway-block-token-mint"
					validationActions: ["Deny"]
				}
			},
		]
	}
}
