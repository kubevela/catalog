/*
Copyright 2022 The KubeVela Authors.

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

package definition_test

import (
	"context"
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"testing"
	"time"

	"github.com/fatih/color"
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
	"github.com/pkg/errors"
	"k8s.io/apimachinery/pkg/runtime"
	"k8s.io/apimachinery/pkg/types"
	clientgoscheme "k8s.io/client-go/kubernetes/scheme"
	"sigs.k8s.io/controller-runtime/pkg/client"
	"sigs.k8s.io/controller-runtime/pkg/client/config"
	logf "sigs.k8s.io/controller-runtime/pkg/log"
	"sigs.k8s.io/controller-runtime/pkg/log/zap"

	"github.com/oam-dev/kubevela-core-api/apis/core.oam.dev/common"
	"github.com/oam-dev/kubevela-core-api/apis/core.oam.dev/v1beta1"
	"sigs.k8s.io/yaml"
)

var k8sClient client.Client
var scheme = runtime.NewScheme()

func TestEnv(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "Addon Suite")
}

var _ = BeforeSuite(func(done Done) {
	By("Bootstrapping test environment")
	logf.SetLogger(zap.New(zap.UseDevMode(true), zap.WriteTo(GinkgoWriter)))
	err := clientgoscheme.AddToScheme(scheme)
	Expect(err).Should(BeNil())
	err = v1beta1.AddToScheme(scheme)
	Expect(err).Should(BeNil())
	By("Setting up kubernetes client")
	k8sClient, err = client.New(config.GetConfigOrDie(), client.Options{Scheme: scheme})
	if err != nil {
		logf.Log.Error(err, "failed to create k8sClient")
		Fail("setup failed")
	}
	By("Finished setting up test environment")
	close(done)
}, 30)

var _ = AfterSuite(func() {
	By("Tearing down test environment")

	By("Finished tearing down test environment")
})

var _ = Describe("Test definition of addons", func() {
	ctx := context.Background()

	envStr := os.Getenv("AFFECTED_ADDONS")
	addons := strings.Split(envStr, ",")

	It("Test addons", func() {
		for _, addonPath := range addons {
			if len(addonPath) == 0 {
				continue
			}
			addon := filepath.Base(addonPath)
			fmt.Printf("Begin test addon %s \n", addon)
			dir := filepath.Join("./", addon)
			files, err := os.ReadDir(dir)
			if err != nil {
				if os.IsNotExist(err) {
					fmt.Printf("Addon %s dosen't have any test case", addon)
					continue
				} else {
					Fail(err.Error())
				}
			}
			for _, file := range files {
				s, err := os.ReadFile(filepath.Join(dir, file.Name()))
				Expect(err).Should(BeNil())
				fmt.Printf("Begin to test addon %s with %s \n", addon, filepath.Join(dir, file.Name()))
				app := v1beta1.Application{}
				Expect(yaml.Unmarshal(s, &app)).Should(BeNil())
				Expect(k8sClient.Create(ctx, &app)).Should(BeNil())
				Eventually(func() error {
					checkApp := v1beta1.Application{}
					err := k8sClient.Get(ctx, types.NamespacedName{Namespace: app.Namespace, Name: app.Name}, &checkApp)
					if err != nil {
						return err
					}
					if checkApp.Status.Phase != common.ApplicationRunning {
						return fmt.Errorf("test addon %s failed, app %s is not ready yet, status is: %s", addon, app.Name, checkApp.Status.Phase)
					}
					fmt.Printf(color.GreenString("Successfully to test addon %s with %s \n", addon, filepath.Join(dir, file.Name())))
					err = k8sClient.Delete(ctx, &checkApp)
					if err != nil {
						return errors.Wrap(err, "fail to delete app")
					}
					return nil
				}, 3*time.Minute).Should(BeNil())

				Eventually(func() error {
					checkApp := v1beta1.Application{}
					err = k8sClient.Get(ctx, types.NamespacedName{Namespace: app.Namespace, Name: app.Name}, &checkApp)
					if err == nil {
						return errors.New("deleting test application")
					}
					return nil
				}, 30*time.Second).Should(BeNil())
			}
			fmt.Printf("Successfully complete whole test for addon %s \n", addon)
		}
	})

})
