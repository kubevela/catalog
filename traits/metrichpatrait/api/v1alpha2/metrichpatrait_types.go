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

package v1alpha2

import (
	runtimev1alpha1 "github.com/crossplane/crossplane-runtime/apis/core/v1alpha1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

// EDIT THIS FILE!  THIS IS SCAFFOLDING FOR YOU TO OWN!
// NOTE: json tags are required.  Any new fields you add must have json tags for the fields to be serialized.

// MetricHPATraitSpec defines the desired state of MetricHPATrait
type MetricHPATraitSpec struct {
	// INSERT ADDITIONAL SPEC FIELDS - desired state of cluster
	// Important: Run "make" to regenerate code after modifying this file

	// fulfilled by trait
	// ScaleType ScaledObjectScaleType `json:"scaleType,omitempty"`

	// fulfilled by trait
	// ScaleTargetRef *ObjectReference `json:"scaleTargetRef,omitempty"`

	// fulfilled by trait
	// JobTargetRef *batchv1.JobSpec `json:"jobTargetRef,omitempty"`

	// +optional
	PollingInterval *int32 `json:"pollingInterval,omitempty"`
	// +optional
	CooldownPeriod *int32 `json:"cooldownPeriod,omitempty"`
	// +optional
	MinReplicaCount *int32 `json:"minReplicaCount,omitempty"`
	// +optional
	MaxReplicaCount *int32 `json:"maxReplicaCount,omitempty"`
	// +optional
	PromServerAddress string `json:"promServerAddress,omitempty"`

	PromQuery string `json:"promQuery"`

	PromThreshold *int32 `json:"promThreshold"`

	// WorkloadReference to the workload this trait applies to.
	WorkloadReference runtimev1alpha1.TypedReference `json:"workloadRef,omitempty"`
}

// MetricHPATraitStatus defines the observed state of MetricHPATrait
type MetricHPATraitStatus struct {
	// INSERT ADDITIONAL STATUS FIELD - define observed state of cluster
	// Important: Run "make" to regenerate code after modifying this file
	runtimev1alpha1.ConditionedStatus `json:",inline"`

	// Resources managed by this trait
	Resources []runtimev1alpha1.TypedReference `json:"resources,omitempty"`
}

// +kubebuilder:object:root=true
// +kubebuilder:resource:categories={crossplane,oam}
// +kubebuilder:subresource:status

// MetricHPATrait is the Schema for the metrichpatraits API
type MetricHPATrait struct {
	metav1.TypeMeta   `json:",inline"`
	metav1.ObjectMeta `json:"metadata,omitempty"`

	Spec   MetricHPATraitSpec   `json:"spec,omitempty"`
	Status MetricHPATraitStatus `json:"status,omitempty"`
}

// +kubebuilder:object:root=true

// MetricHPATraitList contains a list of MetricHPATrait
type MetricHPATraitList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty"`
	Items           []MetricHPATrait `json:"items"`
}

func init() {
	SchemeBuilder.Register(&MetricHPATrait{}, &MetricHPATraitList{})
}
