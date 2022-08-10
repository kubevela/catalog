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
	"bufio"
	"fmt"
	"io/ioutil"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"strings"
	"unicode"

	"sigs.k8s.io/yaml"
)

type AddonMeta struct {
	Name         string       `json:"name"`
	Dependencies []Dependency `json:"dependencies"`
}

type Dependency struct {
	Name string `json:"name"`
}

var file = "addons/velaux/template.yaml"
var pendingAddon = map[string]bool{}

const (
	regexPattern         = "^addons.*"
	globalRexPattern     = "^.github.*|Makefile|.*.go"
	pendingAddonFilename = "test/e2e-test/addon-test/PENDING"
)

func main() {
	err := readPendingAddons()
	if err != nil {
		fmt.Fprintf(os.Stderr, "%s", err)
		os.Exit(1)
	}
	changedFile := os.Args[1:]
	changedAddon := determineNeedEnableAddon(changedFile)
	if len(changedAddon) == 0 {
		return
	}
	if err := enableAddonsByOrder(changedAddon); err != nil {
		fmt.Fprintf(os.Stderr, "%s", err)
		os.Exit(1)
	}
}

func readPendingAddons() error {
	file, err := os.Open(pendingAddonFilename)
	if err != nil {
		return err
	}
	defer file.Close()
	fmt.Println("\033[1;31mThese addons are ignored temporarily.\033[0m")
	fmt.Println("\033[1;31mPlease fix them as soon as possible!\033[0m")
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		t := scanner.Text()
		// This is a comment, ignore it.
		if t == "" || strings.HasPrefix(t, "#") {
			continue
		}
		pendingAddon[t] = true
		fmt.Printf("\t\033[1;33m%s\033[1;0m\n", t)
	}
	if err := scanner.Err(); err != nil {
		return err
	}
	return nil
}

// will check all needed enabled addons according to changed files.
func determineNeedEnableAddon(changedFile []string) map[string]bool {
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
	for _, subDir := range dir {
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

func putInAllAddons(addons map[string]bool) error {
	dir, err := ioutil.ReadDir("./addons")
	if err != nil {
		return err
	}
	for _, subDir := range dir {
		if subDir.IsDir() {
			fmt.Println(subDir.Name())
			addons[subDir.Name()] = true
		}
	}
	return nil
}

// these addons are depended by changed addons.
func checkAddonDependency(addon string, changedAddon map[string]bool) {
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
func enableAddonsByOrder(changedAddon map[string]bool) error {
	dirPattern := "addons/%s"
	// TODO: make topology sort to auto sort the order of enable
	for _, addonName := range []string{"fluxcd", "terraform", "velaux", "cert-manager"} {
		if changedAddon[addonName] && !pendingAddon[addonName] {
			if err := enableOneAddon(fmt.Sprintf(dirPattern, addonName)); err != nil {
				return err
			}
			changedAddon[addonName] = false
		}
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
	cmd := exec.Command("vela", "addon", "enable", dir)
	fmt.Println("\033[1;32m==> " + cmd.String() + "\033[0m")
	stdout, err := cmd.StdoutPipe()
	cmd.Stderr = cmd.Stdout
	if err != nil {
		panic(err)
	}
	if err = cmd.Start(); err != nil {
		return err
	}
	for {
		tmp := make([]byte, 81920)
		_, err := stdout.Read(tmp)
		// Remove enabling countdown, otherwise we cannot see anything in CI logs.
		// There are unprintable characters everywhere and the log is huge.
		str := strings.Map(func(r rune) rune {
			if unicode.IsPrint(r) || r == '\n' {
				return r
			}
			return -1
		}, string(tmp))
		if strings.Contains(str, "It is now in phase") {
			continue
		}
		fmt.Println(str)
		if err != nil {
			break
		}
	}
	if err = cmd.Wait(); err != nil {
		checkAppStatus(dir)
		return err
	}
	return nil
}

func disableOneAddon(addonName string) error {
	cmd := exec.Command("vela", "addon", "disable", addonName)
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
func checkAppStatus(addonName string) {
	cmd := exec.Command("vela", "status", "-n", "vela-system", "addon-"+filepath.Base(addonName))
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
	cmd := exec.Command("kubectl", "get pods", "-n", namespace)
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
