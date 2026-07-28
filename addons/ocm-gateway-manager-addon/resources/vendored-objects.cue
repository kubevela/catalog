package main

clusterGatewayAddonManagerObject: {
	// Source: cluster-gateway-addon-manager/templates/addon-manager.yaml
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata: {
		name:      "cluster-gateway-addon-manager"
		namespace: "open-cluster-management-addon"
		labels: app: "cluster-gateway-addon-manager"
	}
	spec: {
		replicas: 1
		selector: matchLabels: app: "cluster-gateway-addon-manager"
		template: {
			metadata: labels: app: "cluster-gateway-addon-manager"
			spec: {
				serviceAccount: "cluster-gateway-addon-manager"
				containers: [{
					name:            "cluster-gateway-addon-manager"
					image:           "oamdev/cluster-gateway-addon-manager:v1.8.0"
					imagePullPolicy: "IfNotPresent"
					args: ["--leader-elect=true"]
				}]
			}
		}
	}
}

clusterGatewayClustergatewayconfigurationObject: {
	// Source: cluster-gateway-addon-manager/templates/clustergatewayconfiguration.yaml
	apiVersion: "proxy.open-cluster-management.io/v1alpha1"
	kind:       "ClusterGatewayConfiguration"
	metadata: name: "cluster-gateway"
	spec: {
		image:            "oamdev/cluster-gateway:v1.8.0"
		installNamespace: "vela-system"
		secretNamespace:  "open-cluster-management-credentials"
		secretManagement: {
			type: "ManagedServiceAccount"
			managedServiceAccount: name: "cluster-gateway"
		}
		egress: {
			type: "ClusterProxy"
			clusterProxy: {
				proxyServerHost: "proxy-entrypoint.open-cluster-management-addon"
				proxyServerPort: 8090
				credentials: {
					namespace:               "open-cluster-management-addon"
					proxyClientCASecretName: "proxy-server-ca"
					proxyClientSecretName:   "proxy-client"
				}
			}
		}
	}
}

clusterGatewayClustermanagementaddonObject: {
	// Source: cluster-gateway-addon-manager/templates/clustermanagementaddon.yaml
	apiVersion: "addon.open-cluster-management.io/v1alpha1"
	kind:       "ClusterManagementAddOn"
	metadata: name: "cluster-gateway"
	spec: {
		addOnMeta: {
			displayName: "cluster-gateway"
			description: "cluster-gateway"
		}
		addOnConfiguration: {
			crdName: "clustergatewayconfigurations.proxy.open-cluster-management.io"
			crName:  "cluster-gateway"
		}
	}
}

clusterGatewayClusterrolebindingsObject: {
	// Source: cluster-gateway-addon-manager/templates/clusterrolebindings.yaml
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRoleBinding"
	metadata: name: "open-cluster-management:cluster-gateway:managedcluster-reader"
	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "ClusterRole"
		name:     "open-cluster-management:cluster-gateway:managedcluster-reader"
	}
	subjects: [{
		kind:      "ServiceAccount"
		name:      "cluster-gateway-addon-manager"
		namespace: "open-cluster-management-addon"
	}]
}

