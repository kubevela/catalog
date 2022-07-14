/*
Copyright 2021 The KubeVela Authors.

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

package main

import (
	"fmt"
	"io/ioutil"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"strings"

	"sigs.k8s.io/yaml"
)

type AddonMeta struct {
	Name string `json:"name"`
	Dependencies []Dependency `json:"dependencies"`
}

type Dependency struct {
	Name string `json:"name"`
}

var file = "addons/velaux/template.yaml"
var regexPattern = "^addons.*"
var globalRexPattern = "^.github.*|makefile|.*.go"

// This can be used for pending some error addon temporally, Please fix it as soon as posible.
var pendingAddon = map[string]bool{"ocm-gateway-manager-addon": true, "model-serving": true}

func main() {
	changedFile := os.Args[1:]
	changedAddon := determineNeedEnableAddon(changedFile)
	if len(changedAddon) == 0 {
		return
	}
	if err := enableAddonsByOrder(changedAddon); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}

// will check all needed enabled addons according to changed files.
func determineNeedEnableAddon (changedFile []string) map[string]bool {
	needEnabledAddon := map[string]bool{}
	globalRex := regexp.MustCompile(globalRexPattern)
	regx := regexp.MustCompile(regexPattern)
	for _, s := range changedFile {
		regRes := regx.Find([]byte(s))
		if len(regRes) != 0 {
			fmt.Println(string(regRes))
			list := strings.Split(string(regRes), "/")
			if len(list) > 1 {
				addon := list[1]
				needEnabledAddon[addon] = true
			}
		}

		// if .github/makefile/*.go files changed, that will change the CI, so enable all addons.
		if regRes := globalRex.Find([]byte(s)); len(regRes) != 0 {
			// change CI related file, must test all addons
			err := putInAllAddons(needEnabledAddon)
			if err != nil {
				return nil
			} else {
				fmt.Println("This pr need checkAll addons")
				return needEnabledAddon
			}
		}
	}

	for addon := range needEnabledAddon {
		 if err := checkAffectedAddon(addon, needEnabledAddon); err != nil {
		 	panic(err)
		 }
	}

	for addon := range needEnabledAddon {
		checkAddonDependency(addon, needEnabledAddon)
	}

	fmt.Printf("This pr need test addons: ")
	for ca := range needEnabledAddon {
		fmt.Printf("%s,", ca)
	}
	fmt.Printf("\n")
	return needEnabledAddon
}

// check affected addon.
// eg: If fluxcd addon changed, should enable addons those dependent fluxcd addon.
func checkAffectedAddon(addonName string, needEnabledAddon map[string]bool) error {
	dir, err := ioutil.ReadDir("./addons")
	if err != nil {
		return err
	}
	for _, subDir := range  dir {
		if subDir.IsDir() {
			meta, err := readAddonMeta(subDir.Name())
			if err != nil {
				return err
			}
			if len(meta.Dependencies) != 0 {
				for _, dependency := range meta.Dependencies {
					if dependency.Name == addonName {
						needEnabledAddon[meta.Name] = true
					}
				}
			}
		}
	}
	return nil
}

func putInAllAddons (addons map[string]bool) error {
	dir, err := ioutil.ReadDir("./addons")
	if err != nil {
		return err
	}
	for _, subDir := range  dir {
		if subDir.IsDir() {
			fmt.Println(subDir.Name())
			addons[subDir.Name()] = true
		}
	}
	return nil
}

// these addons are depended by changed addons.
func checkAddonDependency(addon string, changedAddon map[string]bool ) {
	meta, err := readAddonMeta(addon)
	if err != nil {
		panic(err)
	}
	for _, dep := range meta.Dependencies {
		changedAddon[dep.Name] = true
		checkAddonDependency(dep.Name, changedAddon)
	}
}

func readAddonMeta(addonName string) (*AddonMeta, error) {
	metaFile, err := os.ReadFile(filepath.Join([]string{"addons", addonName, "metadata.yaml"}...))
	if err != nil {
		panic(err)
	}
	meta := AddonMeta{}
	err = yaml.Unmarshal(metaFile, &meta)
	if err != nil {
		return nil, err
	}
	return &meta, nil
}

// This func will enable addon by order rely-on addon's relationShip dependency,
// this func is so dummy now that the order is written manually, we can generated a dependency DAG workflow in the furture.
func enableAddonsByOrder (changedAddon map[string]bool)  error {
	dirPattern := "addons/%s"
	if changedAddon["fluxcd"] {
		if err := enableOneAddon(fmt.Sprintf(dirPattern, "fluxcd")); err != nil {
			return err
		}
		changedAddon["fluxcd"] = false
	}
	if changedAddon["terraform"] {
		if err := enableOneAddon(fmt.Sprintf(dirPattern, "terraform")); err != nil {
			return err
		}
		changedAddon["terraform"] = false
	}
	if changedAddon["velaux"] {
		if err := enableOneAddon(fmt.Sprintf(dirPattern, "velaux")); err != nil {
			return err
		}
		changedAddon["velaux"] = false
	}
	if changedAddon["cert-manager"] {
		if err := enableOneAddon(fmt.Sprintf(dirPattern, "cert-manager")); err != nil {
			return err
		}
		changedAddon["cert-manager"] = false
	}
	for s, b := range changedAddon {
		if b && !pendingAddon[s] {
			if err := enableOneAddon(fmt.Sprintf(dirPattern, s)); err != nil {
				return err
			}
			if err := disableOneAddon(s); err != nil {
				return err
			}
			switch s {
			case "dex":
				if err := disableOneAddon("velaux"); err != nil {
					return err
				}
			case "flink-kubernetes-operator":
				if err := disableOneAddon("cert-manager"); err != nil {
					return err
				}
			}
		}
	}
	return nil
}

func enableOneAddon(dir string) error {
	cmd := exec.Command("vela","addon", "enable", dir)
	fmt.Println(cmd.String())
	stdout, err := cmd.StdoutPipe()
	cmd.Stderr = cmd.Stdout
	if err != nil {
		panic(err)
	}
	if err = cmd.Start(); err != nil {
		return err
	}
	for {
		tmp := make([]byte, 1024)
		_, err := stdout.Read(tmp)
		fmt.Print(string(tmp))
		if err != nil {
			break
		}
	}
	if err = cmd.Wait(); err != nil {
		return err
	}
	return nil
}

func disableOneAddon (addonName string) error {
	cmd := exec.Command("vela","addon", "disable", addonName)
	fmt.Println(cmd.String())
	stdout, err := cmd.StdoutPipe()
	cmd.Stderr = cmd.Stdout
	if err != nil {
		panic(err)
	}
	if err = cmd.Start(); err != nil {
		return err
	}
	for {
		tmp := make([]byte, 1024)
		_, err := stdout.Read(tmp)
		fmt.Print(string(tmp))
		if err != nil {
			break
		}
	}
	if err = cmd.Wait(); err != nil {
		return err
	}
	return nil
}


// this func can be used for debug when addon enable failed.
func checkAppStatus(addonName string)  {
	cmd := exec.Command("vela","status", "-n", "vela-system", "addon-" + addonName)
	fmt.Println(cmd.String())
	stdout, err := cmd.StdoutPipe()
	cmd.Stderr = cmd.Stdout
	if err != nil {
		panic(err)
	}
	if err = cmd.Start(); err != nil {
		fmt.Println(err)
	}
	for {
		tmp := make([]byte, 1024)
		_, err := stdout.Read(tmp)
		fmt.Print(string(tmp))
		if err != nil {
			break
		}
	}
	if err = cmd.Wait(); err != nil {
		fmt.Println(err)
	}
}

// this func can be used for debug when addon enable failed.
func checkPodStatus(namespace string) {
	cmd := exec.Command("kubectl","get pods", "-n", namespace)
	fmt.Println(cmd.String())
	stdout, err := cmd.StdoutPipe()
	cmd.Stderr = cmd.Stdout
	if err != nil {
		panic(err)
	}
	if err = cmd.Start(); err != nil {
		fmt.Println(err)
	}
	for {
		tmp := make([]byte, 1024)
		_, err := stdout.Read(tmp)
		fmt.Print(string(tmp))
		if err != nil {
			break
		}
	}
	if err = cmd.Wait(); err != nil {
		fmt.Println(err)
	}
}
