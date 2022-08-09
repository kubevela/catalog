parameter: {
        // +usage=Specify if install the CRDs before installing cert-manager or not
        "installCRDs": *true | bool
        //+usage=Deploy to specified clusters. Leave empty to deploy to all clusters.
        clusters?: [...string]
        //+usage=Namespace to deploy to, defaults to cert-manager
        namespace: *"cert-manager" | string
}
