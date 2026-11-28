package main

import (
	"fmt"
	"os"
	"os/exec"
	"regexp"
	"sort"
	"strconv"
	"strings"

	"sigs.k8s.io/yaml"
)

// Config is config.yaml: the KubeVela releases the docs cover.
type Config struct {
	Current         string            `json:"current"`
	CurrentReleased bool              `json:"currentReleased"`
	Oldest          string            `json:"oldest"`
	Minors          map[string]string `json:"minors"`
}

// Override is an addon's entry in overrides.yaml.
type Override struct {
	Category string `json:"category"`
	Logo     string `json:"logo"`
	// LogoCrop "square" crops a raster logo to its centre square, for a project whose only image is a banner.
	LogoCrop string `json:"logoCrop"`
}

// Overrides is overrides.yaml.
type Overrides struct {
	Categories []string            `json:"categories"`
	Addons     map[string]Override `json:"addons"`
}

// check refuses a category that isn't listed, so a typo doesn't make a category of its own.
func (o Overrides) check() error {
	known := map[string]bool{}
	for _, c := range o.Categories {
		known[c] = true
	}
	for name, a := range o.Addons {
		if a.Category != "" && !known[a.Category] {
			return fmt.Errorf("overrides.yaml: %s: category %q isn't one of categories", name, a.Category)
		}
	}
	return nil
}

func readYAML(path string, into interface{}) error {
	data, err := os.ReadFile(path) // #nosec G304 -- a path the caller passes in
	if err != nil {
		return err
	}
	if err := yaml.UnmarshalStrict(data, into); err != nil {
		return fmt.Errorf("%s: %w", path, err)
	}
	return nil
}

// Label names a KubeVela minor as the docs site does: the current one is Next until it is released.
func (c Config) Label(minor string) string {
	if minor == c.Current && !c.CurrentReleased {
		return "Next"
	}
	return minor
}

// Release is one published version of an addon: its release/<addon>/<version> tag, and what the docs make of it.
type Release struct {
	Version string
	Tag     string
	Date    string // the tag's date, YYYY-MM-DD
	Path    string // addons/<name> or experimental/addons/<name> at the tag
	Vela    string // metadata.yaml's system.vela

	Minors     []string // the KubeVela minors this version was for
	Included   bool     // it gets pages
	Deprecated bool     // its newest minor is older than current-2
}

// git runs git in the catalog repository.
func git(repo string, args ...string) (string, error) {
	cmd := exec.Command("git", append([]string{"-C", repo}, args...)...) // #nosec G204 -- fixed binary, our own args
	out, err := cmd.Output()
	if err != nil {
		if ee, ok := err.(*exec.ExitError); ok {
			return "", fmt.Errorf("git %s: %w: %s", strings.Join(args, " "), err, strings.TrimSpace(string(ee.Stderr)))
		}
		return "", fmt.Errorf("git %s: %w", strings.Join(args, " "), err)
	}
	return string(out), nil
}

// Published lists the addons with release tags.
func Published(repo string) ([]string, error) {
	out, err := git(repo, "for-each-ref", "--format=%(refname:short)", "refs/tags/release/")
	if err != nil {
		return nil, err
	}
	seen := map[string]bool{}
	var names []string
	for _, ref := range strings.Fields(out) {
		parts := strings.Split(ref, "/")
		if len(parts) == 3 && !seen[parts[1]] {
			seen[parts[1]] = true
			names = append(names, parts[1])
		}
	}
	sort.Strings(names)
	return names, nil
}

var velaFloor = regexp.MustCompile(`>=\s*v?(\d+)\.(\d+)`)

// Releases reads an addon's release tags, newest version first. "latest" is not a version, and v1.0.0 and 1.0.0
// are the same one (the newer tag wins).
func Releases(repo, name string) ([]*Release, error) {
	out, err := git(repo, "for-each-ref", "--format=%(refname:short) %(creatordate:short)", "refs/tags/release/"+name+"/")
	if err != nil {
		return nil, err
	}
	byVersion := map[string]*Release{}
	for _, line := range strings.Split(strings.TrimSpace(out), "\n") {
		f := strings.Fields(line)
		if len(f) != 2 {
			continue
		}
		ver := f[0][strings.LastIndex(f[0], "/")+1:]
		if ver == "latest" {
			continue
		}
		key := strings.TrimPrefix(ver, "v")
		if r, ok := byVersion[key]; ok && r.Date > f[1] {
			continue
		}
		byVersion[key] = &Release{Version: key, Tag: f[0], Date: f[1]}
	}
	if len(byVersion) == 0 {
		return nil, fmt.Errorf("%s: no release tags", name)
	}
	var rels []*Release
	for _, r := range byVersion {
		for _, p := range []string{"addons/" + name, "experimental/addons/" + name} {
			if ls, _ := git(repo, "ls-tree", r.Tag, p); strings.TrimSpace(ls) != "" {
				r.Path = p
				break
			}
		}
		if r.Path == "" {
			return nil, fmt.Errorf("%s: %s holds no addons/%s or experimental/addons/%s", name, r.Tag, name, name)
		}
		meta, err := git(repo, "show", r.Tag+":"+r.Path+"/metadata.yaml")
		if err != nil {
			return nil, err
		}
		m, err := readMetadata([]byte(meta))
		if err != nil {
			return nil, fmt.Errorf("%s: %w", r.Tag, err)
		}
		r.Vela = m.System.Vela
		rels = append(rels, r)
	}
	sort.Slice(rels, func(i, j int) bool { return semverLess(rels[j].Version, rels[i].Version) })
	return rels, nil
}