clusterGatewayClusterrolesObject: {
	// Source: cluster-gateway-addon-manager/templates/clusterroles.yaml
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRole"
	metadata: name: "open-cluster-management:cluster-gateway:managedcluster-reader"
	rules: [{
		apiGroups: ["cluster.open-cluster-management.io"]
		resources: ["managedclusters"]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}, {
		apiGroups: ["authentication.open-cluster-management.io"]
		resources: ["managedserviceaccounts"]
		verbs: ["*"]
	}, {
		apiGroups: ["proxy.open-cluster-management.io"]
		resources: ["clustergatewayconfigurations"]
		verbs: ["*"]
	}, {
		apiGroups: ["cluster.core.oam.dev"]
		resources: [
			"clustergateways/health",
			"clustergateways/proxy",
		]
		verbs: ["*"]
	}, {
		apiGroups: [""]
		resources: [
			"namespaces",
			"secrets",
			"configmaps",
			"events",
			"serviceaccounts",
			"services",
		]
		verbs: ["*"]
	}, {
		apiGroups: ["apps"]
		resources: ["deployments"]
		verbs: ["*"]
	}, {
		apiGroups: ["work.open-cluster-management.io"]
		resources: ["manifestworks"]
		verbs: ["*"]
	}, {
		apiGroups: ["addon.open-cluster-management.io"]
		resources: [
			"clustermanagementaddons",
			"managedclusteraddons",
			"clustermanagementaddons/status",
			"managedclusteraddons/status",
		]
		verbs: [
			"get",
			"list",
			"watch",
			"create",
			"update",
			"patch",
		]
	}, {
		apiGroups: ["certificates.k8s.io"]
		resources: ["certificatesigningrequests"]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}, {
		apiGroups: ["admissionregistration.k8s.io"]
		resources: [
			"mutatingwebhookconfigurations",
			"validatingwebhookconfigurations",
		]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}, {
		apiGroups: ["flowcontrol.apiserver.k8s.io"]
		resources: [
			"prioritylevelconfigurations",
			"flowschemas",
		]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}, {
		apiGroups: ["rbac.authorization.k8s.io"]
		resources: [
			"clusterroles",
			"clusterrolebindings",
		]
		verbs: [
			"create",
			"bind",
		]
	}, {
		apiGroups: ["rbac.authorization.k8s.io"]
		resources: [
			"roles",
			"rolebindings",
		]
		verbs: ["create"]
	}, {
		apiGroups: ["coordination.k8s.io"]
		resources: ["leases"]
		verbs: ["*"]
	}, {
		apiGroups: ["apiregistration.k8s.io"]
		resources: ["apiservices"]
		verbs: ["*"]
	}, {
		apiGroups: ["authorization.k8s.io"]
		resources: ["subjectaccessreviews"]
		verbs: ["*"]
	}]
}

clusterGatewayRolebinderKubesystemObject: {
	// Source: cluster-gateway-addon-manager/templates/rolebinder-kubesystem.yaml
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "RoleBinding"
	metadata: {
		name:      "open-cluster-management:cluster-gateway:role-grantor"
		namespace: "kube-system"
	}
	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "ClusterRole"
		name:     "open-cluster-management:cluster-gateway:managedcluster-reader"
	}
	subjects: [{
		kind:      "ServiceAccount"
		name:      "cluster-gateway-addon-manager"
		namespace: "open-cluster-management-addon"
	}]
}

clusterGatewayRolebinderObject: {
	// Source: cluster-gateway-addon-manager/templates/rolebinder.yaml
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "RoleBinding"
	metadata: {
		name:      "open-cluster-management:cluster-gateway:role-grantor"
		namespace: "open-cluster-management-addon"
	}
	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "ClusterRole"
		name:     "open-cluster-management:cluster-gateway:managedcluster-reader"
	}
	subjects: [{
		kind:      "ServiceAccount"
		name:      "cluster-gateway-addon-manager"
		namespace: "open-cluster-management-addon"
	}]
}

clusterGatewayServiceaccountObject: {
	// Source: cluster-gateway-addon-manager/templates/serviceaccount.yaml
	apiVersion: "v1"
	kind:       "ServiceAccount"
	metadata: {
		name:      "cluster-gateway-addon-manager"
		namespace: "open-cluster-management-addon"
	}
}

clusterProxyClustermanagementaddonObject: {
	// Source: cluster-proxy/templates/clustermanagementaddon.yaml
	apiVersion: "addon.open-cluster-management.io/v1alpha1"
	kind:       "ClusterManagementAddOn"
	metadata: {
		name: "cluster-proxy"
		annotations: "addon.open-cluster-management.io/lifecycle": "addon-manager"
	}
	spec: {
		addOnMeta: {
			displayName: "cluster-proxy"
			description: "cluster-proxy"
		}
		supportedConfigs: [{
			group:    "proxy.open-cluster-management.io"
			resource: "managedproxyconfigurations"
			defaultConfig: name: "cluster-proxy"
		}, {
			group:    "addon.open-cluster-management.io"
			resource: "addondeploymentconfigs"
		}]
		installStrategy: {
			type: "Placements"
			placements: [{
				name:      "cluster-proxy-placement"
				namespace: "open-cluster-management-addon"
			}]
		}
	}
}

