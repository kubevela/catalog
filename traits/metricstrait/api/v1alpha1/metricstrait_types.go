/*


Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package v1alpha1

import (
	runtimev1alpha1 "github.com/crossplane/crossplane-runtime/apis/core/v1alpha1"
	"github.com/crossplane/oam-kubernetes-runtime/pkg/oam"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/util/intstr"
)

// EDIT THIS FILE!  THIS IS SCAFFOLDING FOR YOU TO OWN!
// NOTE: json tags are required.  Any new fields you add must have json tags for the fields to be serialized.

// MetricsTraitSpec defines the desired state of MetricsTrait
type MetricsTraitSpec struct {
	// A list of endpoints allowed as part of this ServiceMonitorNames.
	MetricsEndPoint Endpoint `json:"metricsendpoint"`
	// Selector to select Endpoints objects.
	Selector metav1.LabelSelector `json:"selector"`
}

// Endpoint defines a scrapeable endpoint serving Prometheus metrics.
type Endpoint struct {
	// Name of the service port this endpoint refers to. Mutually exclusive with targetPort.
	Port string `json:"port,omitempty"`
	// Name or number of the pod port this endpoint refers to. Mutually exclusive with port.
	TargetPort *intstr.IntOrString `json:"targetPort,omitempty"`
	// HTTP path to scrape for metrics.
	// default is /metrics
	Path string `json:"path,omitempty"`
	// default is 1 min
	// Interval at which metrics should be scraped
	Interval string `json:"interval,omitempty"`
}

// MetricsTraitStatus defines the observed state of MetricsTrait
type MetricsTraitStatus struct {
	runtimev1alpha1.ConditionedStatus `json:",inline"`

	// ServiceMonitorNames managed by this trait
	ServiceMonitorNames []string `json:"serviceMonitorName,omitempty"`
}

// +kubebuilder:object:root=true

// MetricsTrait is the Schema for the metricstraits API
// +kubebuilder:resource:categories={oam}
// +kubebuilder:subresource:status
type MetricsTrait struct {
	metav1.TypeMeta   `json:",inline"`
	metav1.ObjectMeta `json:"metadata,omitempty"`

	Spec   MetricsTraitSpec   `json:"spec,omitempty"`
	Status MetricsTraitStatus `json:"status,omitempty"`
}

var _ oam.Workload = &MetricsTrait{}

func (in *MetricsTrait) SetConditions(c ...runtimev1alpha1.Condition) {
	in.Status.SetConditions(c...)
}

func (in *MetricsTrait) GetCondition(c runtimev1alpha1.ConditionType) runtimev1alpha1.Condition {
	return in.Status.GetCondition(c)
}

// +kubebuilder:object:root=true

// MetricsTraitList contains a list of MetricsTrait
type MetricsTraitList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty"`
	Items           []MetricsTrait `json:"items"`
}

func init() {
	SchemeBuilder.Register(&MetricsTrait{}, &MetricsTraitList{})
}
