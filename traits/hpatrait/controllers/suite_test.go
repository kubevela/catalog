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

package controllers

import (
	"context"
	"fmt"
	"testing"
	"time"

	"github.com/crossplane/oam-controllers/pkg/oam/util"
	"github.com/crossplane/oam-kubernetes-runtime/apis/core"
	oamv1alpha2 "github.com/crossplane/oam-kubernetes-runtime/apis/core/v1alpha2"
	coreoamdevv1alpha2 "github.com/oam-dev/catalog/traits/hpatrait/api/v1alpha2"
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
	autoscalingv1 "k8s.io/api/autoscaling/v1"
	corev1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/runtime"
	clientgoscheme "k8s.io/client-go/kubernetes/scheme"
	"sigs.k8s.io/controller-runtime/pkg/client"
	"sigs.k8s.io/controller-runtime/pkg/client/config"
	"sigs.k8s.io/controller-runtime/pkg/envtest"
	"sigs.k8s.io/controller-runtime/pkg/envtest/printer"
	logf "sigs.k8s.io/controller-runtime/pkg/log"
	"sigs.k8s.io/controller-runtime/pkg/log/zap"
	// +kubebuilder:scaffold:imports
)

// These tests use Ginkgo (BDD-style Go testing framework). Refer to
// http://onsi.github.io/ginkgo/ to learn more about Ginkgo.

var k8sClient client.Client
var testEnv *envtest.Environment
var scheme = runtime.NewScheme()
var namespace = "hpatrait-controller-test"
var ctx = context.Background()

var ns = corev1.Namespace{
	ObjectMeta: metav1.ObjectMeta{
		Name: namespace,
	},
}

func TestAPIs(t *testing.T) {
	RegisterFailHandler(Fail)

	RunSpecsWithDefaultAndCustomReporters(t,
		"HPATrait Controller Suite",
		[]Reporter{printer.NewlineReporter{}})
}

var _ = BeforeSuite(func(done Done) {
	// logf.SetLogger(zap.LoggerTo(GinkgoWriter, true))

	By("bootstrapping test environment")
	logf.SetLogger(zap.New(zap.UseDevMode(true), zap.WriteTo(GinkgoWriter)))
	err := clientgoscheme.AddToScheme(scheme)
	Expect(err).Should(BeNil())
	err = core.AddToScheme(scheme)
	Expect(err).Should(BeNil())
	err = coreoamdevv1alpha2.AddToScheme(scheme)
	Expect(err).Should(BeNil())
	err = autoscalingv1.AddToScheme(scheme)
	Expect(err).Should(BeNil())

	By("Setting up Kubernetes client")
	k8sClient, err = client.New(config.GetConfigOrDie(), client.Options{Scheme: scheme})
	if err != nil {
		logf.Log.Error(err, "failed to create k8sClient")
		Fail("setup failed")
	}

	By("Finishiing setting up test env")

	logf.Log.Info("Start to run a test, clean up previous resources")
	// delete the namespace with all its resources
	Expect(k8sClient.Delete(ctx, &ns, client.PropagationPolicy(metav1.DeletePropagationForeground))).
		Should(SatisfyAny(BeNil(), &util.NotFoundMatcher{}))
	logf.Log.Info("make sure all the resources are removed")
	objectKey := client.ObjectKey{
		Name: namespace,
	}
	res := &corev1.Namespace{}
	Eventually(
		// gomega has a bug that can't take nil as the actual input, so has to make it a func
		func() error {
			return k8sClient.Get(ctx, objectKey, res)
		},
		time.Second*30, time.Millisecond*500).Should(&util.NotFoundMatcher{})
	logf.Log.Info(fmt.Sprintf("namespace %v", res))
	// recreate it
	Eventually(
		func() error {
			return k8sClient.Create(ctx, &ns)
		},
		time.Second*3, time.Millisecond*300).Should(SatisfyAny(BeNil(), &util.AlreadyExistMatcher{}))

	// Create HPA trait definition
	mt := oamv1alpha2.TraitDefinition{
		ObjectMeta: metav1.ObjectMeta{
			Name: "horizontalpodautoscalertraits.core.oam.dev",
		},
		Spec: oamv1alpha2.TraitDefinitionSpec{
			Reference: oamv1alpha2.DefinitionReference{
				Name: "horizontalpodautoscalertraits.core.oam.dev",
			},
		},
	}
	logf.Log.Info("Creating trait definition")
	// For some reason, traitDefinition is created as a Cluster scope object
	Expect(k8sClient.Create(ctx, &mt)).Should(SatisfyAny(BeNil(), &util.AlreadyExistMatcher{}))

	close(done)
}, 300)

var _ = AfterSuite(func() {
	By("tearing down the test environment")
	Expect(k8sClient.Delete(ctx, &ns, client.PropagationPolicy(metav1.DeletePropagationForeground))).Should(BeNil())
})