clusterProxyClusterrolebindingObject: {
	// Source: cluster-proxy/templates/clusterrolebinding.yaml
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRoleBinding"
	metadata: name: "open-cluster-management:cluster-proxy:addon-manager"
	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "ClusterRole"
		name:     "open-cluster-management:cluster-proxy:addon-manager"
	}
	subjects: [{
		kind:      "ServiceAccount"
		name:      "cluster-proxy"
		namespace: "open-cluster-management-addon"
	}]
}

clusterProxyClusterroleObject: {
	// Source: cluster-proxy/templates/clusterrole.yaml
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRole"
	metadata: name: "open-cluster-management:cluster-proxy:addon-manager"
	rules: [{
		apiGroups: ["cluster.open-cluster-management.io"]
		resources: [
			"managedclusters",
			"managedclustersets",
		]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}, {
		apiGroups: ["addon.open-cluster-management.io"]
		resources: [
			"clustermanagementaddons",
			"managedclusteraddons",
			"clustermanagementaddons/status",
			"clustermanagementaddons/finalizers",
			"managedclusteraddons/status",
		]
		verbs: ["*"]
	}, {
		apiGroups: ["addon.open-cluster-management.io"]
		resources: ["addondeploymentconfigs"]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}, {
		apiGroups: ["addon.open-cluster-management.io"]
		resources: ["managedclusteraddons/finalizers"]
		verbs: ["*"]
	}, {
		apiGroups: ["proxy.open-cluster-management.io"]
		resources: [
			"managedproxyconfigurations",
			"managedproxyconfigurations/status",
			"managedproxyconfigurations/finalizers",
			"managedproxyserviceresolvers",
			"managedproxyserviceresolvers/status",
			"managedproxyserviceresolvers/finalizers",
		]
		verbs: ["*"]
	}, {
		apiGroups: ["certificates.k8s.io"]
		resources: [
			"certificatesigningrequests",
			"certificatesigningrequests/approval",
			"certificatesigningrequests/status",
		]
		verbs: [
			"get",
			"list",
			"watch",
			"update",
			"patch",
		]
	}, {
		apiGroups: ["certificates.k8s.io"]
		resources: ["signers"]
		verbs: ["*"]
		resourceNames: [
			"open-cluster-management.io/proxy-agent-signer",
			"kubernetes.io/kube-apiserver-client",
		]
	}, {
		apiGroups: [""]
		resources: [
			"namespaces",
			"secrets",
			"pods",
			"pods/portforward",
		]
		verbs: ["*"]
	}, {
		apiGroups: [""]
		resources: [
			"serviceaccounts",
			"services",
		]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}, {
		apiGroups: ["apps"]
		resources: ["deployments"]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}, {
		apiGroups: ["rbac.authorization.k8s.io"]
		resources: [
			"roles",
			"rolebindings",
		]
		verbs: [
			"get",
			"list",
			"watch",
			"create",
			"update",
			"patch",
		]
	}, {
		apiGroups: ["work.open-cluster-management.io"]
		resources: ["manifestworks"]
		verbs: [
			"get",
			"list",
			"watch",
			"create",
			"update",
			"patch",
			"delete",
		]
	}, {
		apiGroups: ["coordination.k8s.io"]
		resources: ["leases"]
		verbs: ["*"]
	}, {
		apiGroups: [""]
		resources: [
			"configmaps",
			"secrets",
		]
		verbs: ["*"]
	}, {
		apiGroups: ["apps"]
		resources: ["replicasets"]
		verbs: ["get"]
	}, {
		apiGroups: [
			"",
			"events.k8s.io",
		]
		resources: ["events"]
		verbs: [
			"create",
			"patch",
			"update",
		]
	}, {
		// Allow cluster-proxy hub controller to run with addon-framwork
		apiGroups: [""]
		resources: [
			"configmaps",
			"secrets",
		]
		verbs: ["*"]
	}, {
		// Allow cluster-proxy hub controller to get managed cluster image registries
		apiGroups: ["imageregistry.open-cluster-management.io"]
		resources: [
			"managedclusterimageregistries",
			"managedclusterimageregistries",
		]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}, {
		// Allow cluster-proxy to do impersonation
		// Needs to create a clusterrole for the addon-agent to create tokenreview to hub
		// Although hub side doesn't need to create token view, it still requires the tokenreview create permission
		apiGroups: ["rbac.authorization.k8s.io"]
		resources: [
			"clusterroles",
			"clusterrolebindings",
		]
		verbs: [
			"create",
			"get",
			"list",
			"watch",
			"delete",
		]
	}, {
		apiGroups: ["authentication.k8s.io"]
		resources: ["tokenreviews"]
		verbs: ["create"]
	}, {
		apiGroups: ["multicluster.x-k8s.io"]
		resources: ["clusterprofiles"]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}, {
		apiGroups: ["multicluster.x-k8s.io"]
		resources: ["clusterprofiles/status"]
		verbs: [
			"update",
			"patch",
		]
	}]
}

