# ClickHouse

[ClickHouse](https://clickhouse.com/) is a column-oriented database management system (DBMS) for online analytical processing of queries (OLAP).

This addon based on the [clickhouse operator](https://github.com/Altinity/clickhouse-operator). The addon itself will deploy the CRD operator and provide a `clickhouse` component which will deploy clickhouse cluster for every application.


## Install

1. Add experimental registry

```
vela addon registry add experimental --type=helm --endpoint=https://addons.kubevela.net/experimental/
```

2. Enable this addon

```
vela addon enable clickhouse
```

## Use

1. Apply the following app:

```
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: ck-app
spec:
  components:
    - name: my-ck
      type: clickhouse
      properties:
        storage:
          size: "10Gi"
      traits:
        - type: gateway
          properties:
            class: traefik
            domain: 47.251.8.82.nip.io
            http:
              "/play": 8123
              "/": 8123
```

The default password for default user is `default`.

2. Check the application status and topology provided by [velaux](https://kubevela.net/docs/reference/addons/velaux).

3. Check the endpoint:

```
$ vela status  ck-app --endpoint
I0729 11:37:46.405137   65484 utils.go:156] find cluster gateway service vela-system/kubevela-cluster-gateway-service:9443
Please access ck-app from the following endpoints:
+---------+-----------+-------------------------------------+----------------------------------+-------+
| CLUSTER | COMPONENT |      REF(KIND/NAMESPACE/NAME)       |             ENDPOINT             | INNER |
+---------+-----------+-------------------------------------+----------------------------------+-------+
| local   | my-ck     | Service/default/clickhouse-my-ck    | clickhouse-my-ck.default:8123    | true  |
| local   | my-ck     | Service/default/clickhouse-my-ck    | clickhouse-my-ck.default:9000    | true  |
| local   | my-ck     | Service/default/chi-my-ck-my-ck-0-0 | chi-my-ck-my-ck-0-0.default:8123 | true  |
| local   | my-ck     | Service/default/chi-my-ck-my-ck-0-0 | chi-my-ck-my-ck-0-0.default:9000 | true  |
| local   | my-ck     | Service/default/chi-my-ck-my-ck-0-0 | chi-my-ck-my-ck-0-0.default:9009 | true  |
+---------+-----------+-------------------------------------+----------------------------------+-------+
```

4. Port forward to the clickhouse UI

```
$ vela port-forward ck-app
? You have 5 endpoints in your app. Please choose one:
Cluster | Component | Ref(Kind/Namespace/Name) | Endpoint | Inner
local | my-ck | Service/default/clickhouse-my-ck | clickhouse-my-ck.default:8123 | true
```

It will open browser directly, you can use it by visiting: http://127.0.0.1:8123/play .

Then all the things goes the same as [the clickhouse official guide](https://clickhouse.com/docs/en/quick-start/#2-connect-to-clickhouse).

5. Use clickhouse by client:

You may notice there's another endpoint: `clickhouse-my-ck.default:9000`. It's provided for client use, you can also port-forward it.

```
vela port-forward ck-app
? You have 5 endpoints in your app. Please choose one:
Cluster | Component | Ref(Kind/Namespace/Name) | Endpoint | Inner
local | my-ck | Service/default/clickhouse-my-ck | clickhouse-my-ck.default:9000 | true
```

You need to install [clickhouse-client](https://clickhouse.com/docs/en/getting-started/install/#system-requirements) to use.

```
clickhouse client
```

Then everything works the same with [the clickhouse official guide](https://clickhouse.com/docs/en/quick-start/#5-the-clickhouse-client) again.

The endpoint (`clickhouse-my-ck.default:9000`) can also used by other component deployed in Kubernetes clusters.



