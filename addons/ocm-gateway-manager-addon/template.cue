package main

import "list"

vapWorkflowSteps: *[] | [...]
vapComponents:    *[] | [...]

if parameter.includeAdmissionPolicy {
	vapWorkflowSteps: [
		{
			name: "apply-vap-cluster-management-addon"
			type: "apply-component"
			properties: component: "vap-cluster-management-addon"
		},
		{
			name: "apply-vap-addon-template"
			type: "apply-component"
			properties: component: "vap-addon-template"
		},
	]
	vapComponents: [
		{
			name: "vap-cluster-management-addon"
			type: "k8s-objects"
			properties: objects: [clusterManagementAddOnTokenMintBlock]
		},
		{
			name: "vap-addon-template"
			type: "k8s-objects"
			properties: objects: [addOnTemplateTokenMintBlock]
		},
	]
}

// Every vendored object (resources/vendored-objects.cue) gets its own
// k8s-objects component + apply-component step, rather than one bundled
// component applied via the deprecated apply-remaining workflow step.
// apply-remaining routes through KubeVela's legacy oam provider, which builds
// CUE paths via unquoted string interpolation; auto-generated names like
// "objects-1" then parse as arithmetic (outputs.objects - 1) instead of a
// selector, failing with "invalid path: invalid label outputs.objects-N" for
// any multi-object component (see TROUBLESHOOTING.md §1.5).
output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	metadata: {
		name:      "ocm-gateway-manager-addon"
		namespace: "vela-system"
	}
	spec: {
		workflow: steps: list.Concat([[
			{
				name: "apply-ns"
				type: "apply-component"
				properties: component: "ns-open-cluster-management-addon"
			},
			{
				name: "apply-crd-cluster-gateway"
				type: "apply-component"
				properties: component: "crd-cluster-gateway"
			},
			{
				name: "apply-crd-cluster-proxy"
				type: "apply-component"
				properties: component: "crd-cluster-proxy"
			},
			{
				name: "apply-crd-cluster-proxy-service-resolver"
				type: "apply-component"
				properties: component: "crd-cluster-proxy-service-resolver"
			},
			{
				name: "apply-crd-managed-serviceaccount"
				type: "apply-component"
				properties: component: "crd-managed-serviceaccount"
			},
			{
				name: "apply-cluster-gateway-addon-manager"
				type: "apply-component"
				properties: component: "res-cluster-gateway-addon-manager"
			},
			{
				name: "apply-cluster-gateway-clustergatewayconfiguration"
				type: "apply-component"
				properties: component: "res-cluster-gateway-clustergatewayconfiguration"
			},
			{
				name: "apply-cluster-gateway-clustermanagementaddon"
				type: "apply-component"
				properties: component: "res-cluster-gateway-clustermanagementaddon"
			},
			{
				name: "apply-cluster-gateway-clusterrolebindings"
				type: "apply-component"
				properties: component: "res-cluster-gateway-clusterrolebindings"
			},
			{
				name: "apply-cluster-gateway-clusterroles"
				type: "apply-component"
				properties: component: "res-cluster-gateway-clusterroles"
			},
			{
				name: "apply-cluster-gateway-rolebinder-kubesystem"
				type: "apply-component"
				properties: component: "res-cluster-gateway-rolebinder-kubesystem"
			},
			{
				name: "apply-cluster-gateway-rolebinder"
				type: "apply-component"
				properties: component: "res-cluster-gateway-rolebinder"
			},
			{
				name: "apply-cluster-gateway-serviceaccount"
				type: "apply-component"
				properties: component: "res-cluster-gateway-serviceaccount"
			},
			{
				name: "apply-cluster-proxy-clustermanagementaddon"
				type: "apply-component"
				properties: component: "res-cluster-proxy-clustermanagementaddon"
			},
			{
				name: "apply-cluster-proxy-clusterrolebinding"
				type: "apply-component"
				properties: component: "res-cluster-proxy-clusterrolebinding"
			},
			{
				name: "apply-cluster-proxy-clusterrole"
				type: "apply-component"
				properties: component: "res-cluster-proxy-clusterrole"
			},
			{
				name: "apply-cluster-proxy-clustersetbinding"
				type: "apply-component"
				properties: component: "res-cluster-proxy-clustersetbinding"
			},
			{
				name: "apply-cluster-proxy-managedproxyconfiguration"
				type: "apply-component"
				properties: component: "res-cluster-proxy-managedproxyconfiguration"
			},
			{
				name: "apply-cluster-proxy-manager-deployment"
				type: "apply-component"
				properties: component: "res-cluster-proxy-manager-deployment"
			},
			{
				name: "apply-cluster-proxy-placement"
				type: "apply-component"
				properties: component: "res-cluster-proxy-placement"
			},
			{
				name: "apply-cluster-proxy-rolebinding"
				type: "apply-component"
				properties: component: "res-cluster-proxy-rolebinding"
			},
			{
				name: "apply-cluster-proxy-role"
				type: "apply-component"
				properties: component: "res-cluster-proxy-role"
			},
			{
				name: "apply-cluster-proxy-serviceaccount"
				type: "apply-component"
				properties: component: "res-cluster-proxy-serviceaccount"
			},
			{
				name: "apply-managed-serviceaccount-clustermanagementaddon"
				type: "apply-component"
				properties: component: "res-managed-serviceaccount-clustermanagementaddon"
			},
			{
				name: "apply-managed-serviceaccount-clusterrolebinding"
				type: "apply-component"
				properties: component: "res-managed-serviceaccount-clusterrolebinding"
			},
			{
				name: "apply-managed-serviceaccount-clusterrole"
				type: "apply-component"
				properties: component: "res-managed-serviceaccount-clusterrole"
			},
			{
				name: "apply-managed-serviceaccount-clustersetbinding"
				type: "apply-component"
				properties: component: "res-managed-serviceaccount-clustersetbinding"
			},
			{
				name: "apply-managed-serviceaccount-manager-deployment"
				type: "apply-component"
				properties: component: "res-managed-serviceaccount-manager-deployment"
			},
			{
				name: "apply-managed-serviceaccount-placement"
				type: "apply-component"
				properties: component: "res-managed-serviceaccount-placement"
			},
			{
				name: "apply-managed-serviceaccount-serviceaccount"
				type: "apply-component"
				properties: component: "res-managed-serviceaccount-serviceaccount"
			},
		], vapWorkflowSteps])
		components: list.Concat([[
			{
				name: "ns-open-cluster-management-addon"
				type: "k8s-objects"
				properties: objects: [
					{
						kind:       "Namespace"
						apiVersion: "v1"
						metadata: name: "open-cluster-management-addon"
					},
				]
			},
			{
				name: "crd-cluster-gateway"
				type: "k8s-objects"
				properties: objects: [clusterGatewayConfigurationCRD]
			},
			{
				name: "crd-cluster-proxy"
				type: "k8s-objects"
				properties: objects: [managedProxyConfigurationCRD]
			},
			{
				name: "crd-cluster-proxy-service-resolver"
				type: "k8s-objects"
				properties: objects: [managedProxyServiceResolverCRD]
			},
			{
				name: "crd-managed-serviceaccount"
				type: "k8s-objects"
				properties: objects: [managedServiceAccountCRD]
			},
			{
				name: "res-cluster-gateway-addon-manager"
				type: "k8s-objects"
				properties: objects: [clusterGatewayAddonManagerObject]
			},
			{
				name: "res-cluster-gateway-clustergatewayconfiguration"
				type: "k8s-objects"
				properties: objects: [clusterGatewayClustergatewayconfigurationObject]
			},
			{
				name: "res-cluster-gateway-clustermanagementaddon"
				type: "k8s-objects"
				properties: objects: [clusterGatewayClustermanagementaddonObject]
			},
			{
				name: "res-cluster-gateway-clusterrolebindings"
				type: "k8s-objects"
				properties: objects: [clusterGatewayClusterrolebindingsObject]
			},
			{
				name: "res-cluster-gateway-clusterroles"
				type: "k8s-objects"
				properties: objects: [clusterGatewayClusterrolesObject]
			},
			{
				name: "res-cluster-gateway-rolebinder-kubesystem"
				type: "k8s-objects"
				properties: objects: [clusterGatewayRolebinderKubesystemObject]
			},
			{
				name: "res-cluster-gateway-rolebinder"
				type: "k8s-objects"
				properties: objects: [clusterGatewayRolebinderObject]
			},
			{
				name: "res-cluster-gateway-serviceaccount"
				type: "k8s-objects"
				properties: objects: [clusterGatewayServiceaccountObject]
			},
			{
				name: "res-cluster-proxy-clustermanagementaddon"
				type: "k8s-objects"
				properties: objects: [clusterProxyClustermanagementaddonObject]
			},
			{
				name: "res-cluster-proxy-clusterrolebinding"
				type: "k8s-objects"
				properties: objects: [clusterProxyClusterrolebindingObject]
			},
			{
				name: "res-cluster-proxy-clusterrole"
				type: "k8s-objects"
				properties: objects: [clusterProxyClusterroleObject]
			},
			{
				name: "res-cluster-proxy-clustersetbinding"
				type: "k8s-objects"
				properties: objects: [clusterProxyClustersetbindingObject]
			},
			{
				name: "res-cluster-proxy-managedproxyconfiguration"
				type: "k8s-objects"
				properties: objects: [clusterProxyManagedproxyconfigurationObject]
			},
			{
				name: "res-cluster-proxy-manager-deployment"
				type: "k8s-objects"
				properties: objects: [clusterProxyManagerDeploymentObject]
			},
			{
				name: "res-cluster-proxy-placement"
				type: "k8s-objects"
				properties: objects: [clusterProxyPlacementObject]
			},
			{
				name: "res-cluster-proxy-rolebinding"
				type: "k8s-objects"
				properties: objects: [clusterProxyRolebindingObject]
			},
			{
				name: "res-cluster-proxy-role"
				type: "k8s-objects"
				properties: objects: [clusterProxyRoleObject]
			},
			{
				name: "res-cluster-proxy-serviceaccount"
				type: "k8s-objects"
				properties: objects: [clusterProxyServiceaccountObject]
			},
			{
				name: "res-managed-serviceaccount-clustermanagementaddon"
				type: "k8s-objects"
				properties: objects: [managedServiceaccountClustermanagementaddonObject]
			},
			{
				name: "res-managed-serviceaccount-clusterrolebinding"
				type: "k8s-objects"
				properties: objects: [managedServiceaccountClusterrolebindingObject]
			},
			{
				name: "res-managed-serviceaccount-clusterrole"
				type: "k8s-objects"
				properties: objects: [managedServiceaccountClusterroleObject]
			},
			{
				name: "res-managed-serviceaccount-clustersetbinding"
				type: "k8s-objects"
				properties: objects: [managedServiceaccountClustersetbindingObject]
			},
			{
				name: "res-managed-serviceaccount-manager-deployment"
				type: "k8s-objects"
				properties: objects: [managedServiceaccountManagerDeploymentObject]
			},
			{
				name: "res-managed-serviceaccount-placement"
				type: "k8s-objects"
				properties: objects: [managedServiceaccountPlacementObject]
			},
			{
				name: "res-managed-serviceaccount-serviceaccount"
				type: "k8s-objects"
				properties: objects: [managedServiceaccountServiceaccountObject]
			},
		], vapComponents])
	}
}
