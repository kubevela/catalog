package controllers

import (
	"context"
	"github.com/pkg/errors"
	appsv1 "k8s.io/api/apps/v1"
	corev1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/util/intstr"
	"reflect"

	"catalog/workloads/statefulsetworkload/api/v1alpha2"
	"github.com/crossplane/oam-kubernetes-runtime/pkg/oam"
)

// Reconcile error strings.
const (
	errNotStatefulSetWorkload = "object is not a statefulset workload"
)

const defaultNamespace = "default"

const labelKey = "statefulsetworkload.oam.crossplane.io"

var (
	statefulsetKind       = reflect.TypeOf(appsv1.StatefulSet{}).Name()
	statefulsetAPIVersion = appsv1.SchemeGroupVersion.String()
)

// Translator translates a StatefulSetWorkload into a StatefulSet.
// nolint:gocyclo
func Translator(ctx context.Context, w oam.Workload) ([]oam.Object, error) {
	ssw, ok := w.(*v1alpha2.StatefulSetWorkload)
	if !ok {
		return nil, errors.New(errNotStatefulSetWorkload)
	}

	s := &appsv1.StatefulSet{
		TypeMeta: metav1.TypeMeta{
			Kind:       statefulsetKind,
			APIVersion: statefulsetAPIVersion,
		},
		ObjectMeta: metav1.ObjectMeta{
			Name:      ssw.GetName(),
			Namespace: defaultNamespace,
		},
		Spec: appsv1.StatefulSetSpec{
			Selector: &metav1.LabelSelector{
				MatchLabels: map[string]string{
					labelKey: string(ssw.GetUID()),
				},
			},
			Template: corev1.PodTemplateSpec{
				ObjectMeta: metav1.ObjectMeta{
					Labels: map[string]string{
						labelKey: string(ssw.GetUID()),
					},
				},
			},
		},
	}
	// NOTE: If you don't specify ServiceName it will be the defult
	if ssw.Spec.ServiceName != nil {
		s.Spec.ServiceName = *ssw.Spec.ServiceName
	} else {
		s.Spec.ServiceName = ssw.GetName() + "-svc"
	}

	if ssw.Spec.OperatingSystem != nil {
		if s.Spec.Template.Spec.NodeSelector == nil {
			s.Spec.Template.Spec.NodeSelector = map[string]string{}
		}
		s.Spec.Template.Spec.NodeSelector["beta.kubernetes.io/os"] = string(*ssw.Spec.OperatingSystem)
	}

	if ssw.Spec.CPUArchitecture != nil {
		if s.Spec.Template.Spec.NodeSelector == nil {
			s.Spec.Template.Spec.NodeSelector = map[string]string{}
		}
		s.Spec.Template.Spec.NodeSelector["kubernetes.io/arch"] = string(*ssw.Spec.CPUArchitecture)
	}

	for _, container := range ssw.Spec.Containers {
		if container.ImagePullSecret != nil {
			s.Spec.Template.Spec.ImagePullSecrets = append(s.Spec.Template.Spec.ImagePullSecrets, corev1.LocalObjectReference{
				Name: *container.ImagePullSecret,
			})
		}
		kubernetesContainer := corev1.Container{
			Name:    container.Name,
			Image:   container.Image,
			Command: container.Command,
			Args:    container.Arguments,
		}

		if container.Resources != nil {
			kubernetesContainer.Resources = corev1.ResourceRequirements{
				Requests: corev1.ResourceList{
					corev1.ResourceCPU:    container.Resources.CPU.Required,
					corev1.ResourceMemory: container.Resources.Memory.Required,
				},
			}
			for _, v := range container.Resources.Volumes {
				mount := corev1.VolumeMount{
					Name:      v.Name,
					MountPath: v.MouthPath,
				}
				if v.AccessMode != nil && *v.AccessMode == v1alpha2.VolumeAccessModeRO {
					mount.ReadOnly = true
				}
				kubernetesContainer.VolumeMounts = append(kubernetesContainer.VolumeMounts, mount)
			}
		}

		for _, p := range container.Ports {
			port := corev1.ContainerPort{
				Name:          p.Name,
				ContainerPort: p.Port,
			}
			if p.Protocol != nil {
				port.Protocol = corev1.Protocol(*p.Protocol)
			}
			kubernetesContainer.Ports = append(kubernetesContainer.Ports, port)
		}

		for _, e := range container.Environment {
			if e.Value != nil {
				kubernetesContainer.Env = append(kubernetesContainer.Env, corev1.EnvVar{
					Name:  e.Name,
					Value: *e.Value,
				})
				continue
			}
			if e.FromSecret != nil {
				kubernetesContainer.Env = append(kubernetesContainer.Env, corev1.EnvVar{
					Name: e.Name,
					ValueFrom: &corev1.EnvVarSource{
						SecretKeyRef: &corev1.SecretKeySelector{
							Key: e.FromSecret.Key,
							LocalObjectReference: corev1.LocalObjectReference{
								Name: e.FromSecret.Name,
							},
						},
					},
				})
			}
		}

		if container.LivenessProbe != nil {
			kubernetesContainer.LivenessProbe = &corev1.Probe{}
			if container.LivenessProbe.InitialDelaySeconds != nil {
				kubernetesContainer.LivenessProbe.InitialDelaySeconds = *container.LivenessProbe.InitialDelaySeconds
			}
			if container.LivenessProbe.TimeoutSeconds != nil {
				kubernetesContainer.LivenessProbe.TimeoutSeconds = *container.LivenessProbe.TimeoutSeconds
			}
			if container.LivenessProbe.PeriodSeconds != nil {
				kubernetesContainer.LivenessProbe.PeriodSeconds = *container.LivenessProbe.PeriodSeconds
			}
			if container.LivenessProbe.SuccessThreshold != nil {
				kubernetesContainer.LivenessProbe.SuccessThreshold = *container.LivenessProbe.SuccessThreshold
			}
			if container.LivenessProbe.FailureThreshold != nil {
				kubernetesContainer.LivenessProbe.FailureThreshold = *container.LivenessProbe.FailureThreshold
			}

			if container.LivenessProbe.HTTPGet != nil {
				kubernetesContainer.LivenessProbe.Handler.HTTPGet = &corev1.HTTPGetAction{
					Path: container.LivenessProbe.HTTPGet.Path,
					Port: intstr.IntOrString{IntVal: container.LivenessProbe.HTTPGet.Port},
				}

				for _, h := range container.LivenessProbe.HTTPGet.HTTPHeaders {
					kubernetesContainer.LivenessProbe.Handler.HTTPGet.HTTPHeaders = append(kubernetesContainer.LivenessProbe.Handler.HTTPGet.HTTPHeaders, corev1.HTTPHeader{
						Name:  h.Name,
						Value: h.Value,
					})
				}
			}
			if container.LivenessProbe.Exec != nil {
				kubernetesContainer.LivenessProbe.Exec = &corev1.ExecAction{
					Command: container.LivenessProbe.Exec.Command,
				}
			}
			if container.LivenessProbe.TCPSocket != nil {
				kubernetesContainer.LivenessProbe.TCPSocket = &corev1.TCPSocketAction{
					Port: intstr.IntOrString{IntVal: container.LivenessProbe.TCPSocket.Port},
				}
			}
		}

		if container.ReadinessProbe != nil {
			kubernetesContainer.ReadinessProbe = &corev1.Probe{}
			if container.ReadinessProbe.InitialDelaySeconds != nil {
				kubernetesContainer.ReadinessProbe.InitialDelaySeconds = *container.ReadinessProbe.InitialDelaySeconds
			}
			if container.ReadinessProbe.TimeoutSeconds != nil {
				kubernetesContainer.ReadinessProbe.TimeoutSeconds = *container.ReadinessProbe.TimeoutSeconds
			}
			if container.ReadinessProbe.PeriodSeconds != nil {
				kubernetesContainer.ReadinessProbe.PeriodSeconds = *container.ReadinessProbe.PeriodSeconds
			}
			if container.ReadinessProbe.SuccessThreshold != nil {
				kubernetesContainer.ReadinessProbe.SuccessThreshold = *container.ReadinessProbe.SuccessThreshold
			}
			if container.ReadinessProbe.FailureThreshold != nil {
				kubernetesContainer.ReadinessProbe.FailureThreshold = *container.ReadinessProbe.FailureThreshold
			}

			if container.ReadinessProbe.HTTPGet != nil {
				kubernetesContainer.ReadinessProbe.Handler.HTTPGet = &corev1.HTTPGetAction{
					Path: container.ReadinessProbe.HTTPGet.Path,
					Port: intstr.IntOrString{IntVal: container.ReadinessProbe.HTTPGet.Port},
				}

				for _, h := range container.ReadinessProbe.HTTPGet.HTTPHeaders {
					kubernetesContainer.ReadinessProbe.Handler.HTTPGet.HTTPHeaders = append(kubernetesContainer.ReadinessProbe.Handler.HTTPGet.HTTPHeaders, corev1.HTTPHeader{
						Name:  h.Name,
						Value: h.Value,
					})
				}
			}
			if container.ReadinessProbe.Exec != nil {
				kubernetesContainer.ReadinessProbe.Exec = &corev1.ExecAction{
					Command: container.ReadinessProbe.Exec.Command,
				}
			}
			if container.ReadinessProbe.TCPSocket != nil {
				kubernetesContainer.ReadinessProbe.TCPSocket = &corev1.TCPSocketAction{
					Port: intstr.IntOrString{IntVal: container.ReadinessProbe.TCPSocket.Port},
				}
			}
		}

		s.Spec.Template.Spec.Containers = append(s.Spec.Template.Spec.Containers, kubernetesContainer)
	}

	return []oam.Object{s}, nil
}
