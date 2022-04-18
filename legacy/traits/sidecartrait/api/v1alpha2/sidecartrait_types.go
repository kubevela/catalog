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
	corev1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

// EDIT THIS FILE!  THIS IS SCAFFOLDING FOR YOU TO OWN!
// NOTE: json tags are required.  Any new fields you add must have json tags for the fields to be serialized.

// SidecarTraitSpec defines the desired state of SidecarTrait
type SidecarTraitSpec struct {
	// INSERT ADDITIONAL SPEC FIELDS - desired state of cluster
	// Important: Run "make" to regenerate code after modifying this file

	// Containers is the list of sidecar containers to be injected into the resource
	Container corev1.Container `json:"container,omitempty"`

	// List of volumes that can be mounted by sidecar containers
	Volumes []corev1.Volume `json:"volumes,omitempty"`

	// WorkloadReference to the workload this trait applies to.
	WorkloadReference runtimev1alpha1.TypedReference `json:"workloadRef,omitempty"`
}

// SidecarTraitStatus defines the observed state of SidecarTrait
type SidecarTraitStatus struct {
	// INSERT ADDITIONAL STATUS FIELD - define observed state of cluster
	// Important: Run "make" to regenerate code after modifying this file

	runtimev1alpha1.ConditionedStatus `json:",inline"`
}

// +kubebuilder:object:root=true
// +kubebuilder:resource:categories={crossplane,oam}
// +kubebuilder:subresource:status

// SidecarTrait is the Schema for the sidecartraits API
type SidecarTrait struct {
	metav1.TypeMeta   `json:",inline"`
	metav1.ObjectMeta `json:"metadata,omitempty"`

	Spec   SidecarTraitSpec   `json:"spec,omitempty"`
	Status SidecarTraitStatus `json:"status,omitempty"`
}

// +kubebuilder:object:root=true

// SidecarTraitList contains a list of SidecarTrait
type SidecarTraitList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty"`
	Items           []SidecarTrait `json:"items"`
}

func init() {
	SchemeBuilder.Register(&SidecarTrait{}, &SidecarTraitList{})
}
