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
	"reflect"
	"testing"

	"helm.sh/helm/v3/pkg/chart"
	"helm.sh/helm/v3/pkg/repo"
)

func versions(name string, vs ...string) repo.ChartVersions {
	var out repo.ChartVersions
	for _, v := range vs {
		out = append(out, &repo.ChartVersion{Metadata: &chart.Metadata{Name: name, Version: v}})
	}
	return out
}

func names(index *repo.IndexFile) map[string]int {
	out := map[string]int{}
	for name, entry := range index.Entries {
		out[name] = len(entry)
	}
	return out
}

func TestPruneDropsAddonsNoLongerInTheCatalog(t *testing.T) {
	published := &repo.IndexFile{Entries: map[string]repo.ChartVersions{
		"kept":      versions("kept", "1.0.0", "1.1.0"),
		"removed-a": versions("removed-a", "1.0.0"),
		"removed-b": versions("removed-b", "0.1.0", "0.2.0"),
	}}

	removed := Prune(published, map[string]struct{}{"kept": {}, "new": {}})

	if want := []string{"removed-a", "removed-b"}; !reflect.DeepEqual(want, removed) {
		t.Errorf("removed: got %v, want %v", removed, want)
	}
	// Every published version of an addon still in the catalog stays.
	if want := map[string]int{"kept": 2}; !reflect.DeepEqual(want, names(published)) {
		t.Errorf("entries left: got %v, want %v", names(published), want)
	}
}

func TestPruneLeavesAnIndexWhoseAddonsAreAllPresent(t *testing.T) {
	published := &repo.IndexFile{Entries: map[string]repo.ChartVersions{
		"a": versions("a", "1.0.0"),
		"b": versions("b", "1.0.0"),
	}}

	removed := Prune(published, map[string]struct{}{"a": {}, "b": {}})

	if len(removed) != 0 {
		t.Errorf("removed: got %v, want none", removed)
	}
	if want := map[string]int{"a": 1, "b": 1}; !reflect.DeepEqual(want, names(published)) {
		t.Errorf("entries left: got %v, want %v", names(published), want)
	}
}

func TestPruneOfAnEmptyIndex(t *testing.T) {
	if removed := Prune(&repo.IndexFile{}, map[string]struct{}{"a": {}}); len(removed) != 0 {
		t.Errorf("removed: got %v, want none", removed)
	}
}
