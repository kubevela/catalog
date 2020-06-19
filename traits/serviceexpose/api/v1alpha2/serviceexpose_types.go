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

// ServiceExposeSpec defines the desired state of ServiceExpose
type ServiceExposeSpec struct {
	// NOTE: You can add extension of ServiceExposeSpec in the future
	// K8S native ServiceSpec
	Template corev1.ServiceSpec `json:"template,omitempty"`

	// WorkloadReference to the workload this trait applies to.
	WorkloadReference runtimev1alpha1.TypedReference `json:"workloadRef"`
}

// ServiceExposeStatus defines the observed state of ServiceExpose
type ServiceExposeStatus struct {
	runtimev1alpha1.ConditionedStatus `json:",inline"`

	// Resources managed by this serviceexpose trait
	Resources []runtimev1alpha1.TypedReference `json:"resources,omitempty"`
}

// +kubebuilder:object:root=true

// ServiceExpose is the Schema for the serviceexposes API
// +kubebuilder:resource:categories={crossplane,oam}
// +kubebuilder:subresource:status
type ServiceExpose struct {
	metav1.TypeMeta   `json:",inline"`
	metav1.ObjectMeta `json:"metadata,omitempty"`

	Spec   ServiceExposeSpec   `json:"spec,omitempty"`
	Status ServiceExposeStatus `json:"status,omitempty"`
}

// +kubebuilder:object:root=true

// ServiceExposeList contains a list of ServiceExpose
type ServiceExposeList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty"`
	Items           []ServiceExpose `json:"items"`
}

func init() {
	SchemeBuilder.Register(&ServiceExpose{}, &ServiceExposeList{})
}
