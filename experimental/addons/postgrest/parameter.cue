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
	// +usage=Type Postgres URL in the format:- postgres://user:password@localhost:5432/postgres.	
	PGRST_DB_URI: *"postgres://user:password@localhost:5432/postgres" | string
}
