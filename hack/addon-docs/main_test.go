package main

import (
	"os"
	"path/filepath"
	"reflect"
	"sort"
	"strings"
	"testing"

	"cuelang.org/go/cue"
	"cuelang.org/go/cue/cuecontext"
)

func TestMain(m *testing.M) {
	if err := offline(); err != nil {
		panic(err)
	}
	os.Exit(m.Run())
}

func testConfig(t *testing.T) Config {
	t.Helper()
	var c Config
	if err := readYAML("config.yaml", &c); err != nil {
		t.Fatal(err)
	}
	return c
}

// The worked example in the plan: cert-manager's versions with oldest 1.9 and current 1.12.
func TestClassifyCertManager(t *testing.T) {
	cfg := testConfig(t)
	rels := []*Release{
		{Version: "3.0.0", Date: "2026-11-27", Vela: ">=v1.12.0-alpha.3"},
		{Version: "2.2.0", Date: "2023-06-30", Vela: ">=v1.7.0-alpha.1"},
		{Version: "2.1.1", Date: "2023-06-13", Vela: ">=v1.7.0-alpha.1"},
		{Version: "2.1.0", Date: "2023-03-01", Vela: ">=v1.7.0-alpha.1"},
	}
	Classify(cfg, rels, "2026-11-28")
	want := map[string]struct {
		minors               []string
		included, deprecated bool
	}{
		"3.0.0": {[]string{"1.12"}, true, false},
		"2.2.0": {[]string{"1.9", "1.10", "1.11"}, true, false},
		"2.1.1": {[]string{"1.8", "1.9"}, true, true},
		"2.1.0": {[]string{"1.7", "1.8"}, false, true},
	}
	for _, r := range rels {
		w := want[r.Version]
		if !reflect.DeepEqual(r.Minors, w.minors) || r.Included != w.included || r.Deprecated != w.deprecated {
			t.Errorf("%s: for %v included %v deprecated %v; want %v %v %v", r.Version, r.Minors, r.Included, r.Deprecated,
				w.minors, w.included, w.deprecated)
		}
	}
}

func TestSemverLess(t *testing.T) {
	vs := []string{"1.10.0", "1.2.0", "1.12.0-alpha.1", "1.12.0", "0.9.1", "1.12.0-alpha.3"}
	sort.Slice(vs, func(i, j int) bool { return semverLess(vs[i], vs[j]) })
	want := []string{"0.9.1", "1.2.0", "1.10.0", "1.12.0-alpha.1", "1.12.0-alpha.3", "1.12.0"}
	if !reflect.DeepEqual(vs, want) {
		t.Errorf("got %v, want %v", vs, want)
	}
}

func TestImageKind(t *testing.T) {
	for in, want := range map[string]string{
		"\x89PNG\r\n\x1a\nrest":                         "png",
		"\xff\xd8\xff\xe0":                              "jpg",
		`<?xml version="1.0"?><svg xmlns="x"></svg>`:    "svg",
		"<!DOCTYPE html><html><body><svg></svg></body>": "",
		"GIF89a...": "gif",
	} {
		if got := imageKind([]byte(in)); got != want {
			t.Errorf("imageKind(%.20q) = %q, want %q", in, got, want)
		}
	}
}

func TestNextLabel(t *testing.T) {
	cfg := Config{Current: "1.12"}
	if cfg.Label("1.12") != "Next" || cfg.Label("1.11") != "1.11" {
		t.Error("an unreleased current minor is Next, a released one its number")
	}
	cfg.CurrentReleased = true
	if cfg.Label("1.12") != "1.12" {
		t.Error("a released current minor is its number")
	}
}

