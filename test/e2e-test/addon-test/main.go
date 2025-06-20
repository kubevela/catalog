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
	"net/http"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"strings"
	"unicode"

	"github.com/pkg/errors"
	"helm.sh/helm/v3/pkg/repo"
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
	addonPattern             = "^addons.*"
	experimentalAddonPattern = "^experimental/addons.*"
	testCasePattern          = "^test/e2e-test/addon-test/definition-test/testdata.*"
	globalRexPattern         = "^.github.*|Makefile|.*.go"
	pendingAddonFilename     = "test/e2e-test/addon-test/PENDING"
	defTestDir               = "test/e2e-test/addon-test/definition-test/testdata/"
	repoURL                  = "https://addons.kubevela.net"
	experimentalRepoURL      = "https://addons.kubevela.net/experimental"
)

func main() {
	err := readPendingAddons()
	if err != nil {
		fmt.Fprintf(os.Stderr, "%s", err)
		os.Exit(1)
	}
	if os.Getenv("LOOPCHECK") == "true" {
		err := loopCheck()
		if err != nil {
			fmt.Println(err)
			os.Exit(1)
		}
		os.Exit(0)
	}
	changedFile := os.Args[1:]

	if err := checkUpgradeAddonVersion(changedFile); err != nil {
		fmt.Fprintf(os.Stderr, "%s", err)
		os.Exit(1)
	}

	changedAddon := determineNeedEnableAddon(changedFile)
	if len(changedAddon) == 0 {
		return
	}
	if _, err := enableAddonsByOrder("addons/%s", changedAddon, false); err != nil {
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
		fmt.Printf("  - \033[1;33m%s\033[1;0m\n", t)
	}
	if err := scanner.Err(); err != nil {
		return err
	}
	return nil
}

// will check all needed enabled addons according to changed files.
func determineNeedEnableAddon(changedFile []string) []string {
	allAddons, err := readAllAddons()
	if err != nil {
		panic(err)
	}
	addonRegex := func() string {
		res := ""
		for _, addon := range allAddons {
			res += addon + "|"
		}
		return strings.TrimSuffix(res, "|")
	}()
	metaChanged := genAffectedFromChangedFiles(changedFile, addonPattern, addonRegex)
	fmt.Printf("Changing addons: %s \n", metaChanged)
	testAffectedAddon := genAffectedFromChangedFiles(changedFile, testCasePattern, addonRegex)
	fmt.Printf("Changing tests of addons: %s \n", testAffectedAddon)

	changedAddons := MergeSlice(true, metaChanged, testAffectedAddon)

	for _, addon := range changedAddons {
		changedAddons = MergeSlice(true, changedAddons, checkAffectedAddon(addon))
	}

	for _, addon := range changedAddons {
		changedAddons = MergeSlice(false, changedAddons, checkAddonDependency(addon))
	}

	fmt.Printf("This PR need to test the addons: %s \n", changedAddons)
	return changedAddons
}

func checkUpgradeAddonVersion(changedFiles []string) error {
	filesMap := map[string]bool{}
	for _, changedFile := range changedFiles {
		filesMap[changedFile] = true
	}
	for _, changedFile := range changedFiles {
		if !strings.HasPrefix(changedFile, "addons/") && !strings.HasPrefix(changedFile, "experimental/addons/") {
			continue
		}

		if strings.HasPrefix(changedFile, "addons/") {
			elem := strings.Split(changedFile, "/")
			if len(elem) < 2 {
				continue
			}
			addon := elem[1]
			if !filesMap[filepath.Join("addons", addon, "metadata.yaml")] {
				return fmt.Errorf("changing file: %s without upgrading the newer version of addon: %s", changedFile, addon)
			}
		}
		if strings.HasPrefix(changedFile, "experimental/addons/") {
			elem := strings.Split(changedFile, "/")
			if len(elem) < 4 {
				continue
			}
			addon := elem[2]
			if !filesMap[filepath.Join("experimental", "addons", addon, "metadata.yaml")] {
				return fmt.Errorf("changing file: %s without upgrading the version of addon: %s", changedFile, addon)
			}
		}

	}
	return nil
}

