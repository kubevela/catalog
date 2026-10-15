package main

import (
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
	sel, err := labels.Parse(pruneSelector("defs"))
	if err != nil {
		t.Fatal(err)
	}
	if !sel.Matches(labels.Set(renderLabels("defs"))) {
		t.Error("selector misses the module's renders")
	}
	if sel.Matches(labels.Set{"defkit.oam.dev/module": "defs"}) {
		t.Error("selector matches a ConfigMap that is not a render")
	}
}
