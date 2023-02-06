package main

import (
	"context"
	json2 "encoding/json"
	"fmt"
	"github.com/oam-dev/kubevela-core-api/apis/core.oam.dev/common"
	"github.com/oam-dev/kubevela-core-api/apis/core.oam.dev/v1beta1"
	"github.com/oam-dev/kubevela-core-api/pkg/oam/util"
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
	readApp := func(source string) v1beta1.Application {
		var newApp v1beta1.Application

		Expect(ReadYamlToObject("testdata/"+source, &newApp)).Should(BeNil())
		if newApp.GetNamespace() == "" {
			newApp.SetNamespace("default")
		}
		return newApp
	}
	applyApp := func(source string) {
		By("Apply an application")
		newApp := readApp(source)
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

	readConf := func(cfgName string) v1beta2.Configuration {
		var config v1beta2.Configuration
		Expect(k8sClient.Get(ctx, client.ObjectKey{Namespace: "default", Name: cfgName}, &config)).Should(BeNil())
		return config
	}
	verifyConfigurationAvailable := func(cfgName string) {
		By("Verify Configuration is available")
		var config v1beta2.Configuration
		Eventually(
			func() error {
				if err := k8sClient.Get(ctx, client.ObjectKey{Namespace: "default", Name: cfgName}, &config); err != nil {
					return err
				}
				if config.Status.Apply.State != types.Available {
					return fmt.Errorf("configuration %s is not available, current status %s", cfgName, config.Status.Apply.State)
				}
				return nil
			}, 20*time.Minute, 2*time.Second).Should(Succeed())
	}

	verifyConfigurationDeleted := func(cfgName string) {
		var config v1beta2.Configuration
		By("Verify Configuration is deleted")
		Eventually(func() error {
			if err := k8sClient.Get(ctx, client.ObjectKey{Namespace: "default", Name: cfgName}, &config); err != nil {
				return client.IgnoreNotFound(err)
			}
			return errors.Errorf("configuration %s still exist", cfgName)
		}, 15*time.Minute, 2*time.Second).Should(Succeed())
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
		}, 15*time.Second, 500*time.Millisecond).Should(Succeed())
	}

	It("Test OSS", func() {
		applyApp("oss.yaml")
		verifyConfigurationAvailable("sample-oss")
		By("Delete application that create OSS")
		deleteApp("oss.yaml")
		verifyConfigurationDeleted("sample-oss")
	})

	It("Test RDS", func() {
		applyApp("rds.yaml")
		verifyConfigurationAvailable("sample-rds")
		By("Delete application that create RDS")
		deleteApp("rds.yaml")
		verifyConfigurationDeleted("sample-rds")
	})

	It("Test Redis", func() {
		applyApp("redis.yaml")
		verifyConfigurationAvailable("sample-redis")
		By("Delete application that create Redis")
		deleteApp("redis.yaml")
		verifyConfigurationDeleted("sample-redis")
	})

	It("Test RDS-instance and RDS-database", func() {
		By("apply instance and database in order")
		applyApp("rds-instance.yaml")
		rdsConfName := "sample-rds-instance"
		verifyConfigurationAvailable(rdsConfName)
		cfg := readConf(rdsConfName)
		dbApp := readApp("rds-database.yaml")
		args := map[string]string{
			"existing_instance_id": cfg.Status.Apply.Outputs["instance_id"].Value,
			"region":               "cn-hangzhou",
			"database_name":        "first_database",
			"password":             "U34rfwefwefffaked",
			"account_name":         "db_account",
		}
		json, err := json2.Marshal(args)
		Expect(err).Should(BeNil())
		dbApp.Spec.Components[0].Properties = &runtime.RawExtension{Raw: json}
		Eventually(func() error {
			return k8sClient.Create(ctx, dbApp.DeepCopy())
		}).Should(Succeed())
		verifyConfigurationAvailable("sample-rds-database")

		deleteApp("rds-database.yaml")
		verifyConfigurationDeleted("sample-rds-database")
		deleteApp("rds-instance.yaml")
		verifyConfigurationDeleted(rdsConfName)
	})

	//It("Test dedicated kubernetes", func() {
	//	applyApp("dedecated-kubernetes.yaml")
	//	verifyConfigurationAvailable("sample-ack")
	//	By("Delete application that create ACK")
	//	deleteApp("dedecated-kubernetes.yaml")
	//	verifyConfigurationDeleted("sample-ack")
	//})

	It("Test ECS", func() {
		applyApp("ecs.yaml")
		verifyConfigurationAvailable("sample-ecs")
		By("Delete application that create ECS")
		deleteApp("ecs.yaml")
		verifyConfigurationDeleted("sample-ecs")
	})

	It("Test VPC/VSwitch/SecurityGroup", func() {
		applyApp("vpc.yaml")
		verifyConfigurationAvailable("sample-vpc")
		By("Get VPC ID")
		cfg := readConf("sample-vpc")
		vpc_id := cfg.Status.Apply.Outputs["VPC_ID"].Value

		By("Apply VSwitch")
		vswitchApp := readApp("vswitch.yaml")
		comp := vswitchApp.GetComponent("alibaba-vswitch")
		Expect(comp).ShouldNot(BeNil())
		args, err := util.RawExtension2Map(comp.Properties)
		Expect(err).Should(BeNil())
		args["vpc_id"] = vpc_id
		comp.Properties = util.Object2RawExtension(args)
		// this is only one comp
		vswitchApp.Spec.Components[0] = *comp
		err = k8sClient.Create(ctx, vswitchApp.DeepCopy())
		Expect(err).Should(BeNil())
		verifyConfigurationAvailable("sample-vswitch")

		By("Apply Security Group")
		secGroupApp := readApp("security-group.yaml")
		comp = secGroupApp.GetComponent("alibaba-security-group")
		Expect(comp).ShouldNot(BeNil())
		args, err = util.RawExtension2Map(comp.Properties)
		Expect(err).Should(BeNil())
		args["vpc_id"] = vpc_id
		comp.Properties = util.Object2RawExtension(args)
		// this is only one comp
		secGroupApp.Spec.Components[0] = *comp
		err = k8sClient.Create(ctx, secGroupApp.DeepCopy())
		Expect(err).Should(BeNil())
		verifyConfigurationAvailable("sample-sg")

		By("Delete application that create VPC/VSwitch/SecurityGroup")
		deleteApp("security-group.yaml")
		verifyConfigurationDeleted("sample-sg")
		deleteApp("vswitch.yaml")
		verifyConfigurationDeleted("sample-vswitch")
		deleteApp("vpc.yaml")
		verifyConfigurationDeleted("sample-vpc")
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
