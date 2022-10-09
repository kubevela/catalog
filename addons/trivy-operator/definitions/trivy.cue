import (
	"vela/op"
	"strings"
	"strconv"
	"regexp"
)

"trivy-check": {
	type: "workflow-step"
	annotations: {}
	labels: {}
	description: ""
}
template: {
	req: op.#HTTPGet & {
		url: parameter.url
	}
	data: req.response.body

	regexs: [ for val in parameter.level {
		reg:   "so_vulnerabilities{.+" + parameter.image + "\",severity=\"" + val + "\"} (?P<type>.)"
		level: val
	}]

	collect: op.#Steps & {
		value: [
			for r in regexs {
				if regexp.FindNamedSubmatch(r.reg, data) == _|_ {
					wait:    op.#ConditionalWait & {continue: false}
					message: "Trivy: no result found for image " + parameter.image
				}

				if regexp.FindNamedSubmatch(r.reg, data) != _|_ {
					reg: regexp.FindNamedSubmatch(r.reg, data)
					str: reg.type
					num: strconv.ParseInt(str, 10, 32)
					if num > 0 {
						detailReg: "trivy_vulnerabilities{.+" + parameter.image + ".+severity=\"" + r.level + "\",vulnerabilityId=\"(?P<cve>.+)\"}"
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
						message: "Trivy: " + r.level + " Vulnerabilities found: " + str + ", image: " + parameter.image + "\nCVE Found:\n" + detailMsg
					}
					if num == 0 {
						message: "Trivy: No " + r.level + " Vulnerabilities found in image:" + parameter.image
					}
				}
			}]
	}

	message: op.#Steps & {
		arr: [ for val in collect.value {
			val.message
		}]
		data: strings.Join(arr, "\n")
	}

	parameter: {
		url:   string
		image: string
		level: *["CRITICAL"] | [...string]
	}
}
