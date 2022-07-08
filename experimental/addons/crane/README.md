# crane

The goal of Crane is to provide a one-stop-shop project to help Kubernetes users to save cloud resource usage with a rich set of functionalities:

- **Time Series Prediction** based on monitoring data
- **Usage and Cost visibility**
- **Usage & Cost Optimization** including:
    - R2 (Resource Re-allocation)
    - R3 (Request & Replicas Recommendation)
    - Effective Pod Autoscaling (Effective Horizontal & Vertical Pod Autoscaling)
    - Cost Optimization
- **Enhanced QoS** based on Pod PriorityClass
- **Load-aware Scheduling** 

## Install addon

```shell
$ vela addon enable crane
# If you have trouble accessing GitHub, enable mirrors
$ vela addon enable crane mirror=true
```

## Features
### Time Series Prediction

TimeSeriesPrediction defines metric spec to predict kubernetes resources like Pod or Node.
The prediction module is the core component that other crane components relied on, like EHPA and Analytics.

### Effective HorizontalPodAutoscaler

EffectiveHorizontalPodAutoscaler helps you manage application scaling in an easy way. It is compatible with native [HorizontalPodAutoscaler](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) but extends more features like prediction-driven autoscaling.

### Analytics

Analytics model analyzes the workload and provide recommendations about resource optimize.

Two Recommendations are currently supported:

- **ResourceRecommend**: Replicas recommendation analyze the actual application usage and give advice for replicas and HPA configurations.
- **HPARecommend**: Resource recommendation allows you to obtain recommended values for resources in a cluster and use them to improve the resource utilization of the cluster.

### QoS Ensurance

Kubernetes is capable of starting multiple pods on same node, and as a result, some of the user applications may be impacted when there are resources(e.g. cpu) consumption competition. To mitigate this, Crane allows users defining PrioirtyClass for the pods and QoSEnsurancePolicy, and then detects disruption and ensure the high priority pods not being impacted by resource competition.

Avoidance Actions:

- **Disable Schedule**: disable scheduling by setting node taint and condition
- **Throttle**: throttle the low priority pods by squeezing cgroup settings
- **Evict**: evict low priority pods

## Load-aware Scheduling

Native scheduler of kubernetes can only schedule pods by resource request, which can easily cause a series of load uneven problems. In contrast, Crane-scheduler can get the actual load of kubernetes nodes from Prometheus, and achieve more efficient scheduling.
