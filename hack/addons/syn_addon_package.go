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
	"io"
	"net/http"
	"os"
	"path"
	"path/filepath"
	"time"

	"github.com/Masterminds/semver/v3"
	"github.com/oam-dev/kubevela/pkg/addon"
	"helm.sh/helm/v3/pkg/chart"
	"helm.sh/helm/v3/pkg/repo"
	"sigs.k8s.io/yaml"
)

type Metadata struct {
	Name          string              `json:"name" validate:"required"`
	Version       string              `json:"version"`
	Description   string              `json:"description"`
	Icon          string              `json:"icon"`
	URL           string              `json:"url,omitempty"`
	Tags          []string            `json:"tags,omitempty"`
	NeedNamespace []string            `json:"needNamespace,omitempty"`
	Invisible     bool                `json:"invisible"`
	System        *SystemRequirements `json:"system"`
}

type SystemRequirements struct {
	Vela       string `json:"vela"`
	Kubernetes string `json:"kubernetes"`
}

func main() {
	dir := os.Args[1]
	f, err := os.ReadDir(dir)
	if err != nil {
		fmt.Println(err)
		return
	}
	repoURL := os.Args[2]

	if len(repoURL) == 0 {
		fmt.Println("Please set repoURL")
		return
	}

	originIndex := &repo.IndexFile{}

	body, err := http.Get(repoURL + "/index.yaml")
	if err != nil {
		fmt.Println(err)
		return
	}
	if body.StatusCode != 404 {
		indexByte, err := io.ReadAll(body.Body)
		if err != nil {
			fmt.Println(err)
			return
		}
		if len(indexByte) != 0 {
			err := yaml.UnmarshalStrict(indexByte, originIndex)
			if err != nil {
				fmt.Println(err)
			}
		}
	}

	for chartName, entry := range originIndex.Entries {
		var q repo.ChartVersions
		for _, v := range entry {
			if _, err := semver.NewVersion(v.Version); err != nil {
				continue
			}
			q = append(q, v)
			err := saveAddonToLocal(dir, v.URLs[0])
			if err != nil {
				fmt.Println("error save addon to local, skip:", err)
				continue
			}
		}
		originIndex.Entries[chartName] = q
	}

	entries := map[string]repo.ChartVersions{}
	for _, info := range f {
		if !info.IsDir() {
			continue
		}
		f, err := os.ReadFile(filepath.Join(dir, info.Name(), "metadata.yaml"))
		if err != nil {
			fmt.Println(err)
			continue
		}
		m := Metadata{}
		err = yaml.Unmarshal(f, &m)
		if err != nil {
			fmt.Println(err)
			return
		}
		entry := repo.ChartVersions{}
		chartVersion := &repo.ChartVersion{Metadata: &chart.Metadata{Name: m.Name,
			Version: m.Version, Icon: m.Icon, Keywords: m.Tags, Description: m.Description,
			Home: m.URL, Annotations: map[string]string{}}, Created: time.Now(), URLs: []string{repoURL + "/" + m.Name + "-" + m.Version + ".tgz"}}

		if m.System != nil {
			if len(m.System.Kubernetes) != 0 {
				chartVersion.Metadata.Annotations["system.kubernetes"] = m.System.Kubernetes
			}
			if len(m.System.Vela) != 0 {
				chartVersion.Metadata.Annotations["system.vela"] = m.System.Vela
			}
		}

			entry = append(entry, chartVersion)
			entries[m.Name] = entry
			filename, err := addon.PackageAddon(dir + info.Name() + "/")
			if err != nil {
				fmt.Println(err)
			} else {
				fmt.Printf("addon package %s \n", filename)
		}
	}
	index := repo.IndexFile{APIVersion: "v1", Entries: entries}

	index.Merge(originIndex)
	out, err := yaml.Marshal(index)
	if err != nil {
		fmt.Println(err)
		return
	}
	err = os.WriteFile(dir+"/index.yaml", out, os.ModePerm)
	if err != nil {
		fmt.Println(err)
	}

	fmt.Println("handle over")
}

// saveAddonToLocal download addon package
func saveAddonToLocal(dir, url string) error {
	filename := path.Base(url)
	fmt.Println("downloading chart:", filename)
	resp, err := http.Get(url)
	if err != nil {
		return err
	}
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusOK {
		fmt.Println("download chart failed:", resp.StatusCode)
		return fmt.Errorf("download chart failed: %d, url=%s", resp.StatusCode, url)
	}
	out, err := os.Create(dir + filename)
	if err != nil {
		return err
	}
	defer out.Close()
	_, err = io.Copy(out, resp.Body)
	return err
}
