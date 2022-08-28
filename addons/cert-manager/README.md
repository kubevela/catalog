# cert-manager

cert-manager adds certificates and certificate issuers as resource types in Kubernetes clusters, and simplifies the process of obtaining, renewing and using those certificates.

It can issue certificates from a variety of supported sources, including Let's Encrypt, HashiCorp Vault, and Venafi as well as private PKI, and it ensures certificates remain valid and up to date, attempting to renew certificates at an appropriate time before expiry.

## ACME: Auto-Acquire Wildcard TLS Certificates with Cloudflare DNS01 Challenge

In this example, you will:

- enable addon and fill some credentials
- get a valid wildcard TLS certificate from Let' Encrypt using Cloudflare domains, with auto renewal before expiry
- use this certificate on your site with Traefik

Let's get started!

Enable this addon. The parameters are a bit complicated. Please Make sure you looked at the parameters of this addon. There are descriptions about every parameter.

Note: use `staging=true` to use Let's Encrypt staging API, otherwise you can be rate-limited and banned. Also pay special attention to `dns01.namespace`. This needs to be the same namespace as your service and ingress.

```console
vela addon enable cert-manager                      \
    staging=true                                    \
    dns01.namespace="default"                       \
    dns01.cloudflare.email="your-email@example.com" \
    dns01.cloudflare.token="your-token-here"        \
    dns01.cloudflare.zone="example.com"             \
    dns01.cloudflare.domain="example.com"
```

And... That' all you need to do! A wildcard certificate is on the way.

If you want to check the progress, you can review the logs:

```console
# Choose the pod named as cert-manager-cert-manager-xxx
$ vela logs addon-cert-manager -n vela-system

# This indicates you need to wait a few more minutes.
cert-manager/challenges "msg"="propagation check failed" "error"="DNS record for \"example.com\" not yet propagated" "dnsName"="example.com" "resource_kind"="Challenge" "resource_name"="cloudflare-certificate-jcsn8-34526-234543" "resource_namespace"="cert-manager" "resource_version"="v1" "type"="DNS-01"

# This indicates it has succeed in acquiring a certificate!
cert-manager/certificaterequests-issuer-acme/sign "msg"="certificate issued" "related_resource_kind"="Order" "related_resource_name"="cloudflare-certificate-jcsn8-34526-234543" "related_resource_namespace"="cert-manager" "related_resource_version"="v1" "resource_kind"="CertificateRequest" "resource_name"="cloudflare-certificate-jcsn8" "resource_namespace"="cert-manager" "resource_version"="v1"
```

It is time to use your brand-new certificate to a service!

> TODO(charlie0129): I will update this later, with an example to use cert-manager + traefik + nginx to host a TLS-secured website.
