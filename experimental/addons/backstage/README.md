# backstage

This is a backstage addon for KubeVela.

## Related Component Repo

- [Backstage Plugin KubeVela](https://github.com/kubevela-contrib/backstage-plugin-kubevela)
- [Backstage Demo App](https://github.com/wonderflow/vela-backstage-demo)

## Installation

```shell
vela addon registry add experimental --type=helm --endpoint=https://addons.kubevela.net/experimental/
vela addon enable backstage
```

If you want to test it locally, you can run the port-forward command and choose `backstage-plugin-vela` component:

```shell
vela port-forward addon-backstage -n vela-system
```

Choose "local | backstage | backstage:7007" in the list and it will open the link in your browser automatically.

You can also visit by "127.0.0.1:7007".

Note that the backstage app is strictly serving in the domain `127.0.0.1:7007`, you must build your own backstage app if you want to use it in other domains.

## System Model Integration

* A vela application will convert to a backstage system.
* Resources created by vela component, will convert to backstage components.
* Resources can be marked by annotations to represent more backstage information as the [Well Known Annotations](#Well-Known-Annotations) section described.  

## Well Known Annotations

KubeVela will sync with the backstage [Well-known Annotations](https://backstage.io/docs/features/software-catalog/well-known-annotations), besides that,
KubeVela adds some more annotations that can help sync data from vela application to backstage spec.

|           Annotations           |                       Usage                       |
| :-----------------------------: | :-----------------------------------------------: |
|    `backstage.oam.dev/owner`    |       Owner of the app synced to backstage        |
|   `backstage.oam.dev/domain`    |       Domain of the app synced to backstage       |
| `backstage.oam.dev/description` |    Description of the app synced to backstage     |
|    `backstage.oam.dev/title`    |       Title of the app synced to backstage        |
|    `backstage.oam.dev/tags`     | Tags of the app synced to backstage, split by `,` |

The annotations and labels of vela application will be automatically injected on syncing, while vela component need a backstage trait for this, check the example app as follows.

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: first-vela-app
  annotations:
    backstage.oam.dev/owner: "team:my-team"
    backstage.oam.dev/domain: "vela-demo"
    backstage.oam.dev/description: "This is a sample application."
    backstage.oam.dev/title: "First Vela App"
    backstage.oam.dev/tags: "first-demo, vela"
spec:
  components:
    - name: express-server
      type: webservice
      properties:
        image: oamdev/hello-world
        ports:
          - port: 8000
            expose: true
      traits:
        - type: backstage
          properties:
            type: website
            lifecycle: production
            owner: wonderflow
            description: "This is the hello world app."
            title: "Hello World"
            tags:
              - "hello-world"
            annotations:
              backstage.io/view-url: https://github.com/kubevela-contrib/backstage-plugin-kubevela/blob/main/examples/app.yaml
              backstage.io/edit-url: https://github.com/kubevela-contrib/backstage-plugin-kubevela/edit/main/examples/app.yaml
              backstage.io/source-location: url:https://github.com/kubevela-contrib/backstage-plugin-kubevela
              github.com/project-slug: kubevela-contrib/backstage-plugin-kubevela
              github.com/team-slug: kubevela/maintainers
            labels:
              velaapp: demo
            links:
              - url: "https://kubevela.net/"
                title: "vela-doc"
                type: "docs"
```

You can also config `backstage-location` as the trait, then it will sync the backstage entity from the location targets:

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: vela-app-location
  annotations:
    backstage.oam.dev/owner: "vela-maintainers"
    backstage.oam.dev/domain: "vela-backstage-demo"
    backstage.oam.dev/description: "This is a sample application."
    backstage.oam.dev/title: "Vela App Location"
    backstage.oam.dev/tags: "backstage-location-demo, vela"
spec:
  components:
    - name: express-server-2
      type: webservice
      properties:
        image: oamdev/hello-world
        ports:
          - port: 8000
            expose: true
      traits:
        - type: backstage-location
          properties:
            type: url
            targets:
              - "https://raw.githubusercontent.com/kubevela-contrib/backstage-plugin-kubevela/main/examples/backstage-group.yaml"
              - "https://raw.githubusercontent.com/kubevela-contrib/backstage-plugin-kubevela/main/examples/backstage-user.yaml"
              - "https://raw.githubusercontent.com/kubevela-contrib/backstage-plugin-kubevela/main/examples/backstage-domain.yaml"
              - "https://raw.githubusercontent.com/kubevela-contrib/backstage-plugin-kubevela/main/examples/backstage-api.yaml"
```

>Please make sure your backstage app has the permission(`catalog.rules` and `backend.reading.allow`), check [this PR](https://github.com/wonderflow/vela-backstage-demo/pull/3/files) for details.

## How to build my own backstage app with this integration?

This is a [demo repo](https://github.com/wonderflow/vela-backstage-demo) of my own backstage app. Below is the steps that how I create this repo.

1. Create backstage app by:

```
npx @backstage/create-app
```

You can refer to the [doc of backstage for details](https://backstage.io/docs/getting-started/create-an-app).

2. Add dockerfile and build images

The dockerfile is already added inside the demo repo. You can read [this doc](https://github.com/wonderflow/vela-backstage-demo#build-docker-image) to learn how to build and run this image.

You can refer to [this PR #1](https://github.com/wonderflow/vela-backstage-demo/pull/1) to learn the detail changes from initial commit.

3. Use Entity Provider for Vela Integrations

We will leverage the [external integrations](https://backstage.io/docs/features/software-catalog/external-integrations) mechanism and works as a `Custom Entity Providers`.

You can refer to [this PR #2](https://github.com/wonderflow/vela-backstage-demo/pull/2) to learn the detail changes.

4. Build and Push Image

Prepare a [makefile](https://github.com/wonderflow/vela-backstage-demo/blob/main/Makefile) like the demo repo and replace the image with yours. Then run the following command:

```
make build-push
```

Make sure you've updated the `app-config.yaml` with the target service endpoint.

Check the detail config in this [commit](https://github.com/wonderflow/vela-backstage-demo/commit/e703bc2ce96e3813ac9a535e223d5db503c6f6fb).

5. Deploy my own backstage app

* If you still using this addon, just want to replace the image, then enable the addon like:
    ```
    vela addon enable backstage image="<my-backstage-image>"
    ```

* If you want to deploy your own app, you can deploy this vela app and change the image `wonderflow/backstage:latest` with your own.

```
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: addon-backstage
  namespace: vela-system
spec:
  components:
    - type: webservice
      name: backstage-plugin-vela
      properties:
        image: wonderflow/backstage-plugin-kubevela:latest
        exposeType: ClusterIP
        ports:
          - port: 8080
            protocol: TCP
            expose: true
      traits:
        - type: service-account
          properties:
            name: vela-app-read
            create: true
            privileges:
              - scope: cluster
                apiGroups:
                  - core.oam.dev
                resources:
                  - applications
                verbs:
                  - list
                  - watch
    - type: webservice
      name: backstage
      properties:
        image: wonderflow/backstage:latest
        exposeType: ClusterIP
        ports:
          - port: 7007
            protocol: TCP
            expose: true
      dependsOn:
        - backstage-plugin-vela
```

* You can remove the backstage app and enable the addon with plugin proxy only:
	```	
	vela addon enable backstage pluginOnly=true serviceType=NodePort
	```	
	Then you can run the backstage app in other place pointing the endpoint configured.
  
  Configure the `vela.host` and `backend.reading.allow` below, pointing to the kubevela plugin endpoint.
  ```
  vela:
    host: "http://47.254.33.41:32505"
    # frequency is the refresh rate for the Vela API, default to 60 seconds, the unit is seconds
    frequency: 30
    # timeout is the timeout limit for the Vela API, default to 600 seconds, the unit is seconds
    timeout: 60

  backend:
    reading:
      allow:
        - host: 47.254.33.41:32505
  ```      