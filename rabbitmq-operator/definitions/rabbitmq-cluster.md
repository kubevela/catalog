---
title: rabbitmq-operator
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/rabbitmq-operator/versions.json';

<AddonVersion data={versions} current="1.0.0" page="definitions/rabbitmq-cluster" />

<!-- Generated from the definition. -->

rabbitmq operator component

**Type:** component. **From:** the [rabbitmq-operator](/addons/catalog/rabbitmq-operator/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>replicas</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>1</code></span></div><div className="addon-param-desc">The number of replicas of RabbitMQ nodes. Even numbers are highly discouraged and it is strongly recommended to use odd numbers.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>image</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">The RabbitMQ image reference.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>imagePullSecrets</code> <span className="addon-param-type">&#91;&#93;any</span></div><div className="addon-param-desc">An array of names of Kubernetes secrets, used to access the registry which contains the RabbitMQ image. This is only required for private registries.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>affinity</code> <span className="addon-param-type">map&#91;string&#93;any</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">The Pod affinity and anti-affinity rules.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>tolerations</code> <span className="addon-param-type">&#91;&#93;any</span></div><div className="addon-param-desc">Pod tolerations that will be applied to RabbitMQ Pods.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>skipPostDeploySteps</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>false</code></span></div><div className="addon-param-desc">If unset, or set to false, operator will run rabbitmq-queues rebalance all whenever the cluster is updated. When set to true, operator will skip running rabbitmq-queues rebalance all. For more information, see rabbitmq-queues.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>terminationGracePeriodSeconds</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>604800</code></span></div><div className="addon-param-desc">TerminationGracePeriodSeconds is the timeout that each rabbitmqcluster pod will have to run the container preStop lifecycle hook to ensure graceful termination. The lifecycle hook checks quorum status of existing quorum queues and synchronization of mirror queues, before safely terminates pods.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>override</code> <span className="addon-param-type">map&#91;string&#93;any</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Arbitrary overrides to the resources created by RabbitMQ Cluster Kubernetes Operator. This feature should be used with great care as overriding essential properties can render a RabbitMQ cluster unusable to applications or unreachable to the Operator. See the Override section to learn more.</div></div>

<details>
<summary><code>service</code> (2) configure service.</summary>

<div className="addon-param"><div className="addon-param-head"><code>type</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>ClusterIP</code></span></div><div className="addon-param-desc">The Kubernetes Service type for the RabbitmqCluster Service. This must be ClusterIP, NodePort, or LoadBalancer.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>annotations</code> <span className="addon-param-type">map&#91;string&#93;any</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">These are annotations on the service. Note that annotations containing kubernetes.io and k8s.io are not filtered at this level.</div></div>

</details>


<details>
<summary><code>persistence</code> (2) configure respurces.</summary>

<div className="addon-param"><div className="addon-param-head"><code>storage</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>10Gi</code></span></div><div className="addon-param-desc">The capacity of the persistent volume, expressed as a Kubernetes resource quantity. Set to `0` to deactivate persistence altogether (this may be convenient in CI/CD and test deloyments that should always start fresh).</div></div>
<div className="addon-param"><div className="addon-param-head"><code>storageClassName</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>standard</code></span></div><div className="addon-param-desc">The name of the Kubernetes StorageClass that will be used to request Persistent Volumes.</div></div>

</details>


<details>
<summary><code>resources</code> (4) configure resources.</summary>


<details>
<summary><code>limits</code> (2)</summary>

<div className="addon-param"><div className="addon-param-head"><code>cpu</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>2000m</code></span></div><div className="addon-param-desc">The CPU units used to calculate the share of CPU time available to the RabbitMQ container per 100 ms.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>memory</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>2Gi</code></span></div><div className="addon-param-desc">The memory limit allowed to be used by RabbitMQ container. The container won't be allowed to use more than this limit.</div></div>

</details>


<details>
<summary><code>requests</code> (2)</summary>

<div className="addon-param"><div className="addon-param-head"><code>cpu</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>1000m</code></span></div><div className="addon-param-desc">The CPU units required by the Kubernetes scheduler for the container running RabbitMQ.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>memory</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>2Gi</code></span></div><div className="addon-param-desc">The memory units required by the Kubernetes scheduler for the container running RabbitMQ.</div></div>

</details>


</details>


<details>
<summary><code>tls</code> (3) configure tls.</summary>

<div className="addon-param"><div className="addon-param-head"><code>secretName</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">The Secret name used to configure RabbitMQ TLS. The Secret must exist and contain keys `tls.key` and `tls.crt`.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>caSecretName</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">The Secret name used to configure RabbitMQ mTLS (used to verify clients' certificates). The Secret must exist and contain key `ca.crt`.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>disableNonTLSListeners</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>false</code></span></div><div className="addon-param-desc">When set to `true`, only TLS connections are allowed (non-TLS listeners are disabled).</div></div>

</details>


<details>
<summary><code>rabbitmq</code> (4) Additional configuration to append to the Cluster Generated configuration. Check Additional Config section for the list of always generated configuration.</summary>

<div className="addon-param"><div className="addon-param-head"><code>additionalPlugins</code> <span className="addon-param-type">&#91;&#93;any</span></div><div className="addon-param-desc">List of plugins to enabled in RabbitMQ. By default, RabbitMQ Cluster Kubernetes Operator enables Prometheus, K8s Peer Discovery and Management plugins.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>additionalConfig</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Additional configuration to append to the Cluster Generated configuration. Check Additional Config section for the list of always generated configuration.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>advancedConfig</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">RabbitMQ advanced.config. See https://www.rabbitmq.com/kubernetes/operator/using-operator.html#advanced-config for an example.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>envConfig</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">RabbitMQ uses rabbitmq-env.conf to override the defaults built-in into the RabbitMQ scripts and CLI tools. The value of spec.rabbitmq.envConfig will be written to /etc/rabbitmq/rabbitmq-env.conf.</div></div>

</details>

