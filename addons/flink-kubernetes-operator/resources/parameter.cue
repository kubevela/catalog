parameter: {
        // +usage=Specify the target namespace for installing flink-operator
        "tgtNs": *"vela-system" | string
        // +usage=Specify if create  the webhook or not
        "webhook.create": *false | bool
        // +usage=Specify the image repository
        "image.repository": *"apache/flink-kubernetes-operator" | string
        // +usage=Specify the image tag
        "image.tag": *"latest" | string
        // +usage=Specify if create the sa for job or not
        "jobServiceAccount.create": *false|bool
}
