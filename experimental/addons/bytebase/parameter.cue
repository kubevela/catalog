// parameter.cue is used to store addon parameters.
//
// You can use these parameters in template.cue or in resources/ by 'parameter.myparam'
//
// For example, you can use parameters to allow the user to customize
// container images, ports, and etc.
parameter: {
	// +usage=Custom parameter description.
	namespace: *"bytebase" | string
	clusters?: [...string]
	// +usage=Set bytebasePort to run bytebase on that port in Pod.
	bytebasePort: *443 | int
	// +usage=To configure external URL visit: https://www.bytebase.com/docs/get-started/install/external-url.
	externalURL: *"https://bytebase.example.com" | string
	// +usage=Version of bytebase.
	version: *"1.7.0" | string
	// +usage=Helm Chart Version.
	chartVersion: *"1.0.2" | string
	// +usage=To configure postgres URL visit: https://www.bytebase.com/docs/get-started/install/external-postgres.
	postgresURL: *null | string
}
