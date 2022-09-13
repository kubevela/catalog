parameter: {
        //+usage=Deploy to specified clusters. Leave empty to deploy to all clusters.
        clusters?: [...string]
        //+usage=Namespace to deploy to, default to mongodb
        namespace: *"mongodb" | string
        //+usage=Enable persistent store, default to false
        persistenceEnabled: *false | bool
        //+usage=StorageClass for persistent store
        persistenceStorageClass: string
}