clusterProxyClustersetbindingObject: {
	// Source: cluster-proxy/templates/clustersetbinding.yaml
	apiVersion: "cluster.open-cluster-management.io/v1beta2"
	kind:       "ManagedClusterSetBinding"
	metadata: {
		name:      "global"
		namespace: "open-cluster-management-addon"
	}
	spec: clusterSet: "global"
}

clusterProxyManagedproxyconfigurationObject: {
	// Source: cluster-proxy/templates/managedproxyconfiguration.yaml
	apiVersion: "proxy.open-cluster-management.io/v1alpha1"
	kind:       "ManagedProxyConfiguration"
	metadata: name: "cluster-proxy"
	spec: {
		authentication: {
			dump: secrets: {}
			signer: type: "SelfSigned"
		}
		proxyServer: {
			image:     "quay.io/open-cluster-management/cluster-proxy:v0.10.0"
			replicas:  1
			namespace: "open-cluster-management-addon"
			entrypoint: {
				type: "PortForward"
				port: 8091
			}
		}
		proxyAgent: {
			image:    "quay.io/open-cluster-management/cluster-proxy:v0.10.0"
			replicas: 1
			additionalValues: enableImpersonation: "true"
		}
	}
}

clusterProxyManagerDeploymentObject: {
	// Source: cluster-proxy/templates/manager-deployment.yaml
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata: {
		namespace: "open-cluster-management-addon"
		name:      "cluster-proxy-addon-manager"
		labels: component: "cluster-proxy-manager"
	}
	spec: {
		replicas: 1
		selector: matchLabels: {
			"open-cluster-management.io/addon": "cluster-proxy"
			component:                          "cluster-proxy-manager"
		}
		template: {
			metadata: labels: {
				"open-cluster-management.io/addon": "cluster-proxy"
				component:                          "cluster-proxy-manager"
			}
			spec: {
				serviceAccount: "cluster-proxy"
				containers: [{
					name:            "manager"
					image:           "quay.io/open-cluster-management/cluster-proxy:v0.10.0"
					imagePullPolicy: "IfNotPresent"
					command: ["/manager"]
					args: [
						"--leader-elect=true",
						"--signer-secret-namespace=open-cluster-management-addon",
						"--enable-kube-api-proxy=true",
						"--enable-service-proxy=false",
						"--image-pull-policy=IfNotPresent",
						"--feature-gates=ClusterProfileAccessProvider=false",
					]
					securityContext: {
						allowPrivilegeEscalation: false
						capabilities: drop: ["ALL"]
						privileged:             false
						runAsNonRoot:           true
						readOnlyRootFilesystem: true
					}
				}]
			}
		}
	}
}

clusterProxyPlacementObject: {
	// Source: cluster-proxy/templates/placement.yaml
	apiVersion: "cluster.open-cluster-management.io/v1beta1"
	kind:       "Placement"
	metadata: {
		name:      "cluster-proxy-placement"
		namespace: "open-cluster-management-addon"
	}
	spec: clusterSets: ["global"]
}

