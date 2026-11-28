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

// Package registry holds the parts of the addon registry's publishing that
// can be tested without a network.
package registry

import (
	"sort"

	"helm.sh/helm/v3/pkg/repo"
)

// Prune removes from the published index every addon that is not in present,
// the addons the catalog holds now, and returns the names it removed, sorted.
//
// The published index is carried forward on each publish so that the older
// versions of an addon stay installable. Without pruning, that also carries
// forward addons deleted from the catalog, which would then never leave the
// registry.
func Prune(published *repo.IndexFile, present map[string]struct{}) []string {
	var removed []string
	for name := range published.Entries {
		if _, ok := present[name]; !ok {
			removed = append(removed, name)
		}
	}
	sort.Strings(removed)
	for _, name := range removed {
		delete(published.Entries, name)
	}
	return removed
}
