package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	spec: {
		components: [ if parameter["enableImpersonation"] {additionalPrivileges}] + [apiserver, velaux]
	}
}