clusterProxyRolebindingObject: {
	// Source: cluster-proxy/templates/rolebinding.yaml
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "RoleBinding"
	metadata: {
		name:      "open-cluster-management:cluster-proxy:addon-manager"
		namespace: "open-cluster-management-addon"
	}
	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "Role"
		name:     "open-cluster-management:cluster-proxy:addon-manager"
	}
	subjects: [{
		kind:      "ServiceAccount"
		name:      "cluster-proxy"
		namespace: "open-cluster-management-addon"
	}]
}

clusterProxyRoleObject: {
	// Source: cluster-proxy/templates/role.yaml
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "Role"
	metadata: {
		name:      "open-cluster-management:cluster-proxy:addon-manager"
		namespace: "open-cluster-management-addon"
	}
	rules: [{
		apiGroups: [""]
		resources: [
			"services",
			"events",
			"serviceaccounts",
		]
		verbs: ["*"]
	}, {
		apiGroups: ["apps"]
		resources: [
			"deployments",
			"deployments/scale",
		]
		verbs: ["*"]
	}, {
		apiGroups: [""]
		resources: ["configmaps"]
		verbs: [
			"get",
			"create",
			"update",
			"patch",
		]
	}, {
		apiGroups: ["coordination.k8s.io"]
		resources: ["leases"]
		verbs: [
			"get",
			"create",
			"update",
			"patch",
		]
	}]
}

clusterProxyServiceaccountObject: {
	// Source: cluster-proxy/templates/serviceaccount.yaml
	apiVersion: "v1"
	kind:       "ServiceAccount"
	metadata: {
		name:      "cluster-proxy"
		namespace: "open-cluster-management-addon"
	}
}

managedServiceaccountClustermanagementaddonObject: {
	// Source: managed-serviceaccount/templates/clustermanagementaddon.yaml
	apiVersion: "addon.open-cluster-management.io/v1alpha1"
	kind:       "ClusterManagementAddOn"
	metadata: name: "managed-serviceaccount"
	spec: {
		addOnMeta: {
			displayName: "managed-serviceaccount"
			description: "managed-serviceaccount"
		}
		installStrategy: {
			placements: [{
				name:      "global"
				namespace: "open-cluster-management-addon"
				rolloutStrategy: type: "All"
			}]
			type: "Placements"
		}
		supportedConfigs: [{
			group:    "addon.open-cluster-management.io"
			resource: "addondeploymentconfigs"
		}]
	}
}

managedServiceaccountClusterrolebindingObject: {
	// Source: managed-serviceaccount/templates/clusterrolebinding.yaml
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRoleBinding"
	metadata: name: "open-cluster-management:managed-serviceaccount:addon-manager"
	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "ClusterRole"
		name:     "open-cluster-management:managed-serviceaccount:addon-manager"
	}
	subjects: [{
		kind:      "ServiceAccount"
		name:      "managed-serviceaccount"
		namespace: "open-cluster-management-addon"
	}]
}

