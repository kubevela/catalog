package main

esOperator: {
	type: "k8s-objects"
	name: "elasticsearch"
	properties: {
		objects: [
			{
				"apiVersion": "operators.coreos.com/v1alpha1"
				"kind":       "Subscription"
				"metadata": {
					"name": "my-elastic-cloud-eck"
				}
				"spec": {
					"channel":         "stable"
					"name":            "elastic-cloud-eck"
					"source":          "operatorhubio-catalog"
					"sourceNamespace": "olm"
				}
			},
		]
	}
}
