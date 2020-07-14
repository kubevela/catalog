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

// CronHPATraitSpec defines the desired state of CronHPATrait
type CronHPATraitSpec struct {
	// INSERT ADDITIONAL SPEC FIELDS - desired state of cluster
	// Important: Run "make" to regenerate code after modifying this file

	// Foo is an example field of CronHPATrait. Edit CronHPATrait_types.go to remove/update
	ExcludeDates []string `json:"excludeDates,omitempty"`
	Jobs         []Job    `json:"jobs"`

	// WorkloadReference to the workload this trait applies to.
	WorkloadReference runtimev1alpha1.TypedReference `json:"workloadRef"`
}
type Job struct {
	Name     string `json:"name"`
	Schedule string `json:"schedule"`
	// job will only run once if enabled.
	RunOnce    bool  `json:"runOnce,omitempty"`
	TargetSize int32 `json:"targetSize"`
}

// CronHPATraitStatus defines the observed state of CronHPATrait
type CronHPATraitStatus struct {
	// INSERT ADDITIONAL STATUS FIELD - define observed state of cluster
	// Important: Run "make" to regenerate code after modifying this file
	runtimev1alpha1.ConditionedStatus `json:",inline"`

	// Resources managed by this service trait
	Resources []runtimev1alpha1.TypedReference `json:"resources,omitempty"`
}

// +kubebuilder:object:root=true

// CronHPATrait is the Schema for the cronhpatraits API
// +kubebuilder:resource:categories={crossplane,oam}
// +kubebuilder:subresource:status
type CronHPATrait struct {
	metav1.TypeMeta   `json:",inline"`
	metav1.ObjectMeta `json:"metadata,omitempty"`

	Spec   CronHPATraitSpec   `json:"spec,omitempty"`
	Status CronHPATraitStatus `json:"status,omitempty"`
}

// +kubebuilder:object:root=true

// CronHPATraitList contains a list of CronHPATrait
type CronHPATraitList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty"`
	Items           []CronHPATrait `json:"items"`
}

func init() {
	SchemeBuilder.Register(&CronHPATrait{}, &CronHPATraitList{})
}
