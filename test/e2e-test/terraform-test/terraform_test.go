package main

import (
	"context"
	"fmt"
	"github.com/oam-dev/kubevela-core-api/apis/core.oam.dev/common"
	"github.com/oam-dev/kubevela-core-api/apis/core.oam.dev/v1beta1"
	"github.com/oam-dev/terraform-controller/api/types"
	"github.com/oam-dev/terraform-controller/api/v1beta2"
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
	"github.com/pkg/errors"
	"k8s.io/apimachinery/pkg/runtime"
	"os"
	"path/filepath"
	"sigs.k8s.io/controller-runtime/pkg/client"
	"sigs.k8s.io/controller-runtime/pkg/client/config"
	"sigs.k8s.io/controller-runtime/pkg/envtest/printer"
	logf "sigs.k8s.io/controller-runtime/pkg/log"
	"sigs.k8s.io/controller-runtime/pkg/log/zap"
	"sigs.k8s.io/yaml"
	"testing"
	"time"
)

func TestTerraformTest(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecsWithDefaultAndCustomReporters(t,
		"Terraform Test suite",
		[]Reporter{printer.NewlineReporter{}})
}

var (
	k8sClient client.Client
	scheme    = runtime.NewScheme()
	app       v1beta1.Application
)
var _ = BeforeSuite(func(done Done) {
	logf.SetLogger(zap.New(zap.UseDevMode(true), zap.WriteTo(GinkgoWriter)))
	By("bootstrapping test environment")
	var err error
	err = v1beta2.AddToScheme(scheme)
	Expect(err).NotTo(HaveOccurred())
	err = v1beta1.AddToScheme(scheme)
	Expect(err).NotTo(HaveOccurred())

	By("Init k8s client")
	k8sClient, err = client.New(config.GetConfigOrDie(), client.Options{Scheme: scheme})
	if err != nil {
		logf.Log.Error(err, "failed to create k8sClient")
		Fail("setup failed")
	}

	close(done)
}, 300)

var _ = Describe("Terraform Test", func() {
	ctx := context.Background()
	applyApp := func(source string) {
		By("Apply an application")
		var newApp v1beta1.Application

		Expect(ReadYamlToObject("testdata/"+source, &newApp)).Should(BeNil())
		if newApp.GetNamespace() == "" {
			newApp.SetNamespace("default")
		}
		Eventually(func() error {
			return k8sClient.Create(ctx, newApp.DeepCopy())
		}, 10*time.Second, 500*time.Millisecond).Should(Succeed())

		By("Get Application latest status")
		Eventually(
			func() *common.Revision {
				_ = k8sClient.Get(ctx, client.ObjectKey{Namespace: "default", Name: newApp.Name}, &app)
				if app.Status.LatestRevision != nil {
					return app.Status.LatestRevision
				}
				return nil
			},
			time.Second*30, time.Millisecond*500).ShouldNot(BeNil())
	}

	verifyConfigurationAvailable := func(cfgName string) {
		var config v1beta2.Configuration
		By("Verify Configuration is available")
		Eventually(
			func() error {
				if err := k8sClient.Get(ctx, client.ObjectKey{Namespace: "default", Name: cfgName}, &config); err != nil {
					return err
				}
				if config.Status.Apply.State != types.Available {
					return fmt.Errorf("configuration %s is not available, current status %s", cfgName, config.Status.Apply.State)
				}
				return nil
			}, 10*time.Minute, 2*time.Second).Should(Succeed())
	}

	verifyConfigurationDeleted := func(cfgName string) {
		var config v1beta2.Configuration
		By("Verify Configuration is deleted")
		Eventually(func() error {
			if err := k8sClient.Get(ctx, client.ObjectKey{Namespace: "default", Name: cfgName}, &config); err != nil {
				return client.IgnoreNotFound(err)
			}
			return errors.Errorf("configuration %s still exist", cfgName)
		}, 10*time.Minute, 2*time.Second).Should(Succeed())
	}

	deleteApp := func(source string) {
		By("Delete an application")
		var newApp v1beta1.Application

		Expect(ReadYamlToObject("testdata/"+source, &newApp)).Should(BeNil())

		if newApp.GetNamespace() == "" {
			newApp.SetNamespace("default")
		}
		Eventually(func() error {
			return k8sClient.Delete(ctx, newApp.DeepCopy())
		}, 10*time.Second, 500*time.Millisecond).Should(Succeed())
	}

	It("Test OSS", func() {
		applyApp("oss.yaml")
		verifyConfigurationAvailable("sample-oss")
		By("Delete application that create OSS")
		deleteApp("oss.yaml")
		verifyConfigurationDeleted("sample-oss")
	})

	PIt("Test RDS", func() {
		applyApp("rds.yaml")
		verifyConfigurationAvailable("sample-rds")
		By("Delete application that create RDS")
		deleteApp("rds.yaml")
		verifyConfigurationDeleted("sample-rds")
	})
})

// ReadYamlToObject will read a yaml K8s object to runtime.Object
func ReadYamlToObject(path string, object runtime.Object) error {
	data, err := os.ReadFile(filepath.Clean(path))
	if err != nil {
		return err
	}
	return yaml.Unmarshal(data, object)
}
