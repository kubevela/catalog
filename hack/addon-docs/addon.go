package main

import (
	"context"
	"errors"
	"fmt"
	"os"
	"path/filepath"
	"sort"
	"strconv"
	"strings"

	"cuelang.org/go/cue"
	"cuelang.org/go/cue/cuecontext"
	"k8s.io/apimachinery/pkg/apis/meta/v1/unstructured"
	"sigs.k8s.io/yaml"

	velacue "github.com/oam-dev/kubevela/pkg/cue"
	pkgdef "github.com/oam-dev/kubevela/pkg/definition"
	"github.com/oam-dev/kubevela/pkg/utils/common"
	"github.com/oam-dev/kubevela/pkg/workflow/providers"
)

// Metadata is the part of an addon's metadata.yaml the pages show.
type Metadata struct {
	Name         string   `json:"name"`
	Version      string   `json:"version"`
	Description  string   `json:"description"`
	Icon         string   `json:"icon"`
	URL          string   `json:"url"`
	Tags         []string `json:"tags"`
	Dependencies []struct {
		Name string `json:"name"`
	} `json:"dependencies"`
	System struct {
		Vela       string `json:"vela"`
		Kubernetes string `json:"kubernetes"`
	} `json:"system"`
}

// readMetadata parses metadata.yaml leniently: an addon with a field this tool doesn't know still gets its pages.
func readMetadata(data []byte) Metadata {
	var m Metadata
	_ = yaml.Unmarshal(data, &m)
	return m
}

// Field is a parameter of an addon or a definition, with the fields nested in it.
type Field struct {
	Name      string
	Type      string
	Default   string
	Usage     string
	Required  bool
	Hidden    bool // +ui:hidden or +ignore: not for the person enabling the addon
	Immutable bool
	List      bool // a list of objects; Children are one element's fields
	Children  []*Field
}

// Definition is one file in an addon's definitions/.
type Definition struct {
	File        string // its name without .cue
	Name        string
	Kind        string // component, trait, policy or workflow-step
	Description string
	Fields      []*Field
	Err         error // why it doesn't load; its page says so
}

// Addon is an addon's files as the pages need them, read from its directory at one version.
type Addon struct {
	Meta        Metadata
	Params      []*Field // nil without parameter.cue
	HasParams   bool
	Definitions []Definition
	Readme      string
	Docs        map[string]string // docs/*.md by file name
}

// LoadAddon reads the addon in dir. A parameter.cue that doesn't compile is an error; a definition that doesn't
// load is kept, with the reason.
func LoadAddon(dir string) (*Addon, error) {
	a := &Addon{Docs: map[string]string{}}
	meta, err := os.ReadFile(filepath.Join(dir, "metadata.yaml")) // #nosec G304
	if err != nil {
		return nil, err
	}
	a.Meta = readMetadata(meta)

	if src, err := os.ReadFile(filepath.Join(dir, "parameter.cue")); err == nil { // #nosec G304
		// Compiled as pkg/addon compiles it, with a plain CUE context.
		v := cuecontext.New().CompileBytes(src)
		if v.Err() != nil {
			return nil, fmt.Errorf("parameter.cue: %w", v.Err())
		}
		a.HasParams = true
		a.Params = fields(v.LookupPath(cue.ParsePath("parameter")))
	}

	defs, _ := filepath.Glob(filepath.Join(dir, "definitions", "*.cue"))
	sort.Strings(defs)
	for _, f := range defs {
		if strings.HasSuffix(f, "_test.cue") {
			continue
		}
		d, err := loadDefinition(f)
		if err != nil {
			// The addon keeps its pages; this definition's says it doesn't load.
			file := strings.TrimSuffix(filepath.Base(f), ".cue")
			d = Definition{File: file, Name: file, Err: err}
		}
		a.Definitions = append(a.Definitions, d)
	}

	entries, _ := os.ReadDir(dir)
	for _, e := range entries {
		if strings.EqualFold(e.Name(), "readme.md") {
			b, _ := os.ReadFile(filepath.Join(dir, e.Name())) // #nosec G304
			a.Readme = string(b)
		}
	}
	docs, _ := filepath.Glob(filepath.Join(dir, "docs", "*.md"))
	for _, f := range docs {
		b, _ := os.ReadFile(f) // #nosec G304
		a.Docs[filepath.Base(f)] = string(b)
	}
	return a, nil
}

var defKinds = map[string]string{
	"ComponentDefinition":    "component",
	"TraitDefinition":        "trait",
	"PolicyDefinition":       "policy",
	"WorkflowStepDefinition": "workflow-step",
}

