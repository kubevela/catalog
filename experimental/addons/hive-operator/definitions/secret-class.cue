"secret-class": {
	alias: ""
	annotations: {}
	attributes: workload: type: "autodetects.core.oam.dev"
	description: "secret class component"
	labels: {}
	type: "component"
}

template: {
	output: {
		kind:       "SecretClass"
		apiVersion: "secrets.stackable.tech/v1alpha1"
		metadata: {
			name: context.name
		}
		spec: {
			backend: parameter.backend
		}
	}
	parameter: {
		//+usage=Configure backend.
		backend: {
            //+usage=Configure k8sSearch.
            k8sSearch: *null | {...}
            //+usage=Configure autoTls.
            autoTls: *null | {...}
        }
	}
}
