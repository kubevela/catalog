package test_test

import (
	"github.com/crossplane/oam-controllers/pkg/oam/util"
	"github.com/crossplane/oam-kubernetes-runtime/apis/core"
	oamv1alpha2 "github.com/crossplane/oam-kubernetes-runtime/apis/core/v1alpha2"
	"github.com/oam-dev/catalog/traits/serviceexpose/api/v1alpha2"
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
	corev1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/runtime"
	clientgoscheme "k8s.io/client-go/kubernetes/scheme"
	"sigs.k8s.io/controller-runtime/pkg/client"
	"sigs.k8s.io/controller-runtime/pkg/client/config"
	"sigs.k8s.io/controller-runtime/pkg/envtest/printer"
	logf "sigs.k8s.io/controller-runtime/pkg/log"
	"sigs.k8s.io/controller-runtime/pkg/log/zap"
	"testing"
	"time"
)

var k8sClient client.Client
var scheme = runtime.NewScheme()

func TestAPIs(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecsWithDefaultAndCustomReporters(t,
		"OAM Extended Trait ServiceExpose Controller Suite",
		[]Reporter{printer.NewlineReporter{}})
}

var _ = BeforeSuite(func(done Done) {
	By("bootstrapping test environment")
	logf.SetLogger(zap.New(zap.UseDevMode(true), zap.WriteTo(GinkgoWriter)))
	err := clientgoscheme.AddToScheme(scheme)
	Expect(err).Should(BeNil())
	err = v1alpha2.AddToScheme(scheme)
	Expect(err).Should(BeNil())
	err = core.AddToScheme(scheme)
	Expect(err).Should(BeNil())
	By("Setting up kubernetes client")
	k8sClient, err = client.New(config.GetConfigOrDie(), client.Options{Scheme: scheme})
	if err != nil {
		logf.Log.Error(err, "failed to create k8sClient")
		Fail("setup failed")
	}
	By("Finished setting up test environment")

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
	// recreate it
	Eventually(
		func() error {
			return k8sClient.Create(ctx, &ns)
		},
		time.Second*3, time.Millisecond*300).Should(SatisfyAny(BeNil(), &util.AlreadyExistMatcher{}))
	// Create ServiceExpose traitdefinition
	se := oamv1alpha2.TraitDefinition{
		ObjectMeta: metav1.ObjectMeta{
			Name: "serviceexposes.core.oam.dev",
		},
		Spec: oamv1alpha2.TraitDefinitionSpec{
			Reference: oamv1alpha2.DefinitionReference{
				Name: "serviceexposes.core.oam.dev",
			},
		},
	}
	logf.Log.Info("Creating trait definition")
	// For some reason, traitDefinition is created as a Cluster scope object
	Expect(k8sClient.Create(ctx, &se)).Should(SatisfyAny(BeNil(), &util.AlreadyExistMatcher{}))
	close(done)
}, 300)

var _ = AfterSuite(func() {
	logf.Log.Info("Clean up resources")
	// delete the namespace with all its resources
	Expect(k8sClient.Delete(ctx, &ns, client.PropagationPolicy(metav1.DeletePropagationForeground))).Should(BeNil())
	By("Tearing down the test environment")
})
