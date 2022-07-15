netlify: {
        annotations: {}
        attributes: workload: definition: {
                apiVersion: "batch/v1"
                kind:       "Job"
        }
        description: "Netlify component."
        labels: {}
        type: "component"
}

template: {
        output: {
                metadata: {
                        name:      context.name
                        namespace: context.namespace
                }
                apiVersion: "v1"
                kind:       "Secret"
                data: TOKEN: parameter.token
                type: "Opaque"
        }
        outputs: netlify: {
                metadata: {
                        name:      context.name
                        namespace: context.namespace
                }
                spec: {
                        backoffLimit: parameter.backofflimit
                        completions:  parameter.completions
                        parallelism:  parameter.completions
                        template: {
                                metadata: name: context.name
                                spec: {
                                        containers: [{
                                                name: "netlify"
                                                env: [{
                                                        name:  "SITE_NAME"
                                                        value: parameter.sitename
                                                }, {
                                                        name: "TOKEN"
                                                        valueFrom: secretKeyRef: {
                                                                name: "netlify"
                                                                key:  "TOKEN"
                                                        }
                                                }, {
                                                        name:  "REPO_NAME"
                                                        value: parameter.reponame
                                                }, {
                                                        name:  "GIT_REPO"
                                                        value: parameter.gitrepo
                                                }]
                                                image: "oeular/deploy-by-netlify:latest"
                                        }]
                                        restartPolicy: parameter.restartPolicy
                                }
                        }
                }
                apiVersion: "batch/v1"
                kind:       "Job"
        }
        parameter: {
            backofflimit: *5 | int
            completions:  *1 | int
            // +usage=Specify the website name on app.netlify.com
            sitname: *"deploy-from-vela" | string
           // +usage=Specify the token got from app.netlify.com
            token: *"your-own-token-after-base64" | string
           // +usage=Specify the direcotry name for saving the resources from git or other repo supporting git-cli
            reponame: *"oeular.github.io" | string
           // +usage=Specify the repo address your resources of the frontend service  store
            gitrepo: *"https://github.com/oeular/oeular.github.io.git" | string
            restartPolicy: *"OnFailure" | string
        }
}

