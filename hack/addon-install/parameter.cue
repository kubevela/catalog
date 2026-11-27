// +usage=Install the chart. Set false for the definitions alone, beside a tool you already run another way
// +ui:advanced
// +ui:section=Install
// +ui:label=Install the Chart
chartInstall: *true | bool
// +usage=What installs the chart: vela (the built-in helmchart component, the default), flux (a HelmRelease; needs Flux 2.3 or later running) or argo (an Argo CD Application; needs Argo CD running)
// +ui:advanced
// +ui:section=Install
// +ui:label=Install With
installWith: *"vela" | "flux" | "argo"
// +usage=Helm release to install or take over, if not the addon's own name. Upgrading from an addon that installed through the fluxcd addon, name its release <namespace>-<addon name>, such as cert-manager-cert-manager for cert-manager in its default namespace
// +ui:advanced
// +ui:section=Install
// +ui:label=Release Name
releaseName?: =~"^[a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*$" & =~"^.{1,53}$"
// +usage=Override the pinned chart, at your own risk: version takes another chart version, repoURL a mirror of the chart repository
// +ui:advanced
// +ui:section=Install
// +ui:label=Chart Override
chart?: {
	// +usage=Chart version to install instead of the one the addon pins, at or above the addon's minimum and, where the addon offers majors, within the chosen one
	// +ui:placeholder=The version the addon pins
	// +ui:label=Chart Version
	version?: string
	// +usage=Chart repository to install from instead of the chart's own, such as a mirror
	// +ui:label=Repository URL
	// +ui:placeholder=https://charts.example.com/mirror
	repoURL?: string
}
// +usage=Free-form override of the chart's values, applied over what the parameters above set. Nothing checks them, so use it at your own risk
// +ui:hidden
// +ui:label=Overrides
values?: {...}
