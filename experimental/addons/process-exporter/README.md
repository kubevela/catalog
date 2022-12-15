# process-exporter

Prometheus exporter that mines /proc to report on selected processes.

## Installation

```shell
vela addon enable process-exporter
```

## Usage

The following steps will guide you how to display the metrics exposed by process-exporter with grafana dashboard.

> If you have already enabled the `prometheus-server` and `grafana` addons, please skip to step 4 to get started.

1. Install the prometheus-server addon

```shell
vela addon enable prometheus-server
```

2. Install the grafana addon

```shell
vela addon enable grafana
```

3. Access your grafana through port-forward

```shell
kubectl port-forward svc/grafana -n o11y-system 8080:3000
```

Now you can access your grafana by access `http://localhost:8080` in your browser. The default username and password are `admin` and `kubevela` respectively.

> You can change it by adding adminUser=super-user adminPassword=PASSWORD to step 3.

4. Import dashboard

The easiest way to install a dashboard is from the [Grafana.com Dashboard Library](https://grafana.com/grafana/dashboards/). In Grafana, click the “+” sign in the toolbar on the left side and select “Import”.

![image](https://user-images.githubusercontent.com/20487362/207794594-0faa34b0-8ad1-4b5d-8816-da44c06912d4.png)

Enter Dashboard ID [249](https://grafana.com/grafana/dashboards/249-named-processes/) and Select a Prometheus data source.

![image](https://user-images.githubusercontent.com/20487362/207796087-98ab3add-42be-41c5-bcb9-dba2ad41d4de.png)

![image](https://user-images.githubusercontent.com/20487362/207796714-df70f9a2-3106-4718-948d-9df8d3af6308.png)

After successful import, you will get a dashboard like this one.

![image](https://user-images.githubusercontent.com/20487362/207797011-43d9efba-6ad5-4b86-a51e-38f5c534b71e.png)