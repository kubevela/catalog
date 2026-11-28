/*
Copyright 2026 The KubeVela Authors.

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

package registry

import (
	"os"
	"path/filepath"
	"reflect"
	"testing"
)

// catalog writes a directory of addons: name of the directory to the content
// of its metadata.yaml. An empty content means no metadata.yaml.
func catalog(t *testing.T, addons map[string]string) string {
	dir := t.TempDir()
	for name, metadata := range addons {
		if err := os.MkdirAll(filepath.Join(dir, name), 0o755); err != nil {
			t.Fatal(err)
		}
		if metadata == "" {
			continue
		}
		if err := os.WriteFile(filepath.Join(dir, name, "metadata.yaml"), []byte(metadata), 0o600); err != nil {
			t.Fatal(err)
		}
	}
	return dir
}

func TestPresentNamesAddonsByTheirMetadata(t *testing.T) {
	dir := catalog(t, map[string]string{
		"fluxcd":        "name: fluxcd\nversion: 1.0.0\n",
		"renamed-dir":   "name: velaux\nversion: 2.0.0\n",
		"not-an-addon":  "",
		"another-addon": "name: another-addon\n",
	})
	// A file beside the addon directories is not an addon either.
	if err := os.WriteFile(filepath.Join(dir, "index.yaml"), []byte("x"), 0o600); err != nil {
		t.Fatal(err)
	}

	present, err := Present(dir)
	if err != nil {
		t.Fatal(err)
	}
	want := map[string]struct{}{"fluxcd": {}, "velaux": {}, "another-addon": {}}
	if !reflect.DeepEqual(want, present) {
		t.Errorf("got %v, want %v", present, want)
	}
}

// An addon whose metadata cannot be understood must stop the publish. Leaving
// it out would look like a deletion and drop its history from the registry.
func TestPresentRefusesACatalogItCannotReadReliably(t *testing.T) {
	testcases := map[string]string{
		"metadata that is not YAML": "name: [unclosed\n",
		"metadata without a name":   "version: 1.0.0\n",
	}
	for name, metadata := range testcases {
		t.Run(name, func(t *testing.T) {
			dir := catalog(t, map[string]string{
				"good":   "name: good\n",
				"broken": metadata,
			})
			present, err := Present(dir)
			if err == nil {
				t.Fatalf("want an error, got %v", present)
			}
		})
	}
}

func TestPresentRefusesADirectoryThatIsNotThere(t *testing.T) {
	if _, err := Present(filepath.Join(t.TempDir(), "missing")); err == nil {
		t.Fatal("want an error")
	}
}
