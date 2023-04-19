# vela-workflow

Vela-workflow provides the capability to run a standalone workflow. You can check more details in [KubeVela Workflow](https://github.com/kubevela/workflow)

## What is KubeVela Workflow

KubeVela Workflow is an open-source cloud-native workflow project that can use to orchestrate CI/CD process, terraform resources, multi-kubernetes-clusters management and even your own functional calls.

You can install KubeVela Workflow and use it, or import the code as an sdk of an IaC-based workflow engine in your own repository.

*The main differences between KubeVela Workflow and other cloud-native workflows are:*

All the steps in the workflow is based on IaC(Cue): every step has a type for abstract and reuse, the step-type is programmed in CUE language and easy to customize.

**That is to say, you can use atomic capabilities like a function call in every step, instead of just creating a pod.**

## Install

```shell
vela addon enable vela-workflow
```

## Uninstall

```shell
vela addon disable vela-workflow
```

## Try KubeVela Workflow

Run your first WorkflowRun to distribute secrets, build and push your image, and apply the application with the image in the cluster! Image build can take some time, you can use `vela workflow logs build-push-image --step build-push` to check the logs of building.

```yaml
apiVersion: core.oam.dev/v1alpha1
kind: WorkflowRun
metadata:
  name: build-push-image
  namespace: default
spec:
  context:
    image: my-registry/test-image:v2
  workflowSpec:
   steps:
    # or use kubectl create secret generic git-token --from-literal='GIT_TOKEN=<your-token>'
    - name: create-git-secret
      type: export2secret
      properties:
        secretName: git-secret
        data:
          token: <git token>
    # or use kubectl create secret docker-registry docker-regcred \
    # --docker-server=https://index.docker.io/v1/ \
    # --docker-username=<your-username> \
    # --docker-password=<your-password> 
    - name: create-image-secret
      type: export2secret
      properties:
        secretName: image-secret
        kind: docker-registry
        dockerRegistry:
          username: <username>
          password: <password>
    - name: build-push
      type: build-push-image
      inputs:
        - from: context.image
          parameterKey: image
      properties:
        # use your kaniko executor image like below, if not set, it will use default image oamdev/kaniko-executor:v1.9.1
        # kanikoExecutor: gcr.io/kaniko-project/executor:latest
        # you can use context with git and branch or directly specify the context, please refer to https://github.com/GoogleContainerTools/kaniko#kaniko-build-contexts
        context:
          git: github.com/FogDong/simple-web-demo
          branch: main
        # Note that this field will be replaced by the image in inputs
        image: my-registry/test-image:v1
        # specify your dockerfile, if not set, it will use default dockerfile ./Dockerfile
        # dockerfile: ./Dockerfile
        credentials:
          image:
            name: image-secret
        # buildArgs:
        #   - key="value"
        # platform: linux/arm
    - name: apply-app
      type: apply-app
      inputs:
        - from: context.image
          parameterKey: data.spec.components[0].properties.image
      properties:
        data:
          apiVersion: core.oam.dev/v1beta1
          kind: Application
          metadata:
            name: my-app
          spec:
            components:
              - name: my-web
                type: webservice
                properties:
                  # Note that this field will be replaced by the image in inputs
                  image: my-registry/test-image:v1
                  imagePullSecrets:
                    - image-secret
                  ports:
                    - port: 80
                      expose: true
```

## Versions

| Vela-workflow Addon|         KubeVela          |
|--------------------|:-------------------------:|
| v0.0.1 ~ v0.3.6    |       v1.6.0-alpha.1+     |
| v0.3.7+            |       v1.7.0-alpha.1+     |
| v0.4.4+            |       v1.7.2（CLI）        |

## Feedback

If you have any questions or feedback during use, please contact us through the following methods.

- Create Issue: [https://github.com/kubevela/workflow/issues](https://github.com/kubevela/workflow/issues)
- Slack: [CNCF Slack](https://slack.cncf.io/) #kubevela channel (_English_)
- Join DingTalk Group: 23310022
- Join Wechat Group: Broker wechat to add you into the user group.
  
<img src="https://static.kubevela.net/images/barnett-wechat.jpg" width="200" />
