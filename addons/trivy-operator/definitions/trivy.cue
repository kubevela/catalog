import (
	"vela/op"
	"strings"
	"strconv"
	"regexp"
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
	req: op.#HTTPGet & {
		url: parameter.url
	}
	data: req.response.body

	regex: "so_vulnerabilities{.+" + parameter.image + "\",severity=\"" + parameter.level + "\"} (?P<type>.)"

	result: op.#Steps & {
		if regexp.FindNamedSubmatch(regex, data) == _|_ {
			wait:    op.#ConditionalWait & {continue: false}
			message: "Trivy: no result found for image " + parameter.image
		}

		if regexp.FindNamedSubmatch(regex, data) != _|_ {
			reg: regexp.FindNamedSubmatch(regex, data)
			str: reg.type
			num: strconv.ParseInt(str, 10, 32)
			if num > 0 {
				detailReg: "trivy_vulnerabilities{.+" + parameter.image + ".+severity=\"" + parameter.level + "\",vulnerabilityId=\"(?P<cve>.+)\"}"
				detailMsg: *"" | string
				if regexp.FindAllNamedSubmatch(detailReg, data, -1) != _|_ {
					cveList: regexp.FindAllNamedSubmatch(detailReg, data, -1)
					deDupArray: [
						for val in [
							for i, vi in cveList {
								for j, vj in cveList if j < i && vi.cve == vj.cve {
									_ignore: true
								}
								vi
							},
						] if val._ignore == _|_ {
							val
						},
					]
					strArr: [ for val in deDupArray {
						"https://cve.report/" + val.cve
					}]
					detailMsg: strings.Join(strArr, "\n")
				}
				message: "Trivy: " + parameter.level + " Vulnerabilities found: " + str + ", image: " + parameter.image + "\nCVE Found:\n" + detailMsg
			}
			if num == 0 {
				message: "Trivy: No " + parameter.level + " Vulnerabilities found in image:" + parameter.image
			}
		}

	}
	parameter: {
		url:   *"http://trivy-system-trivy-system-helm-trivy-operator.trivy-system.svc.cluster.local:9115/metrics" | string
		image: string
		level: *"CRITICAL" | string
	}
}