// loadDefinition reads a CUE X-Definition the way `vela def` does, and its parameters with the compiler that knows
// the vela/* packages.
func loadDefinition(path string) (Definition, error) {
	src, err := os.ReadFile(path) // #nosec G304
	if err != nil {
		return Definition{}, err
	}
	def := pkgdef.Definition{Unstructured: unstructured.Unstructured{Object: map[string]interface{}{}}}
	if err := def.FromCUEString(string(src), nil); err != nil {
		return Definition{}, err
	}
	d := Definition{
		File:        strings.TrimSuffix(filepath.Base(path), ".cue"),
		Name:        def.GetName(),
		Kind:        defKinds[def.GetKind()],
		Description: def.GetAnnotations()["definition.oam.dev/description"],
	}
	tmpl, _, _ := unstructured.NestedString(def.Object, "spec", "schematic", "cue", "template")
	if tmpl == "" {
		return d, nil
	}
	v, err := common.GetCUExParameterValue(context.Background(), tmpl, providers.DefaultCompiler.Get())
	if errors.Is(err, velacue.ErrParameterNotExist) {
		return d, nil
	}
	if err != nil {
		return Definition{}, err
	}
	d.Fields = fields(v)
	return d, nil
}

// fields lists a struct's fields in the order they are declared, with the comment markers kubevela's docgen reads
// (+usage, +ignore, +immutable) and VelaUX's +ui:hidden.
func fields(v cue.Value) []*Field {
	if !v.Exists() || v.IncompleteKind() != cue.StructKind {
		return nil
	}
	it, err := v.Fields(cue.Optional(true), cue.Definitions(false))
	if err != nil {
		return nil
	}
	var out []*Field
	for it.Next() {
		val := it.Value()
		f := &Field{Name: label(it.Selector())}
		f.Required = !it.IsOptional()
		_, f.Usage, _, f.Hidden, f.Immutable = velacue.RetrieveComments(val)
		for _, doc := range val.Doc() {
			if strings.Contains(doc.Text(), "+ui:hidden") {
				f.Hidden = true
			}
		}
		if d, ok := val.Default(); ok && d.IsConcrete() {
			if s := scalar(d); s != "" {
				f.Default = s
				f.Required = false
			}
		}
		f.Type, f.Children, f.List = typeOf(val)
		out = append(out, f)
	}
	return out
}

// label is a field's name without CUE's optional or required marker and quotes.
func label(sel cue.Selector) string {
	s := strings.TrimRight(sel.String(), "?!")
	if u, err := strconv.Unquote(s); err == nil {
		return u
	}
	return s
}

// scalar prints a concrete default; a struct or list default isn't shown.
func scalar(v cue.Value) string {
	switch v.Kind() {
	case cue.StringKind:
		s, _ := v.String()
		return s
	case cue.IntKind:
		i, _ := v.Int64()
		return strconv.FormatInt(i, 10)
	case cue.FloatKind, cue.NumberKind:
		f, _ := v.Float64()
		return strconv.FormatFloat(f, 'g', -1, 64)
	case cue.BoolKind:
		b, _ := v.Bool()
		return strconv.FormatBool(b)
	}
	return ""
}

// typeOf is a field's type as the pages print it, and the fields nested in it.
func typeOf(v cue.Value) (string, []*Field, bool) {
	if op, args := v.Expr(); op == cue.OrOp {
		var enum []string
		for _, a := range args {
			s, err := a.String()
			if err != nil || !a.IsConcrete() {
				enum = nil
				break
			}
			enum = append(enum, s)
		}
		if len(enum) > 1 {
			return strings.Join(enum, " or "), nil, false
		}
	}
	switch v.IncompleteKind() {
	case cue.StructKind:
		if children := fields(v); len(children) > 0 {
			return "object", children, false
		}
		if elem, ok := v.Elem(); ok {
			return "map[string]" + kindName(elem), nil, false
		}
		return "object", nil, false
	case cue.ListKind:
		elem := v.LookupPath(cue.MakePath(cue.AnyIndex))
		if !elem.Exists() {
			return "list", nil, false
		}
		if children := fields(elem); len(children) > 0 {
			return "[]object", children, true
		}
		return "[]" + kindName(elem), nil, false
	}
	return kindName(v), nil, false
}

func kindName(v cue.Value) string {
	k := v.IncompleteKind()
	if k == cue.StructKind {
		return "object"
	}
	if k == cue.TopKind {
		return "any"
	}
	return strings.ReplaceAll(k.String(), "|", " or ")
}
