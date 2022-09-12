parameter: {
        //+usage=Deploy to specified clusters. Leave empty to deploy to all clusters.
        clusters?: [...string]
        //+usage=Namespace to deploy to, defaults to mongodb
        namespace: *"mongodb" | string
}
