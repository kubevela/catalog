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

	"github.com/oam-dev/catalog/traits/metricstrait/api/v1alpha1"
	util "github.com/oam-dev/kubevela/pkg/utils"
)

const (
	// SupportedFormat is the only metrics data format we support
	SupportedFormat = "prometheus"

	// SupportedScheme is the only scheme we support
	SupportedScheme = "http"

	// DefaultMetricsPath is the default metrics path we support
	DefaultMetricsPath = "/metrics"
)

// MutatingHandler handles MetricsTrait
type MutatingHandler struct {
	Client client.Client

	// Decoder decodes objects
	Decoder *admission.Decoder
}

// log is for logging in this package.
var mutatelog = logf.Log.WithName("metricstrait-mutate")

var _ admission.Handler = &MutatingHandler{}

// Handle handles admission requests.
func (h *MutatingHandler) Handle(ctx context.Context, req admission.Request) admission.Response {
	obj := &v1alpha1.MetricsTrait{}

	err := h.Decoder.Decode(req, obj)
	if err != nil {
		return admission.Errored(http.StatusBadRequest, err)
	}
	DefaultMetrics(obj)

	marshalled, err := json.Marshal(obj)
	if err != nil {
		return admission.Errored(http.StatusInternalServerError, err)
	}
	resp := admission.PatchResponseFromRaw(req.AdmissionRequest.Object.Raw, marshalled)
	if len(resp.Patches) > 0 {
		klog.V(5).Infof("Admit MetricsTrait %s/%s patches: %v", obj.Namespace, obj.Name, util.DumpJSON(resp.Patches))
	}
	return resp
}

// DefaultMetrics sets all the default value for the metricsTrait
func DefaultMetrics(obj *v1alpha1.MetricsTrait) {
	mutatelog.Info("default", "name", obj.Name)
	if len(obj.Spec.ScrapeService.Format) == 0 {
		mutatelog.Info("default format as prometheus")
		obj.Spec.ScrapeService.Format = SupportedFormat
	}
	if len(obj.Spec.ScrapeService.Path) == 0 {
		mutatelog.Info("default path as /metrics")
		obj.Spec.ScrapeService.Path = DefaultMetricsPath
	}
	if len(obj.Spec.ScrapeService.Scheme) == 0 {
		mutatelog.Info("default scheme as http")
		obj.Spec.ScrapeService.Scheme = SupportedScheme
	}
	if obj.Spec.ScrapeService.Enabled == nil {
		mutatelog.Info("default enabled as true")
		obj.Spec.ScrapeService.Enabled = pointer.BoolPtr(true)
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
