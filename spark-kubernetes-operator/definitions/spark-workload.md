---
title: spark-workload
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/spark-kubernetes-operator/versions.json';

<AddonVersion data={versions} current="1beta2-1.3.8-3.1.1" page="definitions/spark-workload" />

<!-- Generated from the definition. -->

Describes a containerized spark application that can specify resource spec.

**Type:** component. **From:** the [spark-kubernetes-operator](/addons/catalog/spark-kubernetes-operator/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>name</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Specify the spark application name</div></div>
<div className="addon-param"><div className="addon-param-head"><code>namespace</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Specify the namespace for spark application to install</div></div>
<div className="addon-param"><div className="addon-param-head"><code>type</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Specify the application language type, e.g. "Scala", "Python", "Java" or "R"</div></div>
<div className="addon-param"><div className="addon-param-head"><code>pythonVersion</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Specify the python version</div></div>
<div className="addon-param"><div className="addon-param-head"><code>mode</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Specify the deploy mode, e.go "cluster", "client" or "in-cluster-client"</div></div>
<div className="addon-param"><div className="addon-param-head"><code>image</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Specify the container image for the driver, executor, and init-container</div></div>
<div className="addon-param"><div className="addon-param-head"><code>imagePullPolicy</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Specify the image pull policy for the driver, executor, and init-container</div></div>
<div className="addon-param"><div className="addon-param-head"><code>mainClass</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Specify the fully-qualified main class of the Spark application</div></div>
<div className="addon-param"><div className="addon-param-head"><code>mainApplicationFile</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Specify the path to a bundled JAR, Python, or R file of the application</div></div>
<div className="addon-param"><div className="addon-param-head"><code>sparkVersion</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Specify the version of Spark the application uses</div></div>
<div className="addon-param"><div className="addon-param-head"><code>proxyUser</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Specify the user to impersonate when submitting the application. It maps to the command-line flag “–proxy-user” in spark-submit</div></div>
<div className="addon-param"><div className="addon-param-head"><code>arguments</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Specify a list of arguments to be passed to the application</div></div>
<div className="addon-param"><div className="addon-param-head"><code>sparkConf</code> <span className="addon-param-type">map&#91;string&#93;string</span></div><div className="addon-param-desc">Specify the config information carries user-specified Spark configuration properties as they would use the  "--conf" option in spark-submit</div></div>
<div className="addon-param"><div className="addon-param-head"><code>hadoopConf</code> <span className="addon-param-type">map&#91;string&#93;string</span></div><div className="addon-param-desc">Specify the config information carries user-specified Hadoop configuration properties as they would use the  the "--conf" option in spark-submit.  The SparkApplication controller automatically adds prefix "spark.hadoop." to Hadoop configuration properties</div></div>
<div className="addon-param"><div className="addon-param-head"><code>sparkConfigMap</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Specify the name of the ConfigMap containing Spark configuration files such as log4j.properties. The controller will add environment variable SPARK_CONF_DIR to the path where the ConfigMap is mounted to</div></div>
<div className="addon-param"><div className="addon-param-head"><code>hadoopConfigMap</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Specify the name of the ConfigMap containing Hadoop configuration files such as core-site.xml. The controller will add environment variable HADOOP_CONF_DIR to the path where the ConfigMap is mounted to</div></div>

<details>
<summary><code>restartPolicy</code> (5) Specify the policy on if and in which conditions the controller should restart an application</summary>

<div className="addon-param"><div className="addon-param-head"><code>type</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Type value option: "Always", "Never", "OnFailure"</div></div>
<div className="addon-param"><div className="addon-param-head"><code>onSubmissionFailureRetries</code> <span className="addon-param-type">int</span></div><div className="addon-param-desc">Specify the number of times to retry submitting an application before giving up. This is best effort and actual retry attempts can be &gt;= the value specified due to caching. These are required if RestartPolicy is OnFailure</div></div>
<div className="addon-param"><div className="addon-param-head"><code>onFailureRetries</code> <span className="addon-param-type">int</span></div><div className="addon-param-desc">Specify the number of times to retry running an application before giving up</div></div>
<div className="addon-param"><div className="addon-param-head"><code>onSubmissionFailureRetryInterval</code> <span className="addon-param-type">int</span></div><div className="addon-param-desc">Specify the interval in seconds between retries on failed submissions</div></div>
<div className="addon-param"><div className="addon-param-head"><code>onFailureRetryInterval</code> <span className="addon-param-type">int</span></div><div className="addon-param-desc">Specify the interval in seconds between retries on failed runs</div></div>

</details>


<details>
<summary><code>driver</code> (6) Specify the driver sepc request for the driver pod</summary>

<div className="addon-param"><div className="addon-param-head"><code>cores</code> <span className="addon-param-type">int</span></div><div className="addon-param-desc">Specify the cores maps to spark.driver.cores or spark.executor.cores for the driver and executors, respectively</div></div>
<div className="addon-param"><div className="addon-param-head"><code>coreLimit</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Specify a hard limit on CPU cores for the pod</div></div>
<div className="addon-param"><div className="addon-param-head"><code>memory</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Specify the amount of memory to request for the pod</div></div>
<div className="addon-param"><div className="addon-param-head"><code>labels</code> <span className="addon-param-type">map&#91;string&#93;string</span></div><div className="addon-param-desc">Specify the Kubernetes labels to be added to the pod</div></div>

<details>
<summary><code>volumeMounts[]</code> (2) Specify the volumes listed in “.spec.volumes” to mount into the main container’s filesystem</summary>

<div className="addon-param"><div className="addon-param-head"><code>name</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>mountPath</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>

</details>


</details>


<details>
<summary><code>executor</code> (7) Specify the executor spec request for the executor pod</summary>

<div className="addon-param"><div className="addon-param-head"><code>cores</code> <span className="addon-param-type">int</span></div><div className="addon-param-desc">Specify the cores maps to spark.driver.cores or spark.executor.cores for the driver and executors, respectively</div></div>
<div className="addon-param"><div className="addon-param-head"><code>coreLimit</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Specify a hard limit on CPU cores for the pod</div></div>
<div className="addon-param"><div className="addon-param-head"><code>memory</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Specify the amount of memory to request for the pod</div></div>
<div className="addon-param"><div className="addon-param-head"><code>instances</code> <span className="addon-param-type">int</span></div><div className="addon-param-desc">Specify the number of executor instances</div></div>
<div className="addon-param"><div className="addon-param-head"><code>labels</code> <span className="addon-param-type">map&#91;string&#93;string</span></div><div className="addon-param-desc">Specify the Kubernetes labels to be added to the pod</div></div>

<details>
<summary><code>volumeMounts[]</code> (2) Specify the volumes listed in “.spec.volumes” to mount into the main container’s filesystem</summary>

<div className="addon-param"><div className="addon-param-head"><code>name</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>mountPath</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>

</details>


</details>


<details>
<summary><code>volumes[]</code> (3) Specify the list of Kubernetes volumes that can be mounted by the driver and/or executors</summary>

<div className="addon-param"><div className="addon-param-head"><code>name</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>

<details>
<summary><code>hostPath</code> (2)</summary>

<div className="addon-param"><div className="addon-param-head"><code>path</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>type</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>Directory</code></span></div><div className="addon-param-desc"></div></div>

</details>


</details>


<details>
<summary><code>deps</code> (6) Specify the dependencies captures all possible types of dependencies of a Spark application</summary>

<div className="addon-param"><div className="addon-param-head"><code>jars</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Specify a list of JAR files the Spark application depends on</div></div>
<div className="addon-param"><div className="addon-param-head"><code>files</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Specify a list of files the Spark application depends on</div></div>
<div className="addon-param"><div className="addon-param-head"><code>pyFiles</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Specify a list of Python files the Spark application depends on</div></div>
<div className="addon-param"><div className="addon-param-head"><code>packages</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Specify a list of maven coordinates of jars to include on the driver and executor classpaths. This will search the local maven repo, then maven central and any additional remote repositories given by the “repositories” option. Each package should be of the form “groupId:artifactId:version”</div></div>
<div className="addon-param"><div className="addon-param-head"><code>excludePackages</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Specify a list of “groupId:artifactId”, to exclude while resolving the dependencies provided in Packages to avoid dependency conflicts</div></div>
<div className="addon-param"><div className="addon-param-head"><code>repositories</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Specify a list of additional remote repositories to search for the maven coordinate given with the “packages” option</div></div>

</details>

