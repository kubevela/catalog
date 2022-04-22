output: {
        type: "helm"
        properties: {
                repoType: "helm"
                url:      "https://downloads.apache.org/flink/flink-kubernetes-operator-0.1.0/"
                chart:    "flink-kubernetes-operator"
                version:  "0.1.0"
                values: {

                        webhook: {
                                create: parameter["webhook.create"]
                                }

                        image: {
                                repository: parameter["image.repository"]
                                tag: parameter["image.tag"]
                        }

                        jobServiceAccount: {
                                create: parameter["jobServiceAccount.create"]
                        }

                        operatorServiceAccount: {
                        name: "flink-kubernetes-operator"
                        }
                }
        }
}
