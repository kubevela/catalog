parameter: {
	// +usage=Image of the render Job: Go plus defkit-render
	image: *"oamdev/defkit-render:v0.1.0" | string
	// +usage=Repositories VelaUX offers when adding a module; a module can still come from anywhere
	repositories: *[{
		name:        "KubeVela definitions"
		git:         "https://github.com/kubevela/vela-go-definitions"
		version:     "main"
		description: "KubeVela's built-in definitions, written with DefKit"
	}] | [...#Repository]
}

// #Repository names its module by git or by ref, never both.
#Repository: ({git!: string, ref?: _|_, ...} | {ref!: string, git?: _|_, ...}) & {
	name:         string
	git?:         string
	ref?:         string
	version?:     string
	description?: string
}