managedServiceaccountClusterroleObject: {
	// Source: managed-serviceaccount/templates/clusterrole.yaml
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRole"
	metadata: name: "open-cluster-management:managed-serviceaccount:addon-manager"
	rules: [{
		apiGroups: ["cluster.open-cluster-management.io"]
		resources: ["managedclusters"]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}, {
		apiGroups: ["addon.open-cluster-management.io"]
		resources: ["clustermanagementaddons"]
		verbs: [
			"get",
			"list",
			"watch",
			"patch",
		]
	}, {
		apiGroups: ["addon.open-cluster-management.io"]
		resources: ["clustermanagementaddons/finalizers"]
		verbs: ["update"]
	}, {
		apiGroups: ["addon.open-cluster-management.io"]
		resources: ["managedclusteraddons"]
		verbs: [
			"get",
			"list",
			"watch",
			"create",
			"update",
			"patch",
			"delete",
		]
	}, {
		apiGroups: ["addon.open-cluster-management.io"]
		resources: ["managedclusteraddons/status"]
		verbs: [
			"update",
			"patch",
		]
	}, {
		apiGroups: ["addon.open-cluster-management.io"]
		resources: ["managedclusteraddons/finalizers"]
		verbs: ["update"]
	}, {
		apiGroups: ["addon.open-cluster-management.io"]
		resources: ["addondeploymentconfigs"]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}, {
		apiGroups: ["authentication.open-cluster-management.io"]
		resources: [
			"managedserviceaccounts",
			"managedserviceaccounts/status",
		]
		verbs: [
			"get",
			"list",
			"watch",
			"update",
			"patch",
		]
	}, {
		apiGroups: ["certificates.k8s.io"]
		resources: ["certificatesigningrequests"]
		verbs: [
			"get",
			"list",
			"watch",
		]
	}, {
		apiGroups: ["certificates.k8s.io"]
		resources: [
			"certificatesigningrequests/approval",
			"certificatesigningrequests/status",
		]
		verbs: ["update"]
	}, {
		apiGroups: ["certificates.k8s.io"]
		resources: ["signers"]
		verbs: [
			"approve",
			"sign",
		]
		resourceNames: ["kubernetes.io/kube-apiserver-client"]
	}, {
		apiGroups: [""]
		resources: ["secrets"]
		verbs: [
			"get",
			"list",
			"watch",
			"create",
			"update",
		]
	}, {
		apiGroups: [""]
		resources: [
			"configmaps",
			"events",
		]
		verbs: [
			"get",
			"create",
			"update",
			"patch",
		]
	}, {
		apiGroups: ["rbac.authorization.k8s.io"]
		resources: [
			"roles",
			"rolebindings",
		]
		verbs: [
			"get",
			"create",
			"update",
		]
	}, {
		apiGroups: ["work.open-cluster-management.io"]
		resources: ["manifestworks"]
		verbs: [
			"get",
			"list",
			"watch",
			"create",
			"update",
			"patch",
		]
	}, {
		apiGroups: ["coordination.k8s.io"]
		resources: ["leases"]
		verbs: [
			"get",
			"list",
			"watch",
			"create",
			"update",
			"patch",
		]
	}]
}

managedServiceaccountClustersetbindingObject: {
	// Source: managed-serviceaccount/templates/placement.yaml
	apiVersion: "cluster.open-cluster-management.io/v1beta2"
	kind:       "ManagedClusterSetBinding"
	metadata: {
		name:      "global"
		namespace: "open-cluster-management-addon"
	}
	spec: clusterSet: "global"
}

managedServiceaccountManagerDeploymentObject: {
	// Source: managed-serviceaccount/templates/manager-deployment.yaml
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata: {
		namespace: "open-cluster-management-addon"
		name:      "managed-serviceaccount-addon-manager"
	}
	spec: {
		replicas: 1
		selector: matchLabels: "open-cluster-management.io/addon": "managed-serviceaccount"
		template: {
			metadata: labels: "open-cluster-management.io/addon": "managed-serviceaccount"
			spec: {
				serviceAccount: "managed-serviceaccount"
				containers: [{
					name:            "manager"
					image:           "quay.io/open-cluster-management/managed-serviceaccount:v0.10.0"
					imagePullPolicy: "IfNotPresent"
					command: [
						"/msa",
						"manager",
					]
					args: [
						"--deploy-mode=Deployment",
						"--agent-image-name=quay.io/open-cluster-management/managed-serviceaccount:v0.10.0",
						"--feature-gates=EphemeralIdentity=false,ClusterProfileCredSyncer=false",
					]
				}]
			}
		}
	}
}

managedServiceaccountPlacementObject: {
	// Source: managed-serviceaccount/templates/placement.yaml
	apiVersion: "cluster.open-cluster-management.io/v1beta1"
	kind:       "Placement"
	metadata: {
		name:      "global"
		namespace: "open-cluster-management-addon"
	}
	spec: {
		clusterSets: ["global"]
		tolerations: [{
			key:      "cluster.open-cluster-management.io/unreachable"
			operator: "Equal"
		}, {
			key:      "cluster.open-cluster-management.io/unavailable"
			operator: "Equal"
		}]
	}
}

managedServiceaccountServiceaccountObject: {
	// Source: managed-serviceaccount/templates/serviceaccount.yaml
	apiVersion: "v1"
	kind:       "ServiceAccount"
	metadata: {
		name:      "managed-serviceaccount"
		namespace: "open-cluster-management-addon"
	}
}
