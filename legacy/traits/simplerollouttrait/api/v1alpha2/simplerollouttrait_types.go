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
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	runtime "k8s.io/apimachinery/pkg/runtime"
	"k8s.io/apimachinery/pkg/util/intstr"

	runtimev1alpha1 "github.com/crossplane/crossplane-runtime/apis/core/v1alpha1"
)

// EDIT THIS FILE!  THIS IS SCAFFOLDING FOR YOU TO OWN!
// NOTE: json tags are required.  Any new fields you add must have json tags for the fields to be serialized.

// SimpleRolloutTraitSpec defines the desired state of SimpleRolloutTrait
type SimpleRolloutTraitSpec struct {
	// INSERT ADDITIONAL SPEC FIELDS - desired state of cluster
	// Important: Run "make" to regenerate code after modifying this file

	Replica        *int32              `json:"replica"`
	Batch          *intstr.IntOrString `json:"batch"`
	MaxUnavailable *intstr.IntOrString `json:"maxUnavailable"`

	WorkloadReference runtimev1alpha1.TypedReference `json:"workloadRef"`
}

// SimpleRolloutTraitStatus defines the observed state of SimpleRolloutTrait
type SimpleRolloutTraitStatus struct {
	// INSERT ADDITIONAL STATUS FIELD - define observed state of cluster
	// Important: Run "make" to regenerate code after modifying this file
	runtimev1alpha1.ConditionedStatus `json:",inline"`

	RolloutHistory []RolloutHistory `json:"rolloutiHistory,omitempty"`

	CurrentWorkloadReference runtimev1alpha1.TypedReference `json:"currentWorkloadRef,omitempty"`
}

type RolloutHistory struct {
	Revision int64 `json:"revision,omitempty"`

	HistoryData runtime.RawExtension `json:"historyData,omitempty"`
}

// +kubebuilder:object:root=true
// +kubebuilder:resource:categories={crossplane,oam}
// +kubebuilder:subresource:status

// SimpleRolloutTrait is the Schema for the simplerollouttraits API
type SimpleRolloutTrait struct {
	metav1.TypeMeta   `json:",inline"`
	metav1.ObjectMeta `json:"metadata,omitempty"`

	Spec   SimpleRolloutTraitSpec   `json:"spec,omitempty"`
	Status SimpleRolloutTraitStatus `json:"status,omitempty"`
}

// +kubebuilder:object:root=true

// SimpleRolloutTraitList contains a list of SimpleRolloutTrait
type SimpleRolloutTraitList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty"`
	Items           []SimpleRolloutTrait `json:"items"`
}

func init() {
	SchemeBuilder.Register(&SimpleRolloutTrait{}, &SimpleRolloutTraitList{})
}
