package main

import (
	"encoding/json"
	"os"
	"path/filepath"
	"reflect"
	"strings"
	"testing"

	"k8s.io/apimachinery/pkg/labels"
)

func TestCollectEmptyMarshalsAsList(t *testing.T) {
	defs, errs := collect(nil, "")
	if got := mustJSON(defs); got != "[]" {
		t.Errorf("definitions = %s, want []", got)
	}
	if got := mustJSON(errs); got != "[]" {
		t.Errorf("errors = %s, want []", got)
	}
}

func TestRedact(t *testing.T) {
	for in, want := range map[string]string{
		"https://github.com/org/defs":                       "https://github.com/org/defs",
		"https://x-access-token:s3cret@github.com/org/defs": "https://github.com/org/defs",
		"https://s3cret@github.com/org/defs":                "https://github.com/org/defs",
		"git@github.com:org/defs.git":                       "git@github.com:org/defs.git",
		"":                                                  "",
	} {
		if got := redact(in); got != want {
			t.Errorf("redact(%q) = %q, want %q", in, got, want)
		}
	}
}

func TestCloneErrorRedactsCredentials(t *testing.T) {
	_, err := clone("https://user:s3cret@host/defs?%0a", "main")
	if err == nil {
		t.Fatal("clone of an unreachable remote succeeded")
	}
	if strings.Contains(err.Error(), "s3cret") {
		t.Errorf("clone error carries the credentials: %v", err)
	}
}

func TestPruneSelectsRendersOnly(t *testing.T) {
	sel, err := labels.Parse(pruneSelector("defs", "team-a"))
	if err != nil {
		t.Fatal(err)
	}
	if !sel.Matches(labels.Set(renderLabels("defs", "team-a"))) {
		t.Error("selector misses the module's renders")
	}
	if sel.Matches(labels.Set{"defkit.oam.dev/module": "defs", "defkit.oam.dev/module-namespace": "team-a"}) {
		t.Error("selector matches a ConfigMap that is not a render")
	}
	if sel.Matches(labels.Set(renderLabels("defs", "team-b"))) {
		t.Error("selector matches a same-named module in another namespace")
	}
}

func TestResultFileRoundTrips(t *testing.T) {
	path := filepath.Join(t.TempDir(), "result.json")
	data := map[string]string{keyModule: "{}", keyDefinitions: `[{"kind":"TraitDefinition"}]`, keyErrors: `["x: boom"]`}
	if err := os.WriteFile(path, []byte(mustJSON(data)), 0o644); err != nil {
		t.Fatal(err)
	}
	got, err := readResult(path)
	if err != nil {
		t.Fatal(err)
	}
	if !reflect.DeepEqual(got, data) {
		t.Errorf("readResult = %v, want %v", got, data)
	}
	if defs, errs := tally(got); defs != 1 || errs != 1 {
		t.Errorf("tally = %d, %d, want 1, 1", defs, errs)
	}
}

func TestRestrictKeepsDefinitionsOnly(t *testing.T) {
	data := map[string]string{
		keyModule: "{}",
		keyDefinitions: mustJSON([]map[string]interface{}{
			{"apiVersion": "core.oam.dev/v1beta1", "kind": "ComponentDefinition", "metadata": map[string]interface{}{"name": "webservice"}},
			{"apiVersion": "core.oam.dev/v1beta1", "kind": "TraitDefinition", "metadata": map[string]interface{}{"name": "scaler"}},
			{"apiVersion": "core.oam.dev/v1beta1", "kind": "PolicyDefinition", "metadata": map[string]interface{}{"name": "topology"}},
			{"apiVersion": "core.oam.dev/v1beta1", "kind": "WorkflowStepDefinition", "metadata": map[string]interface{}{"name": "deploy"}},
			{"apiVersion": "core.oam.dev/v1beta1", "kind": "WorkloadDefinition", "metadata": map[string]interface{}{"name": "worker"}},
			{"apiVersion": "v1", "kind": "ConfigMap", "metadata": map[string]interface{}{"name": "payload"}},
			{"apiVersion": "rbac.authorization.k8s.io/v1", "kind": "ClusterRoleBinding", "metadata": map[string]interface{}{"name": "admin"}},
			{"apiVersion": "evil.example/v1", "kind": "TraitDefinition", "metadata": map[string]interface{}{"name": "lookalike"}},
		}),
		keyErrors: `["broken: boom"]`,
	}
	got, err := restrict(data)
	if err != nil {
		t.Fatal(err)
	}
	var defs []map[string]interface{}
	if err := json.Unmarshal([]byte(got[keyDefinitions]), &defs); err != nil {
		t.Fatal(err)
	}
	var kept []string
	for _, d := range defs {
		kept = append(kept, d["kind"].(string)+"/"+d["metadata"].(map[string]interface{})["name"].(string))
	}
	wantKept := []string{"ComponentDefinition/webservice", "TraitDefinition/scaler", "PolicyDefinition/topology", "WorkflowStepDefinition/deploy"}
	if !reflect.DeepEqual(kept, wantKept) {
		t.Errorf("kept %v, want %v", kept, wantKept)
	}
	var errs []string
	if err := json.Unmarshal([]byte(got[keyErrors]), &errs); err != nil {
		t.Fatal(err)
	}
	if len(errs) != 5 || errs[0] != "broken: boom" {
		t.Fatalf("errors = %q, want the render's error and four dropped objects", errs)
	}
	for i, want := range []string{"WorkloadDefinition worker", "ConfigMap payload", "ClusterRoleBinding admin", "TraitDefinition lookalike (evil.example/v1)"} {
		if !strings.Contains(errs[i+1], want) {
			t.Errorf("errors[%d] = %q, want it to name %q", i+1, errs[i+1], want)
		}
	}
	if got[keyModule] != "{}" {
		t.Errorf("module.json = %s, want it unchanged", got[keyModule])
	}
}

func TestRestrictRejectsMalformedDefinitions(t *testing.T) {
	if _, err := restrict(map[string]string{keyDefinitions: `{"kind":"ConfigMap"}`}); err == nil {
		t.Error("restrict accepted a definitions.json that is not a list")
	}
}
