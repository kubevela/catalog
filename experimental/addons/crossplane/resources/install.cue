// Installs an addon's Helm chart with KubeVela, Flux or Argo CD.
// Synced into addons/<addon>/resources/install.cue by hack/addon-install/sync.sh: edit hack/addon-install/install.cue.
//
// The addon's template sets _install.name, .namespace, .chart and .values, and lists
// _install.components and _install.policies in its Application's (by comprehension:
// addons compile without the CUE upgrade that allows list +).
package main

import (
	"encoding/yaml"
	"regexp"
	"strconv"
)

_install: {
	// name is the component's and the Helm release's.
	name:      string
	namespace: string
	chart: {
		source:  string
		repoURL: string
		version: string
		// minVersion is the oldest chart the addon's values and definitions work with, if any.
		minVersion?: string
		// major is the only major version the addon's definitions suit, when it ships a set per major.
		major?: int
	}
	// values are the addon's own, as defaults the user's values can override.
	values: {...}
	// keepCRDs leaves the chart's CRDs, and every custom resource in them, when the vela installer uninstalls.
	keepCRDs: *true | bool

	// Aliases: inside a component, name and namespace are the component's own fields.
	let N = name

	// The release keeps the component's name unless the user names an existing one to take over.
	let R = [if parameter.releaseName != _|_ {parameter.releaseName}, N][0]
	let NS = namespace

	_with: parameter.installWith
	_chart: {
		source: chart.source
		repoURL: [if parameter.chart.repoURL != _|_ {parameter.chart.repoURL}, chart.repoURL][0]
		version: [if parameter.chart.version != _|_ {parameter.chart.version}, chart.version][0]
	}
	_values: values
	if parameter.values != _|_ {
		_values: parameter.values
	}

	// Compared by number: major, minor, patch. A pre-release counts as its release.
	let Semver = "^v?([0-9]+)\\.([0-9]+)\\.([0-9]+)(-[0-9A-Za-z.-]+)?(\\+[0-9A-Za-z.-]+)?$"
	if parameter.chartInstall && (chart.minVersion != _|_ || chart.major != _|_) {
		if _chart.version !~ Semver {
			_refuseVersion: "chart.version \(_chart.version) is not a version like \(chart.version)": true & false
		}
		if _chart.version =~ Semver {
			_have: [for x in regexp.FindSubmatch(Semver, _chart.version)[1:4] {strconv.Atoi(x)}]
			if chart.major != _|_ if _have[0] != chart.major {
				_refuseVersion: "chart.version \(_chart.version) is major \(_have[0]), but major \(chart.major) is selected: set major to match": true & false
			}
			if chart.minVersion != _|_ {
				_min: [for x in regexp.FindSubmatch(Semver, chart.minVersion)[1:4] {strconv.Atoi(x)}]
				_older: _have[0] < _min[0] || (_have[0] == _min[0] && (_have[1] < _min[1] || (_have[1] == _min[1] && _have[2] < _min[2])))
				if _older {
					_refuseVersion: "chart.version \(_chart.version) is older than \(chart.minVersion), the oldest this addon supports": true & false
				}
			}
		}
	}

	// Addon templates take no errs, so a refusal is a conflict whose path is the message.
	if !parameter.chartInstall && parameter.installWith != "vela" {
		_refuse: "installWith has no effect with chartInstall false, which installs no chart: set one": true & false
	}

	// Every installer keeps the release in the target namespace under the same name, so switching installer adopts it.
	components: [
		if parameter.chartInstall && _with == "vela" {
			name: N
			type: "helmchart"
			properties: {
				chart: _chart
				release: {name: R, namespace: NS}
				values: _values
			}
		},
		if parameter.chartInstall && _with == "flux" {
			name: N
			type: "k8s-objects"
			properties: objects: [{
				apiVersion: "source.toolkit.fluxcd.io/v1"
				kind:       "HelmRepository"
				metadata: {name: N, namespace: "vela-system"}
				spec: {
					url:      _chart.repoURL
					interval: "1h"
					if _chart.repoURL =~ "^oci://" {type: "oci"}
				}
			}, {
				apiVersion: "helm.toolkit.fluxcd.io/v2"
				kind:       "HelmRelease"
				metadata: {name: N, namespace: "vela-system"}
				spec: {
					interval:         "10m"
					releaseName:      R
					targetNamespace:  NS
					storageNamespace: NS
					chart: spec: {
						chart:   _chart.source
						version: _chart.version
						sourceRef: {kind: "HelmRepository", name: N, namespace: "vela-system"}
					}
					install: {createNamespace: true, crds: "CreateReplace"}
					upgrade: crds: "CreateReplace"
					values: _values
				}
			}]
		},
		if parameter.chartInstall && _with == "argo" {
			name: N
			type: "k8s-objects"
			properties: objects: [{
				apiVersion: "argoproj.io/v1alpha1"
				kind:       "Application"
				metadata: {
					name:      N
					namespace: "argocd"
					// Without it, deleting the Application leaves everything it applied running. Argo CD
					// deletes the chart's CRDs too, unless they carry helm.sh/resource-policy: keep.
					finalizers: ["resources-finalizer.argocd.argoproj.io"]
				}
				spec: {
					project: "default"
					source: {
						repoURL:        _chart.repoURL
						chart:          _chart.source
						targetRevision: _chart.version
						helm: {releaseName: R, values: yaml.Marshal(_values)}
					}
					destination: {server: "https://kubernetes.default.svc", namespace: NS}
					syncPolicy: {
						automated: {prune: true, selfHeal: true}
						syncOptions: ["CreateNamespace=true", "ServerSideApply=true"]
					}
				}
			}]
		},
	]
	// KubeVela deletes what it applied when the addon is disabled, CRDs included, and every
	// custom resource with them, unless this policy keeps them.
	policies: [
		if parameter.chartInstall && _with == "vela" && keepCRDs {
			name: "\(N)-keep-crds"
			type: "garbage-collect"
			properties: rules: [{
				selector: {componentNames: [N], resourceTypes: ["CustomResourceDefinition"]}
				strategy: "never"
			}]
		},
	]
}
