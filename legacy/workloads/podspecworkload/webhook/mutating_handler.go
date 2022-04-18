package webhook

import (
	"context"
	"encoding/json"
	"net/http"

	"k8s.io/klog"
	"k8s.io/utils/pointer"
	"sigs.k8s.io/controller-runtime/pkg/client"
	logf "sigs.k8s.io/controller-runtime/pkg/log"
	"sigs.k8s.io/controller-runtime/pkg/runtime/inject"
	"sigs.k8s.io/controller-runtime/pkg/webhook/admission"

	"github.com/oam-dev/catalog/workloads/podspecworkload/api/v1alpha1"
	util "github.com/oam-dev/kubevela/pkg/utils"
)

// MutatingHandler handles PodSpec workload
type MutatingHandler struct {
	Client client.Client

	// Decoder decodes objects
	Decoder *admission.Decoder
}

// log is for logging in this package.
var mutatelog = logf.Log.WithName("PodSpecWorkload-mutate")

var _ admission.Handler = &MutatingHandler{}

// Handle handles admission requests.
func (h *MutatingHandler) Handle(ctx context.Context, req admission.Request) admission.Response {
	obj := &v1alpha1.PodSpecWorkload{}

	err := h.Decoder.Decode(req, obj)
	if err != nil {
		return admission.Errored(http.StatusBadRequest, err)
	}
	DefaultPodSpecWorkload(obj)

	marshalled, err := json.Marshal(obj)
	if err != nil {
		return admission.Errored(http.StatusInternalServerError, err)
	}
	resp := admission.PatchResponseFromRaw(req.AdmissionRequest.Object.Raw, marshalled)
	if len(resp.Patches) > 0 {
		klog.V(5).Infof("Admit PodSpecWorkload %s/%s patches: %v", obj.Namespace, obj.Name, util.DumpJSON(resp.Patches))
	}
	return resp
}

// DefaultPodSpecWorkload will set the default value for the PodSpecWorkload
func DefaultPodSpecWorkload(obj *v1alpha1.PodSpecWorkload) {
	mutatelog.Info("default", "name", obj.Name)
	if obj.Spec.Replicas == nil {
		mutatelog.Info("default replicas as 1")
		obj.Spec.Replicas = pointer.Int32Ptr(1)
	}
}

var _ inject.Client = &MutatingHandler{}

// InjectClient injects the client into the MutatingHandler
func (h *MutatingHandler) InjectClient(c client.Client) error {
	h.Client = c
	return nil
}

var _ admission.DecoderInjector = &MutatingHandler{}

// InjectDecoder injects the decoder into the MutatingHandler
func (h *MutatingHandler) InjectDecoder(d *admission.Decoder) error {
	h.Decoder = d
	return nil
}
