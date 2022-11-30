# Harbor

[Harbor](https://goharbor.io/) is an open source registry that secures artifacts with policies and role-based access control, ensures images are scanned and free from vulnerabilities, and signs images as trusted.

This addon install harbor by helm chart. 

:::caution
This is just a experimental addon that it didn't configure persistent storage for harbor, please make sure you're just using it for demo.
:::

## Install

1. Add experimental registry

```
vela addon registry add experimental --type=helm --endpoint=https://addons.kubevela.net/experimental/
```

2. Get your node IP, this only works when you're using velad as cluster.

```
kubectl get nodes -owide
```

The EXTERNAL-IP is what we need here as "<your-node-ip>".

3. Install addon from experimental registry

```
vela addon enable experimental/harbor serviceType=nodePort externalURL=http://<your-node-ip>:30002
```

## Use the harbor image registry

1. Visiting the admin portal with your browser

http://<your-node-ip>:30002

The default username and password is `admin`/`Harbor12345` .

Please create a project for your image repository here.

2. Configure insecure registry for your docker daemon `/etc/docker/daemon.json`:  
    ```
    {
        "insecure-registries" : ["<your-node-ip>:30002"]
    }
    ```
   - restart the daemon: `service docker restart`

3. Login this registry
    ```
    docker login <your-node-ip>:30002
    ```

Username and password is the same with the portal, you can also configure more accounts in the admin portal.

4. Add tag for your docker registry and push the image
    ```
    docker tag oamdev/hello-world  <your-node-ip>:30002/oamdev/hello-world
    docker push <your-node-ip>:30002/oamdev/hello-world
    ```

:::caution
If you want to use it for your kubernetes cluster, you also need to configure the insecure registry for all nodes of your kubernetes cluster.
:::

5. For velad on linux, just configure as follows:

```
$ cat /etc/rancher/k3s/registries.yaml
mirrors:
  docker.io:
    endpoint:
      - "http://<your-node-ip>:30002"
configs:
  "<your-node-ip>:30002":
    tls:
      insecure_skip_verify: true
```

Restart the k3s:

```
systemctl restart k3s
```

This is working as a mirror and convert automatically by k3s. As a result, you don't need to change the image, just use `oamdev/hello-world` in your deployment, it will convert to `<your-node-ip>:30002/oamdev/hello-world` in k3s automatically.

## Uninstall

```
vela addon disable harbor
```
