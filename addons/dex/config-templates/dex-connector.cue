import (
	"encoding/json"
)

metadata: {
	scope:       "system"
	name:        "dex-connector"
	alias:       "Dex Connector"
	description: "Configure the connectors for the Dex"
	sensitive:   false
}

template: {
	output: {
		apiVersion: "v1"
		kind:       "Secret"
		metadata: {
			name:      context.name
			namespace: context.namespace
			labels: {
				"config.oam.dev/sub-type": parameter.type
			}
		}
		type: "Opaque"

		if parameter.type == "github" && parameter.github != _|_ {
			stringData: github: json.Marshal(parameter.github)
		}
		if parameter.type == "ldap" && parameter.ldap != _|_ {
			stringData: ldap: json.Marshal(parameter.ldap)
		}
		if parameter.type == "oidc" && parameter.oidc != _|_ {
			stringData: oidc: json.Marshal(parameter.oidc)
		}
		if parameter.type == "gitlab" && parameter.gitlab != _|_ {
			stringData: gitlab: json.Marshal(parameter.gitlab)
		}
		if parameter.type == "saml" && parameter.saml != _|_ {
			stringData: saml: json.Marshal(parameter.saml)
		}
		if parameter.type == "google" && parameter.google != _|_ {
			stringData: google: json.Marshal(parameter.google)
		}
		if parameter.type == "oauth" && parameter.oauth != _|_ {
			stringData: oauth: json.Marshal(parameter.oauth)
		}
	}
	parameter: {
		// +usage=Connetor type
		type: *"github" | "ldap" | "gitlab" | "oidc" | "saml" | "google" | "oauth"
		// +usage=GitHub connector
		github?: {
			// +usage=GitHub client ID
			clientID: string
			// +usage=GitHub client secret
			clientSecret: string
			// +usage=GitHub redirect URI
			redirectURI: string
		}
		// +usage=LDAP connector
		ldap?: {
			// +usage=Host and optional port of the LDAP server in the form "host:port".
			host: string
			// +usage=The DN and password for an application service account. The connector uses these credentials to search for users and groups. Not required if the LDAP server provides access for anonymous auth.
			bindDN?: string
			// +usage=The password of the DN
			bindPW?: string
			// +usage=This field is required if the LDAP host is not using TLS (port 389).
			insecureNoSSL: *true | bool
			// +usage=If a custom certificate isn't provide, this option can be used to turn on
			insecureSkipVerify?: bool
			// +usage=If unspecified, connections will use the ldaps:// protocol
			startTLS?: bool
			// +usage=Path to a trusted root certificate file. Default: use the host's root CA.
			rootCA?: string
			// +usage=The attribute to display in the provided password prompt. If unset, will display "Username"
			usernamePrompt?: string
			// +usage=User search maps a username and password entered by a user to a LDAP entry.
			userSearch: {
				// +usage=BaseDN to start the search from. It will translate to the query "(&(objectClass=person)(uid=<username>))".
				baseDN: string
				// +usage=username attribute used for comparing user entries. This will be translated and combined with the other filter as "(<attr>=<username>)".
				username: *"uid" | string
				// +usage=The following three fields are direct mappings of attributes on the user entry. String representation of the user.
				idAttr: *"uid" | string
				// +usage=Attribute to map to Email.
				emailAttr: *"mail" | string
				// +usage=Maps to display name of users. No default value.
				nameAttr: *"uid" | string
				// +usage=Optional filter to apply when searching the directory.
				filter?: string
			}
		}
		// +usage=GitLab connector
		gitlab?: {
			// +usage=default to https://gitlab.com
			baseURL?: string
			// +usage=GitLab client ID
			clientID: string
			// +usage=GitLab client secret
			clientSecret: string
			// +usage=GitLab redirect URI
			redirectURI: string
		}
		// +usage=OIDC connector
		oidc?: {
			// +usage=Canonical URL of the provider, also used for configuration discovery. This value MUST match the value returned in the provider config discovery. See: https://openid.net/specs/openid-connect-discovery-1_0.html#ProviderConfig
			issuer: string
			// +usage=OIDC client ID
			clientID: string
			// +usage=OIDC client secret
			clientSecret: string
			// +usage=OIDC redirect URI
			redirectURI: string
		}
		// +usage=Google connector
		google?: {
			// +usage=Google client ID
			clientID: string
			// +usage=Google client secret
			clientSecret: string
			// +usage=Google redirect URI
			redirectURI: string
		}
		// +usage=SAML connector
		saml?: {
			// +usage=SSO URL used for POST value.
			ssoURL: string
			// +usage=CA to use when validating the signature of the SAML response.
			ca: string
			// +usage=SAML redirect URI
			redirectURI: string
			// +usage=Name of attributes in the returned assertions to map to ID token claims.
			usernameAttr: string
			// +usage=Email of attributes in the returned assertions to map to ID token claims.
			emailAttr: string
		}
		// +usage=OAuth connector
		oauth?: {
			// +usage=OAuth client ID
			clientID: string
			// +usage=OAuth client secret
			clientSecret: string
			// +usage=OAuth redirect URI - for instance [VelaUX address:port]/dex/callback
			redirectURI: string
			// +usage=OAuth token URL
			tokenURL: string
			// +usage=OAuth authorization URL
			authorizationURL: string
			// +usage=OAuth user info URL
			userInfoURL: string
			// +usage=Optional: Specify whether to communicate to Auth provider without validating SSL certificates
			insecureSkipVerify?: bool | *false
			// +usage=Optional: The location of file containing SSL certificates to communicate to Auth provider
			rootCAs?: string
			// +usage=Optional: Configurable keys for user ID look up
			userIDKey?: string | *"username"
			// +usage=Optional: List of scopes to request Auth provider for access user account
			scopes?: [...string]
			// +usage=Auth providers return non-standard user identity profile. Use claimMapping to map those user informations to standard claims:
			claimMapping: {
				// +usage=Optional: Configurable keys for user name look up
				userNameKey?: string | *"name"
				// +usage=Optional: Configurable keys for preferred username look up
				preferredUsernameKey? : string | *"username"
				// +usage=Optional: Configurable keys for user groups look up
				groupsKey?: string
				// +usage=Optional: Configurable keys for email look up
				emailKey?: string 
				// +usage=Configurable keys for email verified look up
				emailVerifiedKey?: string
			}

		}
	}
}
