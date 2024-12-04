package main

deploymentResources: {
	limits: {
		cpu:    "1000m"
		memory: "1Gi"
	}
	requests: {
		cpu:    "100m"
		memory: "64Mi"
	}
}
