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

	arr: ["so_vulnerabilities{exported_namespace=\"default\",image=\"", parameter.image, "\",severity=\"CRITICAL\"} "]
	prefix: strings.Join(arr, "")
	regex:  prefix + "(?P<type>.)"

	result: op.#Steps & {
		if regexp.Find(regex, data) == _|_ {
			message: "No critical vulnerabilities found"
		}
		if regexp.Find(regex, data) != _|_ {
			reg: regexp.Find(regex, data)
			str: strings.TrimPrefix(reg, prefix)
			num: strconv.ParseInt(str, 10, 32)
		}
		if result.num > 0 {
			message: "Trivy: CRITICAL Vulnerabilities found: " + result.str
			fail:    op.#Fail & {
				message: result.message
			}
		}
	}

	parameter: {
		url:   string
		image: string
	}
}