func genAffectedFromChangedFiles(changedFile []string, filter string, regexPattern string) []string {
	needEnabledAddon := map[string]bool{}
	var needEnabledAddons []string
	globalRex := regexp.MustCompile(globalRexPattern)
	regx := regexp.MustCompile(regexPattern)
	filterRegex := regexp.MustCompile(filter)
	for _, s := range changedFile {
		if len(filterRegex.FindString(s)) == 0 {
			continue
		}

		regRes := regx.FindString(s)
		if len(regRes) != 0 {
			fmt.Println(regRes)
			if needEnabledAddon[regRes] == false {
				needEnabledAddon[regRes] = true
				needEnabledAddons = append([]string{regRes}, needEnabledAddons...)
			}
			continue
		}

		// if .github/makefile/*.go files changed, that will change the CI, so enable all addons.
		if regRes := globalRex.Find([]byte(s)); len(regRes) != 0 {
			// change CI related file, must test all addons
			all, err := readAllAddons()
			if err != nil {
				panic(err)
			} else {
				fmt.Println("This pr need checkAll addons")
				return all
			}
		}
	}
	return needEnabledAddons
}

// check affected addon.
// eg: If fluxcd addon changed, should enable addons those dependent fluxcd addon.
func checkAffectedAddon(addonName string) []string {
	dir, err := os.ReadDir("./addons")
	if err != nil {
		panic(err)
	}
	needEnabledAddonMap := make(map[string]bool)
	var needEnabledAddon []string
	for _, subDir := range dir {
		if subDir.IsDir() {
			meta, err := readAddonMeta(subDir.Name())
			if err != nil {
				panic(err)
			}
			if len(meta.Dependencies) != 0 {
				for _, dependency := range meta.Dependencies {
					if dependency.Name == addonName {
						if needEnabledAddonMap[meta.Name] == false {
							needEnabledAddonMap[meta.Name] = true
							needEnabledAddon = append(needEnabledAddon, meta.Name)
						}
					}
				}
			}
		}
	}
	return needEnabledAddon
}

func readAllAddons() ([]string, error) {
	dir, err := os.ReadDir("./addons")
	if err != nil {
		return nil, err
	}
	var addons []string
	for _, subDir := range dir {
		if subDir.IsDir() {
			fmt.Println(subDir.Name())
			addons = append(addons, subDir.Name())
		}
	}
	return addons, nil
}

