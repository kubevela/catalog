# kyuubi

Apache Kyuubi is a distributed and multi-tenant gateway to provide serverless SQL on data warehouses and lakehouses.

For more information about Apache Kyuubi, please see the Apache Kyuubi documentation: https://kyuubi.readthedocs.io/en/master/.

## Install

Add experimental registry

```
vela addon registry add experimental --type=helm --endpoint=https://addons.kubevela.net/experimental/
```

Enable this addon

```
vela addon enable fluxcd
vela addon enable kyuubi
```

Uninstall

```
vela addon disable kyuubi
```

# To check the kyuubi running status

* Firstly, check the kyuubi(and the fluxcd and we need to deploy by helm) running status:

```
vela addon status kyuubi
vela ls -A | grep kyuubi
```


