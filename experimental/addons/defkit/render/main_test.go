package main

import "testing"

func TestCollectEmptyMarshalsAsList(t *testing.T) {
	defs, errs := collect(nil, "")
	if got := mustJSON(defs); got != "[]" {
		t.Errorf("definitions = %s, want []", got)
	}
	if got := mustJSON(errs); got != "[]" {
		t.Errorf("errors = %s, want []", got)
	}
}