// these addons are depended by changed addons.
func checkAddonDependency(addon string) []string {
	meta, err := readAddonMeta(addon)
	if err != nil {
		panic(err)
	}
	var deps []string
	for _, dep := range meta.Dependencies {
		deps = append(deps, dep.Name)
	}
	for _, dep := range deps {
		deps = MergeSlice(false, checkAddonDependency(dep), deps)
	}
	return deps
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
func enableAddonsByOrder(dirPattern string, changedAddon []string, loopCheck bool) ([]string, error) {
	var failedAddons []string
	for _, addon := range changedAddon {
		fmt.Println(addon)
		if !pendingAddon[addon] {
			if err := enableOneAddon(fmt.Sprintf(dirPattern, addon)); err != nil {
				if loopCheck {
					failedAddons = append(failedAddons, addon)
					continue
				}
				if err := disableOneAddon(addon); err != nil {
					return nil, err
				}
				return nil, err
			}
		}
	}

	return failedAddons, nil
}

func enableOneAddon(dir string) error {
	var cmd *exec.Cmd
	switch {
	case strings.Contains(dir, "fluxcd"):
		cmd = exec.Command("vela", "addon", "enable", dir, "onlyHelmComponents=true")
	case strings.Contains(dir, "loki"):
		cmd = exec.Command("vela", "addon", "enable", dir, "serviceType=NodePort")
	default:
		cmd = exec.Command("vela", "addon", "enable", dir)
	}

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
		tmp := make([]byte, 102400)
		_, err := stdout.Read(tmp)
		str := convertToString(tmp)
		if strings.Contains(str, "It is now in phase") {
			continue
		}
		fmt.Print(str)
		if err != nil {
			break
		}
	}
	if err = cmd.Wait(); err != nil {
		checkAppStatus(dir)
		return err
	}
	fmt.Printf("Enable addon %s successfully, try to test definition in the addon \n", dir)
	err = testDefinitionsInAddons(dir)
	if err != nil {
		return errors.Wrap(err, fmt.Sprintf("failed tp test definition of addon %s", dir))
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
		tmp := make([]byte, 102400)
		_, err := stdout.Read(tmp)
		str := convertToString(tmp)
		fmt.Print(str)
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

// convertToString converts []byte to string and removes unprintable characters
func convertToString(data []byte) string {
	// Remove enabling countdown, otherwise we cannot see anything in CI logs.
	// There are unprintable characters everywhere and the log is huge.
	return strings.Map(func(r rune) rune {
		if unicode.IsPrint(r) || r == '\n' {
			return r
		}
		return -1
	}, string(data))
}

func testDefinitionsInAddons(addons string) error {
	addonName := filepath.Base(addons)
	_, err := os.Stat(defTestDir + addonName)
	if os.IsNotExist(err) {
		fmt.Println("There is no test cases for this addon, skip the test.")
		return nil
	}
	if err != nil {
		return err
	}
	cmd := exec.Command("go", "test", "-v", "test/e2e-test/addon-test/definition-test/suit_test.go")
	fmt.Println(cmd.String())
	cmd.Env = os.Environ()
	cmd.Env = append(cmd.Env, fmt.Sprintf("AFFECTED_ADDONS=%s", addons))
	stdout, err := cmd.StdoutPipe()
	cmd.Stderr = cmd.Stdout
	if err != nil {
		panic(err)
	}
	if err = cmd.Start(); err != nil {
		fmt.Println(err)
	}
	for {
		tmp := make([]byte, 4096)
		_, err := stdout.Read(tmp)
		fmt.Print(string(tmp))
		if err != nil {
			break
		}
	}
	if err = cmd.Wait(); err != nil {
		fmt.Println(err)
		return err
	}
	return nil
}

// logic below is about loop check
func loopCheck() error {
	fmt.Println("Begin the process of loop check addon")
	addons, err := calculateAddonsNameFromRepoUrl(repoURL)
	if err != nil {
		return err
	}
	failedAddons, err := enableAddonsByOrder("%s", addons, true)
	failed := false
	if len(failedAddons) != 0 {
		os.WriteFile("/root/failed-addons", []byte(fmt.Sprint(failedAddons)), 0644)
		failed = true
	}
	expAddons, err := calculateAddonsNameFromRepoUrl(experimentalRepoURL)
	if err != nil {
		return err
	}
	failedAddons, _ = enableAddonsByOrder("%s", expAddons, true)
	if len(failedAddons) != 0 {
		os.WriteFile("/root/failed-exp-addons", []byte(fmt.Sprint(failedAddons)), 0644)
		failed = true
	}
	if failed {
		return fmt.Errorf("failed to loop check addons")
	}
	return nil
}

func calculateAddonsNameFromRepoUrl(url string) ([]string, error) {
	index := repo.IndexFile{}
	body, err := http.Get(url + "/index.yaml")
	if err != nil {
		fmt.Println(err)
		return nil, fmt.Errorf("failed to fetch index.yaml from %s", url)
	}
	if body.StatusCode != 200 {
		return nil, fmt.Errorf("fetch idnex.yaml meeting not 200 http code")
	}
	indexByte, err := ioutil.ReadAll(body.Body)
	if err != nil || len(indexByte) == 0 {
		fmt.Println(err)
		return nil, fmt.Errorf("failed to ready index bytes")
	}
	err = yaml.UnmarshalStrict(indexByte, &index)
	if err != nil {
		return nil, fmt.Errorf("faled to unmarshall index struct")
	}
	var addons []string
	for addon, _ := range index.Entries {
		addons = append(addons, addon)
	}
	return addons, nil
}

func MergeSlice(right bool, source []string, target []string) []string {
	if len(source) == 0 {
		return target
	}
	if len(target) == 0 {
		return source
	}
	var smap = make(map[string]bool, len(source))
	for _, s := range source {
		smap[s] = true
	}
	for _, t := range target {
		if !smap[t] {
			if right {
				source = append(source, t)
			} else {
				source = append([]string{t}, source...)
			}
		}
	}
	return source
}
