// api/v1alpha1/gamingsession_types.go

package v1alpha1

import (
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

// GamingSessionSpec defines the desired state of GamingSession
type GamingSessionSpec struct {
	// Add fields here to define the desired state of your resource
}

// GamingSessionStatus defines the observed state of GamingSession
type GamingSessionStatus struct {
	// Add fields here to define the observed state of your resource
}

// +kubebuilder:object:root=true
// +kubebuilder:subresource:status

// GamingSession is the Schema for the gamingsessions API
type GamingSession struct {
	metav1.TypeMeta   `json:",inline"`
	metav1.ObjectMeta `json:"metadata,omitempty"`

	Spec   GamingSessionSpec   `json:"spec,omitempty"`
	Status GamingSessionStatus `json:"status,omitempty"`
}

// +kubebuilder:object:root=true

// GamingSessionList contains a list of GamingSession
type GamingSessionList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty"`
	Items           []GamingSession `json:"items"`
}

func init() {
	SchemeBuilder.Register(&GamingSession{}, &GamingSessionList{})
}
