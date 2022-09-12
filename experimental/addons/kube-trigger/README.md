# kube-trigger

kube-trigger is a tool that combines event listeners and action triggers.

Refer to https://github.com/kubevela/kube-trigger for details.

## Quick Start

Enable kube-trigger addon by `vela addon enable kube-trigger`.

Let's use a real use-case as an exmaple (see [#4418](https://github.com/kubevela/kubevela/issues/4418)). TL;DR, the user want the Application to be automatically
updated whenever the ConfigMaps that are referenced by `ref-objects` are updated.

```yaml
# You can find this yaml in catalog/examples/kube-trigger/sample.yaml
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: this-will-trigger-update-1
  namespace: default
data:
  content: EDIT_ME_AFTER_APPLY

---
apiVersion: v1
kind: ConfigMap
metadata:
  name: this-will-trigger-update-2
  namespace: default
data:
  content: EDIT_ME_AFTER_APPLY

---
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: this-app-will-be-updated
  namespace: default
spec:
  components:
    - type: ref-objects
      name: configmap
      properties:
        objects:
          - resource: configmap
            name: this-will-trigger-update-1
            namespace: default
          - resource: configmap
            name: this-will-trigger-update-2
            namespace: default
    # This component is from kube-trigger addon.
    # It allows you to bump revision of this App when
    # resources change (in this case, it is the
    # two CMs above).
    - type: apprev-bumper
      name: apprev-bumper
      properties:
        watchResource:
          apiVersion: v1
          kind: ConfigMap
          namespace: default
          # We only care about the two CMs above.
          # So use a regex to match them.
          nameRegex: this-will-trigger-update-.

```

By applying the yaml above, we have created these resources:

- one Application
- two ConfigMaps, which are referenced by the Application

So, here is what we expected:

1. edit any of the ConfigMaps
2. the Application is updated with a new revision

Get a terminal to watch ApplicationRevision changes, so that we know the Application is updated later:

`kubectl get apprev --watch`

Now, use another terminal to edit any of the ConfigMaps:

`kubectl edit cm this-will-trigger-update-1`

In the editor prompted, edit the `data` field of the ConfigMap. Keep an eye on the terminal that is watching `apprev`, then exit the editor.

You should the ApplicationRevision being updated.
