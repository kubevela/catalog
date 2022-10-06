parameter: {
        //+usage=Deploy to specified clusters. Leave empty to deploy to all clusters.
        clusters?: [...string]
        //+usage=Namespace to deploy to, default to mongodb-operator
        namespace: *"mongodb-operator" | string
}
