# kubevela.io 

This addon is the document website, align with https://kubevela.io/ and its mirror https://kubevela.net/ .

Use this addon can help you reading the document in your cluster which can be air-gapped environment.

## install

```shell
vela addon enable kubevela-io
```

## uninstall

```shell
vela addon disable kubevela-io
```

## more notes
- About the image to deploy
  - The image in this addon is oam-dev/kubevela-io:latest in default. you can pull the image from the dockerhub or you can compile the source code and built it to an image, then push your own local hub.
- About the way to access the local kubevela-io website
  - You can use the NodePort service which is deployed in vela-system named kubevela-io-np
  - You may use the ingress as you wish