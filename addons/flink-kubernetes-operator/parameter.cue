parameter: {
        //+usage=Deploy to specified clusters. Leave empty to deploy to all clusters.
        clusters?: [...string]
        //+usage=Namespace to deploy to, defaults to cert-manager
        namespace: *"flink-operator" | string
        // +usage=Specify if create  the webhook or not
        "webhook.create": *false | bool
        // +usage=Specify the image repository
        "image.repository": *"apache/flink-kubernetes-operator" | string
        // +usage=Specify the image tag
        "image.tag": *"latest" | string
        // +usage=Specify if create the sa for job or not
        "jobServiceAccount.create": *false|bool
}