var numericCore = regexp.MustCompile(`^\d+(\.\d+)*$`)

// semverLess orders versions by their numeric parts, a pre-release before its release. A version whose core isn't
// numeric (v1beta2-1.3.8-3.1.1) sorts before every numeric one, and by its text among its kind.
func semverLess(a, b string) bool {
	pa, pb := strings.SplitN(a, "-", 2), strings.SplitN(b, "-", 2)
	if na, nb := numericCore.MatchString(pa[0]), numericCore.MatchString(pb[0]); na != nb || !na {
		if na != nb {
			return nb
		}
		return a < b
	}
	na, nb := strings.Split(pa[0], "."), strings.Split(pb[0], ".")
	for i := 0; i < len(na) || i < len(nb); i++ {
		var x, y int
		if i < len(na) {
			x, _ = strconv.Atoi(na[i])
		}
		if i < len(nb) {
			y, _ = strconv.Atoi(nb[i])
		}
		if x != y {
			return x < y
		}
	}
	switch {
	case len(pa) == 1 && len(pb) == 2:
		return false
	case len(pa) == 2 && len(pb) == 1:
		return true
	case len(pa) == 2:
		return pa[1] < pb[1]
	}
	return false
}

func minorLess(a, b string) bool { return semverLess(a, b) }

// Classify decides, for each release, the KubeVela minors it was for, whether it gets pages and whether it is
// deprecated. A version is for every minor released while it was the addon's newest (from its tag to the next
// version's), no earlier than its system.vela floor; the current minor counts as released today. Releases are
// returned as given.
func Classify(cfg Config, rels []*Release, today string) []*Release {
	released := map[string]string{}
	for m, d := range cfg.Minors {
		released[m] = d
	}
	if _, ok := released[cfg.Current]; !ok || !cfg.CurrentReleased {
		released[cfg.Current] = today // unreleased, it counts as out today
	}
	var all []string
	for m := range released {
		all = append(all, m)
	}
	sort.Slice(all, func(i, j int) bool { return minorLess(all[i], all[j]) })
	n2 := all[0]
	for i, m := range all {
		if m == cfg.Current && i >= 2 {
			n2 = all[i-2]
		}
	}

	byDate := append([]*Release(nil), rels...)
	sort.SliceStable(byDate, func(i, j int) bool { return byDate[i].Date < byDate[j].Date })
	for i, r := range byDate {
		end := today
		if i+1 < len(byDate) {
			end = byDate[i+1].Date
		}
		ms := map[string]bool{}
		var outAtStart string
		for m, d := range released {
			if d <= r.Date && (outAtStart == "" || minorLess(outAtStart, m)) {
				outAtStart = m
			}
			if r.Date < d && d <= end {
				ms[m] = true
			}
		}
		if outAtStart != "" {
			ms[outAtStart] = true
		}
		if i+1 < len(byDate) && released[cfg.Current] > end {
			delete(ms, cfg.Current)
		}
		if f := velaFloor.FindStringSubmatch(r.Vela); f != nil {
			floor := f[1] + "." + f[2]
			for m := range ms {
				if minorLess(m, floor) {
					delete(ms, m)
				}
			}
			ahead := true
			for m := range cfg.Minors {
				if !minorLess(m, floor) {
					ahead = false
				}
			}
			if len(ms) == 0 && ahead {
				ms[cfg.Current] = true
			}
		}
		r.Minors = nil
		for m := range ms {
			r.Minors = append(r.Minors, m)
		}
		sort.Slice(r.Minors, func(a, b int) bool { return minorLess(r.Minors[a], r.Minors[b]) })
		top := "0.0"
		if len(r.Minors) > 0 {
			top = r.Minors[len(r.Minors)-1]
		}
		r.Included = !minorLess(top, cfg.Oldest)
		r.Deprecated = minorLess(top, n2)
	}
	if len(rels) > 0 {
		rels[0].Included, rels[0].Deprecated = true, false
	}
	return rels
}
