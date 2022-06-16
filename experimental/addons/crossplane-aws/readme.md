# Crossplane AWS

[AWS Provider](https://github.com/crossplane-contrib/provider-aws) for Crossplane.

## Provision AWS cloud resources

- Enable addon `crossplane-aws`

```shell
$ vela addon enable crossplane-aws
```

- Authenticate AWS Provider for Crossplane

Apply the application below. You can get AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY per https://aws.amazon.com/blogs/security/wheres-my-secret-access-key/.

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: aws
  namespace: vela-system
spec:
  components:
    - name: aws
      type: crossplane-aws
      properties:
        name: aws
        AWS_ACCESS_KEY_ID: xxx
        AWS_SECRET_ACCESS_KEY: yyy

```

- Provision cloud resources

Let's provision a S3 bucket.

Apply the application below.

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: s3-poc
spec:
  components:
    - name: dev
      type: crossplane-aws-s3
      properties:
        name: kubevela-test-0714
        acl: private
        locationConstraint: us-east-1
```

After the application got `running`, you can check the bucket by AWS [cli](https://aws.amazon.com/cli/?nc1=h_ls) or console.

```shell
$ vela ls
APP   	COMPONENT	TYPE  	             TRAITS	PHASE  	HEALTHY	STATUS	CREATED-TIME
s3-poc	dev      	crossplane-aws-s3	      	running	healthy	      	2022-06-16 15:37:15 +0800 CST

$ aws s3 ls
2022-06-16 15:37:17 kubevela-test-0714
```
