// parameter.cue is used to store addon parameters.
//
// You can use these parameters in template.cue or in resources/ by 'parameter.myparam'
//
// For example, you can use parameters to allow the user to customize
// container images, ports, and etc.
parameter: {
	// +usage=Custom parameter description
	namespace: *"prod" | string
	clusters?: [...string]
	// +usage=Postgres URL.	
	PGRST_DB_URI: *"postgres://foo_user:R56FOCgVHSpDq3rFuX8qlmX4rMKeZHjCVOV7rxKQU4wNAlQfwNIsmM01g6pcpIbE@localhost:5432/postgres" | string
	// +usage=Proxy server URI for Postgrest..
	PGRST_OPENAPI_SERVER_PROXY_URI: *"http://localhost:3000" | string
}
