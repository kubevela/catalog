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
	corev1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"

	runtimev1alpha1 "github.com/crossplane/crossplane-runtime/apis/core/v1alpha1"
)

// ServiceTraitSpec defines the desired state of ServiceTrait
type ServiceTraitSpec struct {
	// NOTE: You can add extension of ServiceTraitSpec in the future
	// K8S native ServiceSpec
	Template corev1.ServiceSpec `json:"template,omitempty"`

	// WorkloadReference to the workload this trait applies to.
	WorkloadReference runtimev1alpha1.TypedReference `json:"workloadRef"`
}

// ServiceTraitStatus defines the observed state of ServiceTrait
type ServiceTraitStatus struct {
	runtimev1alpha1.ConditionedStatus `json:",inline"`

	// Resources managed by this service trait
	Resources []runtimev1alpha1.TypedReference `json:"resources,omitempty"`
}

// +kubebuilder:object:root=true

// ServiceTrait is the Schema for the servicetraits API
// +kubebuilder:resource:categories={crossplane,oam}
// +kubebuilder:subresource:status
type ServiceTrait struct {
	metav1.TypeMeta   `json:",inline"`
	metav1.ObjectMeta `json:"metadata,omitempty"`

	Spec   ServiceTraitSpec   `json:"spec,omitempty"`
	Status ServiceTraitStatus `json:"status,omitempty"`
}

// +kubebuilder:object:root=true

// ServiceTraitList contains a list of ServiceTrait
type ServiceTraitList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty"`
	Items           []ServiceTrait `json:"items"`
}

func init() {
	SchemeBuilder.Register(&ServiceTrait{}, &ServiceTraitList{})
}
