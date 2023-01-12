# Addon terraform-vsphere

This addon contains Terraform provider for VMware vSphere.

## About VMware vSphere

VMware vSphere is VMware's virtualization platform, which transforms data centers into aggregated computing infrastructures that include CPU, storage, and networking resources. vSphere manages these infrastructures as a unified operating environment, and provides you with the tools to administer the data centers that participate in that environment.

Terraform Provider for VMware vSphere gives Terraform the ability to work with VMware vSphere, notably vCenter Server and ESXi. This provider can be used to manage many aspects of a vSphere environment, including virtual machines, standard and distributed switches, datastores, content libraries, and more.

Find more information in [VMware vSphere Docs](https://docs.vmware.com/en/VMware-vSphere) and [Terraform VMware vSphere Provider](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs).

## Addon usage

### Enable addon and authenticate provider

To provision VMware vSphere resources, you should enable Terraform addon.

```shell
vela addon enable terraform
```
Then, enable Terraform provider addon for VMware vSphere.

```shell
vela addon enable terraform-vsphere
```

You can also disable, upgrade, check status of an addon by `vela addon` command.

After that, you can create credential for the provider. Find supported flags using following command:

```shell
$ vela provider add terraform-vsphere -h
Authenticate Terraform Cloud Provider terraform-vsphere by creating a credential secret and a Terraform Controller Provider

Usage:
  vela provider add terraform-vsphere [flags]

Examples:
vela provider add terraform-vsphere

Flags:
      --VSPHERE_ALLOW_UNVERIFIED_SSL string   Get VSPHERE_ALLOW_UNVERIFIED_SSL per this guide https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs
      --VSPHERE_PASSWORD string               Get VSPHERE_PASSWORD per this guide https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs
      --VSPHERE_SERVER string                 Get VSPHERE_SERVER per this guide https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs
      --VSPHERE_USER string                   Get VSPHERE_USER per this guide https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs
  -h, --help                                  help for terraform-vsphere
      --name string                           The name of Terraform Provider for VMware vSphere (default "vsphere")

Global Flags:
  -y, --yes   Assume yes for all user prompts
```

Now, you can authenticate the Terraform provider with `--VSPHERE_USER`, `--VSPHERE_PASSWORD`, `--VSPHERE_SERVER`, and `--VSPHERE_ALLOW_UNVERIFIED_SSL`.

```shell
vela provider add terraform-vsphere --VSPHERE_USER=xxx --VSPHERE_PASSWORD=yyy --VSPHERE_SERVER=zzz --VSPHERE_ALLOW_UNVERIFIED_SSL=aaa
```

## Find supported components

All supported Terraform cloud resources can be seen in the [list](https://kubevela.net/docs/end-user/components/cloud-services/cloud-resources-list). You can also filter them by command `vela components --label type=terraform`.

To check the specification of one cloud resource, use `vela show <component-type-name>`. Or just per the [official doc](https://kubevela.net/docs/end-user/components/cloud-services/cloud-resources-list).

Then, you can provision and consume the cloud resource by [creating an application](https://kubevela.net/docs/tutorials/consume-cloud-services#provision-by-creating-application).

If the provided cloud resources did't cover your needs, you can still customize the cloud resources with the flexible Terraform components. Find more information in [Extend Cloud Resources](https://kubevela.net/docs/platform-engineers/components/component-terraform). You are also encouraged to contribute the extended cloud resources to community.
