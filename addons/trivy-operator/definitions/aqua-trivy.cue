import (
	"vela/op"
	"strings"
	"encoding/yaml"
)

"trivy-check": {
	type: "workflow-step"
	annotations: {
		"definition.oam.dev/example-url": "https://raw.githubusercontent.com/kubevela/catalog/master/examples/trivy-operator/trivy-check-example.yaml"
	}
	labels: {}
	description: ""
}
template: {
	findResource: op.#Steps & {
		resourceType: *parameter.resource.kind | string
		resourceName: *parameter.resource.name | string
		if parameter.resource.kind == "Deployment" {
			deployment: op.#Read & {
				value: {
					apiVersion: "apps/v1"
					kind:       "Deployment"
					metadata: {
						name:      parameter.resource.name
						namespace: context.namespace
					}
				}
			}
			wait: op.#ConditionalWait & {
				continue: deployment.value.status != _|_ && deployment.value.status.updatedReplicas == deployment.value.status.availableReplicas && deployment.value.status.observedGeneration == deployment.value.metadata.generation
			}
			rs: op.#List & {
				resource: {
					apiVersion: "apps/v1"
					kind:       "ReplicaSet"
				}
				filter: {
					namespace:      context.namespace
					matchingLabels: deployment.value.spec.selector.matchLabels
				}
			}
			resourceType: "ReplicaSet"
			if rs.list != _|_ {
				if rs.list.items != _|_ {
					for _, item in rs.list.items {
						if item.status.replicas == deployment.value.status.availableReplicas {
							resourceName: item.metadata.name
						}
					}
				}
			}
		}
	}

	findVulns: op.#Steps & {
		scanPod: op.#List & {
			resource: {
				apiVersion: "v1"
				kind:       "Pod"
			}
			filter: {
				namespace: "trivy-system"
				matchingLabels: {
					"trivy-operator.resource.kind": findResource.resourceType
					"trivy-operator.resource.name": findResource.resourceName
				}
			}
		}
		wait: op.#ConditionalWait & {
			continue: len(scanPod.list.items) == 0
		}
		vulns: op.#List & {
			resource: {
				apiVersion: "aquasecurity.github.io/v1alpha1"
				kind:       "VulnerabilityReport"
			}
			filter: {
				namespace: context.namespace
				matchingLabels: {
					"trivy-operator.resource.kind": findResource.resourceType
					"trivy-operator.resource.name": findResource.resourceName
				}
			}
		}
	}

	trivyLevel: strings.Join(parameter.level, ",")
	result: {
		report: {...}
		if findVulns.vulns.list != _|_ && findVulns.vulns.list.items != _|_ for v in findVulns.vulns.list.items {
			report: "\(v.report.artifact.repository):\(v.report.artifact.tag)": {
				summary: v.report.summary
				if parameter.showDetail {
					details: [ for vul in v.report.vulnerabilities if strings.Contains(trivyLevel, vul.severity) {
						"\(vul.severity) \(vul.vulnerabilityID)": {
							link:     vul.primaryLink
							title:    vul.title
							resource: vul.resource
						}
					}]
				}
			}
		}

		if len(report) > 0 {
			message: "Trivy Scan Result: \n\n" + yaml.Marshal(report)
		}
		if len(report) == 0 {
			message: "No processed trivy scanning job found for \(findResource.resourceType) \(findResource.resourceName)"
		}
	}
	parameter: {
		level:      *["CRITICAL"] | [...string]
		showDetail: *true | bool
		resource: {
			kind: *"Deployment" | "StatefulSet" | "ReplicaSet" | "Job" | "Pod" | "DaemonSet" | string
			name: string
		}
	}
}
