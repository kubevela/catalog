package main

parameter: {
	//+usage=Namespace to deploy to, defaults to vela-system
	namespace?: string
	//+usage=Deploy to specified clusters. Leave empty to deploy to all clusters.
	clusters?: [...string]
	"orchestrator.persistence.enabled": *false | bool
}
