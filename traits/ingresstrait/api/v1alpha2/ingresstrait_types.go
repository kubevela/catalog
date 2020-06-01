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
	"k8s.io/api/networking/v1beta1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

// IngressTraitSpec defines the desired state of IngressTrait
type IngressTraitSpec struct {
	// Same fields as IngressTLS
	// +optional
	TLS []v1beta1.IngressTLS `json:"tls,omitempty"`

	// Same fields as IngressRule
	// If you don't set ServiceName and ServicePort, they have default values
	// +optional
	Rules []v1beta1.IngressRule `json:"rules,omitempty"`

	// WorkloadReference to the workload this trait applies to.
	WorkloadReference runtimev1alpha1.TypedReference `json:"workloadRef"`
}

// IngressTraitStatus defines the observed state of IngressTrait
type IngressTraitStatus struct {
	runtimev1alpha1.ConditionedStatus `json:",inline"`

	// Resources managed by this service trait
	Resources []runtimev1alpha1.TypedReference `json:"resources,omitempty"`
}

// +kubebuilder:object:root=true

// IngressTrait is the Schema for the ingresstraits API
// +kubebuilder:resource:categories={crossplane,oam}
// +kubebuilder:subresource:status
type IngressTrait struct {
	metav1.TypeMeta   `json:",inline"`
	metav1.ObjectMeta `json:"metadata,omitempty"`

	Spec   IngressTraitSpec   `json:"spec,omitempty"`
	Status IngressTraitStatus `json:"status,omitempty"`
}

// +kubebuilder:object:root=true

// IngressTraitList contains a list of IngressTrait
type IngressTraitList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty"`
	Items           []IngressTrait `json:"items"`
}

func init() {
	SchemeBuilder.Register(&IngressTrait{}, &IngressTraitList{})
}