// The revamped addons, rendered from their files as a fixed release. UPDATE_GOLDEN=1 rewrites the goldens.
func TestGolden(t *testing.T) {
	cfg := testConfig(t)
	cases := map[string]*Release{
		"cert-manager": {Version: "3.0.0", Tag: "release/cert-manager/3.0.0", Date: "2026-11-27",
			Path: "addons/cert-manager", Minors: []string{"1.12"}, Included: true},
		"crossplane": {Version: "1.0.0", Tag: "release/crossplane/1.0.0", Date: "2026-11-27",
			Path: "experimental/addons/crossplane", Minors: []string{"1.12"}, Included: true},
	}
	for name, rel := range cases {
		t.Run(name, func(t *testing.T) {
			a, err := LoadAddon(filepath.Join("testdata", name, "addon"))
			if err != nil {
				t.Fatal(err)
			}
			for _, d := range a.Definitions {
				if d.Err != nil {
					t.Errorf("definitions/%s.cue doesn't load: %v", d.File, d.Err)
				}
			}
			p := Page{Name: name, Release: rel, History: []*Release{rel}, Latest: true, Config: cfg, Category: "Test"}
			got, err := Render(a, p)
			if err != nil {
				t.Fatal(err)
			}
			data, err := VersionsJSON(a, p, map[string][]string{rel.Version: PageKeys(got)})
			if err != nil {
				t.Fatal(err)
			}
			got["versions.json"] = string(data)

			dir := filepath.Join("testdata", name, "golden")
			if os.Getenv("UPDATE_GOLDEN") == "1" {
				if err := os.RemoveAll(dir); err != nil {
					t.Fatal(err)
				}
				for path, body := range got {
					if err := writeFile(filepath.Join(dir, path), []byte(body)); err != nil {
						t.Fatal(err)
					}
				}
				return
			}
			want := map[string]string{}
			err = filepath.WalkDir(dir, func(path string, d os.DirEntry, err error) error {
				if err != nil || d.IsDir() {
					return err
				}
				b, err := os.ReadFile(path) // #nosec G304
				want[strings.TrimPrefix(filepath.ToSlash(path), filepath.ToSlash(dir)+"/")] = string(b)
				return err
			})
			if err != nil {
				t.Fatalf("%v (run with UPDATE_GOLDEN=1 to write the goldens)", err)
			}
			for path := range want {
				if _, ok := got[path]; !ok {
					t.Errorf("%s: no longer written", path)
				}
			}
			for path, body := range got {
				if w, ok := want[path]; !ok {
					t.Errorf("%s: new page with no golden", path)
				} else if w != body {
					t.Errorf("%s differs from its golden (UPDATE_GOLDEN=1 to accept)", path)
				}
			}
		})
	}
}

func TestFields(t *testing.T) {
	v := cuecontext.New().CompileString(`parameter: {
	// +usage=The image
	image: string
	// +immutable
	// +usage=Set once
	volume?: string
	mode: *"fast" | "slow"
	// +ui:hidden
	internal?: bool
	// +ignore
	system?: int
	labels?: [string]: string
	ports?: [...{
		port: int
		name?: string
	}]
	#Helper: {x: int}
}`).LookupPath(cue.ParsePath("parameter"))
	got := map[string]Field{}
	for _, f := range fields(v) {
		g := *f
		g.Children = nil
		got[f.Name] = g
		if f.Name == "ports" && len(f.Children) != 2 {
			t.Errorf("ports: %d element fields, want 2", len(f.Children))
		}
	}
	want := map[string]Field{
		"image":    {Name: "image", Type: "string", Usage: "The image", Required: true},
		"volume":   {Name: "volume", Type: "string", Usage: "Set once", Immutable: true},
		"mode":     {Name: "mode", Type: "fast or slow", Default: "fast"},
		"internal": {Name: "internal", Type: "bool", Hidden: true},
		"system":   {Name: "system", Type: "int", Hidden: true},
		"labels":   {Name: "labels", Type: "map[string]string"},
		"ports":    {Name: "ports", Type: "[]object", List: true},
	}
	if !reflect.DeepEqual(got, want) {
		for k := range want {
			if !reflect.DeepEqual(got[k], want[k]) {
				t.Errorf("%s: got %+v, want %+v", k, got[k], want[k])
			}
		}
		for k := range got {
			if _, ok := want[k]; !ok {
				t.Errorf("unexpected field %s", k)
			}
		}
	}
	if !strings.Contains(fieldRow(&Field{Name: "volume", Type: "string", Immutable: true}, "volume", true), "addon-param-lock") {
		t.Error("an immutable field on a definition page has the lock")
	}
}
