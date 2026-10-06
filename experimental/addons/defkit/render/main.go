// Command defkit-render loads a DefKit module the way `vela def apply-module`
// does and writes what it generates to a ConfigMap, for the defkit addon's
// apply step and VelaUX's preview to read. It applies nothing itself.
//
//	defkit-render --ref github.com/org/defs --version v1.2.0 --configmap ns/name
//	defkit-render --git https://github.com/org/defs --version main --configmap ns/name
package main

import (
	"context"
	"encoding/json"
	"flag"
	"fmt"
	"os"
	"os/exec"
	"sort"
	"strings"
	"time"

	corev1 "k8s.io/api/core/v1"
	apierrors "k8s.io/apimachinery/pkg/api/errors"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/rest"

	"github.com/kubevela/pkg/cue/cuex"

	pkgdef "github.com/oam-dev/kubevela/pkg/definition"
	"github.com/oam-dev/kubevela/pkg/definition/goloader"
)

// Keys of the result ConfigMap.
const (
	keyModule      = "module.json"
	keyDefinitions = "definitions.json"
	keyErrors      = "errors.json"
)

// renderSource is what was asked for, so a reader can tell which settings this
// render belongs to.
type renderSource struct {
	Ref     string   `json:"ref,omitempty"`
	Git     string   `json:"git,omitempty"`
	Version string   `json:"version,omitempty"`
	Prefix  string   `json:"prefix,omitempty"`
	Types   []string `json:"types,omitempty"`
}

// moduleInfo is what VelaUX shows about a module, from its module.yaml.
type moduleInfo struct {
	Source      renderSource              `json:"source"`
	Name        string                    `json:"name"`
	Ref         string                    `json:"ref"`
	Version     string                    `json:"version"`
	Description string                    `json:"description,omitempty"`
	Maintainers []goloader.Maintainer     `json:"maintainers,omitempty"`
	Categories  []string                  `json:"categories,omitempty"`
	Placement   *goloader.ModulePlacement `json:"placement,omitempty"`
	HasHooks    bool                      `json:"hasHooks,omitempty"`
}

func main() {
	// Rendering reads no Package CRs: the Job has no access to them.
	cuex.EnableExternalPackageForDefaultCompiler = false
	ref := flag.String("ref", "", "Go module path of the DefKit module")
	gitURL := flag.String("git", "", "git repository of the DefKit module, in place of --ref")
	version := flag.String("version", "", "module version, or with --git a branch, tag or commit; latest or the default branch when empty")
	prefix := flag.String("prefix", "", "prefix for every definition name")
	types := flag.String("types", "", "comma-separated definition types; all when empty")
	target := flag.String("configmap", "", "namespace/name of the ConfigMap to write; stdout when empty")
	owner := flag.String("module", "", "the module Application, labelled on the ConfigMap")
	flag.Parse()
	if (*ref == "") == (*gitURL == "") {
		fail(fmt.Errorf("one of --ref and --git is required"))
	}
	source := *ref
	if *gitURL != "" {
		dir, err := clone(*gitURL, *version)
		if err != nil {
			fail(err)
		}
		source = dir
	}

	opts := goloader.DefaultModuleLoadOptions()
	if *gitURL == "" {
		opts.Version = *version
	}
	opts.NamePrefix = *prefix
	if *types != "" {
		opts.Types = strings.Split(*types, ",")
	}
	ctx := context.Background()
	module, err := goloader.LoadModule(ctx, source, opts)
	if err != nil {
		fail(fmt.Errorf("load %s: %w", source, err))
	}

	var defs []map[string]interface{}
	var errs []string
	for _, r := range module.Definitions {
		if r.Error != nil {
			errs = append(errs, fmt.Sprintf("%s: %v", r.Definition.Name, r.Error))
			continue
		}
		def := pkgdef.Definition{}
		if err := def.FromCUEString(r.CUE, nil); err != nil {
			errs = append(errs, fmt.Sprintf("%s: %v", r.Definition.Name, err))
			continue
		}
		if *prefix != "" && !strings.HasPrefix(def.GetName(), *prefix) {
			def.SetName(*prefix + def.GetName())
		}
		defs = append(defs, def.Object)
	}
	meta := module.Metadata
	var typeList []string
	if *types != "" {
		typeList = strings.Split(*types, ",")
	}
	info := moduleInfo{
		Source: renderSource{Ref: *ref, Git: *gitURL, Version: *version, Prefix: *prefix, Types: typeList},
		Name:   meta.Metadata.Name, Ref: *ref + *gitURL, Version: module.Version,
		Description: meta.Spec.Description, Maintainers: meta.Spec.Maintainers,
		Categories: meta.Spec.Categories, Placement: meta.Spec.Placement,
		HasHooks: meta.Spec.Hooks != nil && (meta.Spec.Hooks.HasPreApply() || meta.Spec.Hooks.HasPostApply()),
	}
	data := map[string]string{
		keyModule:      mustJSON(info),
		keyDefinitions: mustJSON(defs),
		keyErrors:      mustJSON(errs),
	}
	if *target == "" {
		fmt.Println(mustJSON(data))
		return
	}
	if err := write(ctx, *target, *owner, data); err != nil {
		fail(err)
	}
	if *owner != "" {
		if err := prune(ctx, *target, *owner); err != nil {
			fmt.Fprintln(os.Stderr, "defkit-render: pruning old renders:", err)
		}
	}
	fmt.Printf("%d definitions, %d failed, written to %s\n", len(defs), len(errs), *target)
}

