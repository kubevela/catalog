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
	"errors"
	"fmt"
	"io/fs"
	"os"
	"path/filepath"

	"sigs.k8s.io/yaml"
)

// Present returns the names of the addons under dir, as their metadata.yaml
// gives them. A directory with no metadata.yaml is not an addon.
//
// It is what Prune is told the catalog holds, so it does not guess: a
// metadata.yaml that cannot be read, is not YAML or names no addon is an
// error. Skipping such an addon would report it as deleted and take its
// history out of the registry.
func Present(dir string) (map[string]struct{}, error) {
	entries, err := os.ReadDir(dir)
	if err != nil {
		return nil, err
	}
	present := map[string]struct{}{}
	for _, entry := range entries {
		if !entry.IsDir() {
			continue
		}
		path := filepath.Join(dir, entry.Name(), "metadata.yaml")
		content, err := os.ReadFile(filepath.Clean(path))
		if errors.Is(err, fs.ErrNotExist) {
			continue
		}
		if err != nil {
			return nil, err
		}
		var metadata struct {
			Name string `json:"name"`
		}
		if err := yaml.Unmarshal(content, &metadata); err != nil {
			return nil, fmt.Errorf("%s: %w", path, err)
		}
		if metadata.Name == "" {
			return nil, fmt.Errorf("%s: no name", path)
		}
		present[metadata.Name] = struct{}{}
	}
	return present, nil
}
