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
	"context"
	"embed"
	"encoding/xml"
	"fmt"
	"io/fs"
	"log"
	"net/http"
	"path"
	"strings"

	v1 "k8s.io/api/core/v1"

	apierrors "k8s.io/apimachinery/pkg/api/errors"
	"k8s.io/apimachinery/pkg/types"

	"sigs.k8s.io/controller-runtime/pkg/client"
	"sigs.k8s.io/controller-runtime/pkg/client/config"
	"sigs.k8s.io/yaml"
)

func init() {
	_ = fs.WalkDir(testData, "testdata", func(path string, d fs.DirEntry, err error) error {
		path = strings.TrimPrefix(path, "testdata/")
		path = strings.TrimPrefix(path, "testdata")

		info, _ := d.Info()
		size := info.Size()
		if path == "" {
			return nil
		}
		if size == 0 {
			path += "/"
		}
		paths = append(paths, struct {
			path   string
			length int64
		}{path: path, length: size})
		return nil
	})
}

// ListBucketResult describe a file list from OSS
type ListBucketResult struct {
	Files []File `xml:"Contents"`
	Count int    `xml:"KeyCount"`
}

// File is for oss xml parse
type File struct {
	Name string `xml:"Key"`
	Size int    `xml:"Size"`
}

var (
	//go:embed testdata
	testData embed.FS
	paths    []struct {
		path   string
		length int64
	}
	// Port is mock server's exposed port
	port         = 19098
	velaRegistry = `
apiVersion: v1
data:
  registries: '{ "KubeVela":{ "name": "KubeVela", "oss": { "end_point": "http://REGISTRY_ADDR",
    "bucket": "" } } }'
kind: ConfigMap
metadata:
  name: vela-addon-registry
  namespace: vela-system
`
)

func main() {
	err := ApplyMockServerConfig()
	if err != nil {
		log.Fatal("Apply mock server config to ConfigMap fail")
	}
	log.Println("modify Configmap succeed, ready to startup mock server")
	http.HandleFunc("/", ossHandler)
	err = http.ListenAndServe(fmt.Sprintf(":%d", port), nil)
	if err != nil {
		log.Fatal("ListenAndServe: ", err)
	}
}

var ossHandler http.HandlerFunc = func(rw http.ResponseWriter, req *http.Request) {
	queryPath := strings.TrimPrefix(req.URL.Path, "/")

	if strings.Contains(req.URL.RawQuery, "prefix") {
		prefix := req.URL.Query().Get("prefix")
		res := ListBucketResult{
			Files: []File{},
			Count: 0,
		}
		for _, p := range paths {
			if strings.HasPrefix(p.path, prefix) {
				res.Files = append(res.Files, File{Name: p.path, Size: int(p.length)})
				res.Count++
			}
		}
		data, err := xml.Marshal(res)
		if err != nil {
			_, _ = rw.Write([]byte(err.Error()))
		}
		_, _ = rw.Write(data)
	} else {
		found := false
		for _, p := range paths {
			if queryPath == p.path {
				file, err := testData.ReadFile(path.Join("testdata", queryPath))
				if err != nil {
					_, _ = rw.Write([]byte(err.Error()))
				}
				found = true
				_, _ = rw.Write(file)
				break
			}
		}
		if !found {
			_, _ = rw.Write([]byte("not found"))
		}
	}
}

// ApplyMockServerConfig config mock server as addon registry
func ApplyMockServerConfig() error {
	cfg, err := config.GetConfig()
	k8sClient, err := client.New(cfg, client.Options{})
	if err != nil {
		return err
	}
	ctx := context.Background()
	originCm := v1.ConfigMap{}
	cm := v1.ConfigMap{}

	registryCmStr := strings.ReplaceAll(velaRegistry, "REGISTRY_ADDR", fmt.Sprintf("127.0.0.1:%d", port))

	err = yaml.Unmarshal([]byte(registryCmStr), &cm)
	if err != nil {
		return err
	}

	err = k8sClient.Get(ctx, types.NamespacedName{Name: cm.Name, Namespace: cm.Namespace}, &originCm)
	if err != nil && apierrors.IsNotFound(err) {
		err = k8sClient.Create(ctx, &cm)
	} else {
		cm.ResourceVersion = originCm.ResourceVersion
		err = k8sClient.Update(ctx, &cm)
	}
	return err
}
