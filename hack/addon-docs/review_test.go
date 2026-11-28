package main

import (
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"

	"cuelang.org/go/cue"
	"cuelang.org/go/cue/cuecontext"
)

// A field with any default can be left out, whether or not the default prints.
func TestDefaultMeansOptional(t *testing.T) {
	v := cuecontext.New().CompileString(`
ctx: string
parameter: {
	secretName: *"\(ctx)-tls" | string
	tags: *[] | [...string]
	prefix: *"" | string
}`).LookupPath(cue.ParsePath("parameter"))
	for _, f := range fields(v) {
		if f.Required {
			t.Errorf("%s has a default, so it isn't required", f.Name)
		}
		if f.Name == "secretName" && f.Default != `\(ctx)-tls` {
			t.Errorf("secretName's default is printed as written, got %q", f.Default)
		}
	}
}

func TestDefaultInUsage(t *testing.T) {
	for usage, want := range map[string][2]string{
		"Port to listen on. Default: 8080":              {"Port to listen on.", "8080"},
		"Chart version, defaults to 1.5.":               {"Chart version", "1.5"},
		"Replicas. Defaults to 1. Set 0 to pause it.":   {"Replicas. Defaults to 1. Set 0 to pause it.", ""},
		"Registry. Default: quay.io, or your mirror's.": {"Registry.", "quay.io, or your mirror's"},
	} {
		row := fieldRow(&Field{Name: "x", Type: "string", Usage: usage}, "x", false)
		if !strings.Contains(row, want[0]) {
			t.Errorf("%q: usage should read %q, got %s", usage, want[0], row)
		}
		if gotDef := strings.Contains(row, "addon-param-default"); gotDef != (want[1] != "") ||
			(want[1] != "" && !strings.Contains(row, "<code>"+esc(want[1])+"</code>")) {
			t.Errorf("%q: default should be %q, got %s", usage, want[1], row)
		}
	}
}

func TestSemverOpaqueVersions(t *testing.T) {
	if !semverLess("1beta2-1.3.8-3.1.1", "0.0.1") {
		t.Error("a version that isn't numeric sorts before every numeric one")
	}
	if semverLess("0.0.1", "1beta2-1.3.8-3.1.1") {
		t.Error("a numeric version never sorts before one that isn't")
	}
	if !semverLess("a", "b") || semverLess("b", "a") {
		t.Error("versions that aren't numeric sort by their text")
	}
}

// Once the current minor is released, its real date decides which addon versions it went with.
func TestClassifyReleasedCurrent(t *testing.T) {
	cfg := Config{Current: "1.12", CurrentReleased: true, Oldest: "1.9",
		Minors: map[string]string{"1.10": "2025-02-03", "1.11": "2026-07-17", "1.12": "2026-12-01"}}
	rels := []*Release{
		{Version: "2.0.0", Date: "2026-12-10"},
		{Version: "1.0.0", Date: "2026-08-01"},
	}
	Classify(cfg, rels, "2026-12-20")
	if got := strings.Join(rels[1].Minors, ","); got != "1.11,1.12" {
		t.Errorf("1.0.0 was newest when 1.12 came out on 2026-12-01, so it is for 1.11,1.12; got %s", got)
	}
}

func TestDocsCollideWithGeneratedPages(t *testing.T) {
	cfg := Config{Current: "1.12", Oldest: "1.9"}
	rel := &Release{Version: "1.0.0", Tag: "release/x/1.0.0", Path: "addons/x", Minors: []string{"1.12"}, Included: true}
	p := Page{Name: "x", Release: rel, History: []*Release{rel}, Latest: true, Config: cfg}
	for name, docs := range map[string]map[string]string{
		"a docs page named after a generated one": {"parameters.md": "# P\n"},
		"two guides": {"index.md": "a\n", "guide.md": "b\n"},
	} {
		a := &Addon{Meta: Metadata{Name: "x"}, HasParams: true, Docs: docs}
		if _, err := Render(a, p); err == nil {
			t.Errorf("%s: want an error, not one page silently replacing the other", name)
		}
	}
}

func TestMalformedMetadata(t *testing.T) {
	if _, err := readMetadata([]byte("name: x\ndescription: [unclosed\n")); err == nil {
		t.Error("metadata.yaml that doesn't parse is an error")
	}
	if m, err := readMetadata([]byte("name: x\nsomethingNew: 1\n")); err != nil || m.Name != "x" {
		t.Errorf("a field this tool doesn't know is fine: %v", err)
	}
}

// An addon that fails part way leaves nothing behind for publish.sh to push.
func TestFailedAddonLeavesNoPages(t *testing.T) {
	repo := t.TempDir()
	run := func(args ...string) {
		t.Helper()
		cmd := exec.Command("git", append([]string{"-C", repo, "-c", "user.name=t", "-c", "user.email=t@t"}, args...)...)
		if out, err := cmd.CombinedOutput(); err != nil {
			t.Fatalf("git %v: %v: %s", args, err, out)
		}
	}
	write := func(path, body string) {
		t.Helper()
		if err := writeFile(filepath.Join(repo, path), []byte(body)); err != nil {
			t.Fatal(err)
		}
	}
	run("init", "-q")
	write("addons/x/metadata.yaml", "name: x\nversion: 1.0.0\n")
	write("addons/x/parameter.cue", "parameter: {\n")
	run("add", "-A")
	run("commit", "-q", "-m", "1.0.0, broken")
	run("tag", "release/x/1.0.0")
	write("addons/x/metadata.yaml", "name: x\nversion: 2.0.0\n")
	write("addons/x/parameter.cue", "parameter: {}\n")
	run("commit", "-q", "-am", "2.0.0")
	run("tag", "release/x/2.0.0")

	out := t.TempDir()
	cfg := Config{Current: "1.12", Oldest: "1.9", Minors: map[string]string{"1.11": "2020-01-01"}}
	g := &generator{repo: repo, out: out, cfg: cfg, today: "2030-01-01"}
	if _, err := g.addon("x"); err == nil {
		t.Fatal("1.0.0's parameter.cue doesn't compile, so the addon fails")
	}
	if _, err := os.Stat(filepath.Join(out, "x")); !os.IsNotExist(err) {
		t.Errorf("the failed addon left %s behind (%v)", filepath.Join(out, "x"), err)
	}
}

func TestJobsAtLeastOne(t *testing.T) {
	if checkJobs(0) == nil || checkJobs(-1) == nil || checkJobs(1) != nil {
		t.Error("-jobs below 1 has no workers, so it's refused")
	}
}

func TestRedactURL(t *testing.T) {
	got := redact("https://user:secret@example.com/logo.png?sig=abc#x")
	if strings.Contains(got, "secret") || strings.Contains(got, "sig=") || !strings.Contains(got, "example.com/logo.png") {
		t.Errorf("redact kept credentials or the query: %s", got)
	}
}

func TestPageKey(t *testing.T) {
	for path, want := range map[string]string{"index.md": "", "reindex.md": "reindex", "definitions/helm.md": "definitions/helm",
		"parameters.md": "parameters"} {
		if got := pageKey(path); got != want {
			t.Errorf("pageKey(%q) = %q, want %q", path, got, want)
		}
	}
}