// clone fetches one revision of a repository into a temporary directory. A
// fetch by name takes a branch, a tag or a commit alike.
func clone(url, revision string) (string, error) {
	dir, err := os.MkdirTemp("", "defkit-")
	if err != nil {
		return "", err
	}
	if revision == "" {
		revision = "HEAD"
	}
	for _, args := range [][]string{
		{"init", "-q"},
		{"remote", "add", "origin", url},
		{"fetch", "-q", "--depth", "1", "origin", revision},
		{"checkout", "-q", "FETCH_HEAD"},
	} {
		cmd := exec.Command("git", args...)
		cmd.Dir = dir
		if out, err := cmd.CombinedOutput(); err != nil {
			return "", fmt.Errorf("git %s: %w: %s", args[0], err, strings.TrimSpace(string(out)))
		}
	}
	return dir, nil
}

// write creates or replaces the ConfigMap; the Job's account may do nothing else.
// A review's decisions, written beside the render, are dropped with it.
func write(ctx context.Context, target, owner string, data map[string]string) error {
	ns, name, ok := strings.Cut(target, "/")
	if !ok {
		return fmt.Errorf("--configmap wants namespace/name, got %q", target)
	}
	cfg, err := rest.InClusterConfig()
	if err != nil {
		return fmt.Errorf("in-cluster config: %w", err)
	}
	cli, err := kubernetes.NewForConfig(cfg)
	if err != nil {
		return err
	}
	labels := map[string]string{"defkit.oam.dev/render": "true", "defkit.oam.dev/module": owner}
	annotations := map[string]string{"defkit.oam.dev/rendered-at": time.Now().UTC().Format("2006-01-02T15:04:05.000000000Z")}
	cms := cli.CoreV1().ConfigMaps(ns)
	cm, err := cms.Get(ctx, name, metav1.GetOptions{})
	if apierrors.IsNotFound(err) {
		_, err = cms.Create(ctx, &corev1.ConfigMap{ObjectMeta: metav1.ObjectMeta{Name: name, Namespace: ns,
			Labels: labels, Annotations: annotations}, Data: data}, metav1.CreateOptions{})
		return err
	}
	if err != nil {
		return err
	}
	cm.Labels, cm.Annotations, cm.Data = labels, annotations, data
	_, err = cms.Update(ctx, cm, metav1.UpdateOptions{})
	return err
}

// keepRenders is how many of a module's renders are kept: every run writes one.
const keepRenders = 3

// prune deletes a module's renders beyond the newest keepRenders.
func prune(ctx context.Context, target, owner string) error {
	ns, _, _ := strings.Cut(target, "/")
	cfg, err := rest.InClusterConfig()
	if err != nil {
		return err
	}
	cli, err := kubernetes.NewForConfig(cfg)
	if err != nil {
		return err
	}
	cms := cli.CoreV1().ConfigMaps(ns)
	list, err := cms.List(ctx, metav1.ListOptions{LabelSelector: "defkit.oam.dev/module=" + owner})
	if err != nil {
		return err
	}
	items := list.Items
	sort.Slice(items, func(i, j int) bool {
		return items[i].Annotations["defkit.oam.dev/rendered-at"] > items[j].Annotations["defkit.oam.dev/rendered-at"]
	})
	for i := keepRenders; i < len(items); i++ {
		if err := cms.Delete(ctx, items[i].Name, metav1.DeleteOptions{}); err != nil && !apierrors.IsNotFound(err) {
			return err
		}
	}
	return nil
}

func mustJSON(v interface{}) string {
	b, err := json.Marshal(v)
	if err != nil {
		fail(err)
	}
	return string(b)
}

func fail(err error) {
	fmt.Fprintln(os.Stderr, "defkit-render:", err)
	os.Exit(1)
}
