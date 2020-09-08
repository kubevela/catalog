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
	"k8s.io/apimachinery/pkg/util/intstr"
)

// EDIT THIS FILE!  THIS IS SCAFFOLDING FOR YOU TO OWN!
// NOTE: json tags are required.  Any new fields you add must have json tags for the fields to be serialized.

// PodDisruptionBudgetTraitSpec defines the desired state of PodDisruptionBudgetTrait
type PodDisruptionBudgetTraitSpec struct {
	// An eviction is allowed if at least "minAvailable" pods selected by
	// "selector" will still be available after the eviction, i.e. even in the
	// absence of the evicted pod.  So for example you can prevent all voluntary
	// evictions by specifying "100%".
	// +optional
	MinAvailable *intstr.IntOrString `json:"minAvailable,omitempty"`

	// An eviction is allowed if at most "maxUnavailable" pods selected by
	// "selector" are unavailable after the eviction, i.e. even in absence of
	// the evicted pod. For example, one can prevent all voluntary evictions
	// by specifying 0. This is a mutually exclusive setting with "minAvailable".
	// +optional
	MaxUnavailable *intstr.IntOrString `json:"maxUnavailable,omitempty"`

	// WorkloadReference to the workload this trait applies to.
	WorkloadReference runtimev1alpha1.TypedReference `json:"workloadRef"`
}

// PodDisruptionBudgetTraitStatus defines the observed state of PodDisruptionBudgetTrait
type PodDisruptionBudgetTraitStatus struct {
	runtimev1alpha1.ConditionedStatus `json:",inline"`

	// Resources managed by this service trait
	Resources []runtimev1alpha1.TypedReference `json:"resources,omitempty"`
}

// +kubebuilder:object:root=true

// PodDisruptionBudgetTrait is the Schema for the poddisruptionbudgettraits API
// +kubebuilder:resource:categories={crossplane,oam},shortName={pdbtrait}
// +kubebuilder:subresource:status
// +kubebuilder:printcolumn:name="MinAvailable",type=integer,JSONPath=`.spec.minAvailable`
// +kubebuilder:printcolumn:name="MaxUnavailable",type=integer,JSONPath=`.spec.maxUnavailable`
// +kubebuilder:printcolumn:name="Synced",type=string,JSONPath=`.status.conditions[?(@.type == "Synced")].status`
// +kubebuilder:printcolumn:name="ApplicationConfiguration",type=string,JSONPath=`.metadata.ownerReferences[?(@.kind=="ApplicationConfiguration")].name`
// +kubebuilder:printcolumn:name="PodDisruptionBudget",type=string,JSONPath=`.status.resources[?(@.kind=="PodDisruptionBudget")].name`
// +kubebuilder:printcolumn:name="Age",type="date",JSONPath=".metadata.creationTimestamp"
type PodDisruptionBudgetTrait struct {
	metav1.TypeMeta   `json:",inline"`
	metav1.ObjectMeta `json:"metadata,omitempty"`

	Spec   PodDisruptionBudgetTraitSpec   `json:"spec,omitempty"`
	Status PodDisruptionBudgetTraitStatus `json:"status,omitempty"`
}

// +kubebuilder:object:root=true

// PodDisruptionBudgetTraitList contains a list of PodDisruptionBudgetTrait
type PodDisruptionBudgetTraitList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty"`
	Items           []PodDisruptionBudgetTrait `json:"items"`
}

func init() {
	SchemeBuilder.Register(&PodDisruptionBudgetTrait{}, &PodDisruptionBudgetTraitList{})
}
