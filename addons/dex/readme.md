# dex

This addon provides dex login for VelaUX.

Dex is an identity service that uses [OpenID Connect](https://openid.net/connect/) to drive authentication for other apps.
Dex acts as a portal to other identity providers through [“connectors.”](https://dexidp.io/docs/connectors/) This lets Dex defer authentication to LDAP servers, SAML providers, or established identity providers like GitHub, Google, and Active Directory. Clients write their authentication logic once to talk to Dex, then Dex handles the protocols for a given backend.

Please refer to [Dex's Website](https://dexidp.io/docs/) for more details.

## Versions

* 0.7.0
    * upgrade the dex chart to [v 0.15.3](https://artifacthub.io/packages/helm/dex/dex/0.15.3) that deploys dex `2.37.0`
    * add support of [Dex OAuth connector](https://dexidp.io/docs/connectors/oauth/)
