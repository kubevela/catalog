package main

import (
	"encoding/json"
	"fmt"
	"net/url"
	"regexp"
	"sort"
	"strings"
)

// Page is what one version of an addon is rendered with, besides its files.
type Page struct {
	Name     string
	Release  *Release   // the version rendered
	History  []*Release // every release, newest first; the latest renders the versions page from it
	Latest   bool
	Config   Config
	Logo     string // the logo's file name beside the pages, if any
	Category string
}

func (p Page) experimental() bool { return strings.HasPrefix(p.Release.Path, "experimental/") }

// offSidebar: older versions and experimental addons aren't in the sidebar, so their pages name the one they show.
func (p Page) offSidebar() bool { return !p.Latest || p.experimental() }

func (p Page) srcURL() string {
	return fmt.Sprintf("https://github.com/kubevela/catalog/tree/%s/%s", p.Release.Tag, p.Release.Path)
}

var escaper = strings.NewReplacer("<", "&lt;", ">", "&gt;", "{", "&#123;", "}", "&#125;")

// esc makes text from an addon safe in MDX.
func esc(s string) string { return escaper.Replace(s) }

func capitalise(s string) string {
	if s == "" {
		return s
	}
	return strings.ToUpper(s[:1]) + s[1:]
}

// Render writes one version of an addon's pages, keyed by path under the addon's directory on the site.
func Render(a *Addon, p Page) (map[string]string, error) {
	out := map[string]string{}
	out["index.md"] = overview(a, p)
	if a.HasParams {
		out["parameters.md"] = parametersPage(a, p)
	}
	for _, d := range a.Definitions {
		out["definitions/"+d.File+".md"] = definitionPage(a, p, d)
	}
	if p.Latest {
		out["versions.md"] = versionsPage(p)
	}
	gs, err := guides(a, p)
	if err != nil {
		return nil, err
	}
	for name, body := range gs {
		if _, taken := out[name]; taken || name == "versions.md" {
			return nil, fmt.Errorf("docs/%s: the generated %s page has that name; rename it", name, name)
		}
		out[name] = body
	}
	for path, s := range out {
		if path == "guide.md" && a.Readme != "" && len(a.Docs) == 0 {
			continue // the README is plain markdown, which the picker's MDX import would break
		}
		out[path] = withPicker(s, p, strings.TrimSuffix(strings.TrimSuffix(path, ".md"), "index"))
	}
	return out, nil
}

const experimentalNote = ":::caution Experimental\nThis addon is in the catalog's experimental registry: enable it with " +
	"`vela addon registry add experimental --type helm --endpoint=https://kubevela.github.io/catalog/experimental/` first.\n:::\n"

func overview(a *Addon, p Page) string {
	m, r := a.Meta, p.Release
	var deps []string
	for _, d := range m.Dependencies {
		if regexp.MustCompile(`^[\w.-]+$`).MatchString(d.Name) {
			deps = append(deps, fmt.Sprintf("[%s](/addons/catalog/%s/)", d.Name, d.Name))
		}
	}
	code := func(s string) string {
		if s == "" {
			return ""
		}
		return "`" + s + "`"
	}
	vela := code(m.System.Vela)
	if vela == "" {
		vela = "any"
	}
	facts := [][2]string{
		{"Addon version", r.Version}, {"Released", r.Date}, {"KubeVela", vela}, {"Kubernetes", code(m.System.Kubernetes)},
		{"Upstream", link(m.URL, m.URL)}, {"Needs", strings.Join(deps, ", ")}, {"Tags", strings.Join(m.Tags, ", ")},
		{"Source", fmt.Sprintf("[kubevela/catalog: %s](%s)", r.Path, p.srcURL())},
	}
	b := lines{"---\ntitle: " + m.Name + "\nsidebar_label: Overview\n---\n",
		"<!-- Generated from the addon's files in kubevela/catalog. Edit them there, not here. -->\n"}
	if p.Logo != "" {
		b.add(fmt.Sprintf("<div className=\"addon-logo\">\n\n![%s logo](./%s)\n\n</div>\n", p.Name, p.Logo))
	}
	if p.experimental() {
		b.add(experimentalNote)
	}
	if intro := strings.TrimRight(m.Description, "."); intro != "" {
		b.add(esc(capitalise(intro)) + ".\n")
	}
	if intro, ok := a.Docs["_intro.md"]; ok {
		b.add(strings.TrimSpace(stripFrontMatter(intro)) + "\n")
	}
	b.add(`<dl className="addon-facts">`)
	for _, f := range facts {
		if f[1] != "" {
			b.add(fmt.Sprintf("<dt>%s</dt>\n<dd>\n\n%s\n\n</dd>", f[0], f[1]))
		}
	}
	b.add("</dl>\n", "## Install\n", "### With the CLI\n", fmt.Sprintf("```shell\nvela addon enable %s\n```\n", p.Name))
	if a.HasParams {
		b.add("Set [parameters](./parameters) as `key=value` on the same command.")
	}
	b.add(fmt.Sprintf("\n```shell\nvela addon disable %s\n```\n", p.Name))
	if p.Config.CurrentReleased {
		b.add(fmt.Sprintf("### As a component (KubeVela %s and later)\n", p.Config.Current))
	} else {
		b.add("### As a component (KubeVela Next)\n")
	}
	b.add("Install it from an Application with the [`addon` component](/docs/next/end-user/components/references#addon), "+
		"so the addon is declared, versioned and reviewed with the rest of your platform; deleting the Application "+
		"uninstalls it. Needs the `EnableAddonComponent` feature gate (alpha, off by default): install or upgrade "+
		"vela-core with `--set featureGates.enableAddonComponent=true`.\n", componentExample(a, p))
	if len(a.Definitions) > 0 {
		b.add("## Definitions\n", "| Definition | Type | What it does |", "| --- | --- | --- |")
		for _, d := range a.Definitions {
			kind, desc := capitalise(d.Kind), esc(d.Description)
			if d.Err != nil {
				kind, desc = "", "Doesn't load: see its page."
			}
			b.add(fmt.Sprintf("| [`%s`](./definitions/%s) | %s | %s |", d.Name, d.File, kind, desc))
		}
	}
	b.add("", "## More\n")
	if a.HasParams {
		b.add("- [Parameters](./parameters): everything `vela addon enable` takes.")
	}
	for _, g := range guideLinks(a) {
		b.add(g)
	}
	n := len(p.History)
	b.add(fmt.Sprintf("- [Versions](/addons/catalog/%s/versions): %d release%s of the addon and what each needs.",
		p.Name, n, map[bool]string{true: "", false: "s"}[n == 1]))
	b.add("", "## Feedback\n", "Found something wrong, or missing something you need? Tell us in kubevela/catalog:\n",
		"- "+issueLink("Report an issue", a, p, "type/bug", "Describe the issue", "What happened, and what you expected"),
		"- "+issueLink("Request an enhancement", a, p, "type/feature", "What would help",
			"What you'd like the addon to do, and what it would let you do"))
	return b.String()
}

// issueLink opens a new kubevela/catalog issue, its title and body filled in with the addon and its version.
func issueLink(text string, a *Addon, p Page, label, ask, prompt string) string {
	body := fmt.Sprintf("**Addon:** %s %s\n\n### %s\n\n<!-- %s -->\n\n### Environment\n\n"+
		"- KubeVela version:\n- Kubernetes version:\n", p.Name, p.Release.Version, ask, prompt)
	q := url.Values{"title": {"[" + p.Name + "] "}, "body": {body}, "labels": {label}}
	return fmt.Sprintf("[%s](https://github.com/kubevela/catalog/issues/new?%s)", text, q.Encode())
}

func link(text, url string) string {
	if url == "" {
		return ""
	}
	return fmt.Sprintf("[%s](%s)", text, url)
}

// componentExample installs this version with the addon component, setting one real parameter where there is one.
func componentExample(a *Addon, p Page) string {
	props := ""
	for _, f := range a.Params {
		if f.Hidden || f.Children != nil || f.Default == "" {
			continue
		}
		switch f.Type {
		case "bool", "int":
			props = fmt.Sprintf("\n        properties:\n          %s: %s", f.Name, f.Default)
		case "string":
			props = fmt.Sprintf("\n        properties:\n          %s: %q", f.Name, f.Default)
		default:
			continue
		}
		break
	}
	reg := ""
	if p.experimental() {
		reg = "\n        registry: experimental"
	}
	return fmt.Sprintf("```yaml\napiVersion: core.oam.dev/v1beta1\nkind: Application\nmetadata:\n  name: platform\n"+
		"  namespace: vela-system\nspec:\n  components:\n    - name: %s\n      type: addon\n"+
		"      properties:%s\n        version: %q%s\n```\n", p.Name, reg, p.Release.Version, props)
}

func parametersPage(a *Addon, p Page) string {
	b := lines{"---\ntitle: Parameters\nsidebar_position: 2\n---\n", "<!-- Generated from the addon's parameter.cue. -->\n",
		fmt.Sprintf("Set them when you enable the addon, `vela addon enable %s <name>=<value>`, or in VelaUX's addon form.\n", p.Name)}
	b.add(fieldList(visible(a.Params), false)...)
	return b.String()
}

func definitionPage(a *Addon, p Page, d Definition) string {
	b := lines{"---\ntitle: " + d.Name + "\n---\n", "<!-- Generated from the definition. -->\n"}
	if d.Description != "" {
		b.add(esc(d.Description) + "\n")
	}
	if d.Err != nil {
		b.add(fmt.Sprintf(":::danger Doesn't load\nKubeVela can't read this definition at addon version %s, so enabling the addon fails "+
			"on it:\n\n```\n%s\n```\n:::\n", p.Release.Version, d.Err))
		return b.String()
	}
	b.add(fmt.Sprintf("**Type:** %s. **From:** the [%s](/addons/catalog/%s/) addon.\n", d.Kind, a.Meta.Name, p.Name), "## Parameters\n")
	if len(d.Fields) == 0 {
		b.add("This definition takes no parameters.")
	} else {
		b.add(fieldList(visible(d.Fields), true)...)
	}
	return b.String()
}

func visible(fs []*Field) []*Field {
	var out []*Field
	for _, f := range fs {
		if !f.Hidden {
			g := *f
			g.Children = visible(f.Children)
			out = append(out, &g)
		}
	}
	return out
}

// defaultInUsage is a default stated in the usage's last sentence; a dot inside it (a version, a host) doesn't end it.
var defaultInUsage = regexp.MustCompile(`(?i)[,]?\s*(?:Default:|defaults? to)\s*((?:[^.]|\.\S)+?)\.?$`)

var typeEscaper = strings.NewReplacer("<", "&lt;", ">", "&gt;", "{", "&#123;", "}", "&#125;", "[", "&#91;", "]", "&#93;",
	"~", "&#126;", "*", "&#42;", "_", "&#95;")

const lockIcon = ` <span className="addon-param-lock" tabIndex="0" data-tip="Immutable: set it when the component is ` +
	`first deployed. KubeVela refuses an update that changes it, unless the Application has the annotation ` +
	`app.oam.dev/force-param-mutations: &quot;true&quot;." aria-label="Immutable"><svg viewBox="0 0 24 24" ` +
	`width="14" height="14" aria-hidden="true"><rect x="5" y="11" width="14" height="9" rx="2" fill="none" ` +
	`stroke="currentColor" strokeWidth="2"/><path d="M8 11V8a4 4 0 0 1 8 0v3" fill="none" ` +
	`stroke="currentColor" strokeWidth="2"/></svg></span>`

// fieldRow is one field in the full-width field list. A default written into +usage ("Default: x") moves to the
// default tag. Definition pages mark immutable fields with a lock.
func fieldRow(f *Field, name string, lock bool) string {
	usage, def := f.Usage, f.Default
	if m := defaultInUsage.FindStringSubmatchIndex(usage); m != nil {
		if def == "" {
			def = usage[m[2]:m[3]]
		}
		usage = strings.TrimRight(usage[:m[0]], " ")
	}
	meta := fmt.Sprintf(`<span className="addon-param-type">%s</span>`, typeEscaper.Replace(f.Type))
	if def != "" {
		meta += fmt.Sprintf(` <span className="addon-param-default">default <code>%s</code></span>`, esc(def))
	}
	if f.Required {
		meta += ` <span className="addon-param-req">required</span>`
	}
	if lock && f.Immutable {
		meta += lockIcon
	}
	return fmt.Sprintf(`<div className="addon-param"><div className="addon-param-head"><code>%s</code> %s</div>`+
		`<div className="addon-param-desc">%s</div></div>`, name, meta, esc(capitalise(usage)))
}

// fieldList lists fields, then the objects among them as folds holding their own fields.
func fieldList(fs []*Field, lock bool) []string {
	var out []string
	for _, f := range fs {
		if len(f.Children) == 0 {
			out = append(out, fieldRow(f, f.Name, lock))
		}
	}
	for _, f := range fs {
		if len(f.Children) == 0 {
			continue
		}
		name := f.Name
		if f.List {
			name += "[]"
		}
		desc := ""
		if f.Usage != "" {
			desc = " " + esc(f.Usage)
		}
		out = append(out, fmt.Sprintf("\n<details>\n<summary><code>%s</code> (%d)%s</summary>\n", name, countLeaves(f.Children), desc))
		out = append(out, fieldList(f.Children, lock)...)
		out = append(out, "\n</details>\n")
	}
	return out
}

func countLeaves(fs []*Field) int {
	n := 0
	for _, f := range fs {
		if len(f.Children) == 0 {
			n++
		} else {
			n += countLeaves(f.Children)
		}
	}
	return n
}

// guides are the addon's hand-written pages: each docs/*.md but _intro.md, with docs/index.md as the guide; an
// addon without docs/ has its README as the guide.
func guides(a *Addon, p Page) (map[string]string, error) {
	out := map[string]string{}
	sidebar := ""
	if p.offSidebar() {
		sidebar = "displayed_sidebar: addons\n"
	}
	if len(a.Docs) == 0 {
		if a.Readme == "" {
			return out, nil
		}
		body := regexp.MustCompile(`^\s*#\s+[^\n]*\n`).ReplaceAllString(a.Readme, "")
		out["guide.md"] = fmt.Sprintf("---\ntitle: Guide\nsidebar_position: 20\n%s---\n\n<!-- The addon's README at %s. -->\n\n%s\n",
			sidebar, p.Release.Tag, mdxSafe(absolute(strings.TrimSpace(body), p)))
		return out, nil
	}
	if _, ok := a.Docs["index.md"]; ok {
		if _, clash := a.Docs["guide.md"]; clash {
			return nil, fmt.Errorf("docs/index.md and docs/guide.md are both the guide; keep one")
		}
	}
	for name, src := range a.Docs {
		if name == "_intro.md" {
			continue
		}
		page := name
		title := strings.TrimSuffix(name, ".md")
		if name == "index.md" {
			page, title = "guide.md", "Guide"
		}
		fm, body := splitFrontMatter(src)
		if name == "index.md" || !strings.Contains(fm, "title:") {
			fm = setFrontMatter(fm, "title", title)
		}
		if !strings.Contains(fm, "sidebar_position:") {
			fm = setFrontMatter(fm, "sidebar_position", "20")
		}
		out[page] = fmt.Sprintf("---\n%s---\n\n<!-- From docs/%s in kubevela/catalog at %s. Edit it there. -->\n%s",
			fm, name, p.Release.Tag, body)
	}
	return out, nil
}

func guideLinks(a *Addon) []string {
	if len(a.Docs) == 0 {
		if a.Readme != "" {
			return []string{"- [Guide](./guide): how to use the addon, from its README."}
		}
		return nil
	}
	var out []string
	var names []string
	for n := range a.Docs {
		names = append(names, n)
	}
	sort.Strings(names)
	for _, n := range names {
		switch n {
		case "_intro.md":
		case "index.md":
			out = append(out, "- [Guide](./guide): how to use the addon.")
		default:
			fm, _ := splitFrontMatter(a.Docs[n])
			out = append(out, fmt.Sprintf("- [%s](./%s)", frontMatterValue(fm, "title", strings.TrimSuffix(n, ".md")), strings.TrimSuffix(n, ".md")))
		}
	}
	return out
}

func splitFrontMatter(s string) (string, string) {
	if !strings.HasPrefix(s, "---\n") {
		return "", s
	}
	end := strings.Index(s[4:], "\n---\n")
	if end < 0 {
		return "", s
	}
	return s[4 : 4+end+1], s[4+end+5:]
}

func stripFrontMatter(s string) string { _, body := splitFrontMatter(s); return body }

func setFrontMatter(fm, key, value string) string {
	re := regexp.MustCompile(`(?m)^` + key + `:.*\n`)
	if re.MatchString(fm) {
		return re.ReplaceAllString(fm, key+": "+value+"\n")
	}
	return fm + key + ": " + value + "\n"
}

func frontMatterValue(fm, key, fallback string) string {
	if m := regexp.MustCompile(`(?m)^` + key + `:\s*(.+)$`).FindStringSubmatch(fm); m != nil {
		return strings.Trim(m[1], `"'`)
	}
	return fallback
}

// mdxSafe escapes < and { outside code, so a README written as plain markdown compiles as MDX.
func mdxSafe(md string) string {
	var out []string
	fence := false
	code := regexp.MustCompile("(`[^`]*`)")
	for _, line := range strings.Split(md, "\n") {
		t := strings.TrimLeft(line, " \t")
		if strings.HasPrefix(t, "```") || strings.HasPrefix(t, "~~~") {
			fence = !fence
		} else if !fence {
			idx := code.FindAllStringIndex(line, -1)
			var b strings.Builder
			last := 0
			for _, m := range idx {
				b.WriteString(strings.NewReplacer("<", "&lt;", "{", "&#123;").Replace(line[last:m[0]]))
				b.WriteString(line[m[0]:m[1]])
				last = m[1]
			}
			b.WriteString(strings.NewReplacer("<", "&lt;", "{", "&#123;").Replace(line[last:]))
			line = b.String()
		}
		out = append(out, line)
	}
	return strings.Join(out, "\n")
}

var mdLink = regexp.MustCompile(`(!?)(\[[^\]]*\]\()([^)\s]+)`)

// absolute points a README's relative links and images at the catalog at this release.
func absolute(md string, p Page) string {
	raw := fmt.Sprintf("https://raw.githubusercontent.com/kubevela/catalog/%s/%s/", p.Release.Tag, p.Release.Path)
	md = mdLink.ReplaceAllStringFunc(md, func(s string) string {
		m := mdLink.FindStringSubmatch(s)
		target := m[3]
		if regexp.MustCompile(`^([a-z]+:|#|/)`).MatchString(target) {
			return s
		}
		base := p.srcURL() + "/"
		if m[1] == "!" {
			base = raw
		}
		return m[1] + m[2] + base + strings.TrimPrefix(target, "./")
	})
	return strings.ReplaceAll(md, "https://kubevela.net/docs/", "https://kubevela.io/docs/")
}

func versionsPage(p Page) string {
	b := lines{"---\ntitle: Versions\nsidebar_position: 30\n---\n", "<!-- Generated from the release/<addon>/<version> tags. -->\n",
		"Every release of the addon, newest first.\n", "| Addon | For KubeVela | Released | Source |", "| --- | --- | --- | --- |"}
	for i, r := range p.History {
		v := r.Version
		switch {
		case i == 0:
			v = fmt.Sprintf("[%s](/addons/catalog/%s/)", r.Version, p.Name)
		case r.Included:
			v = fmt.Sprintf("[%s](/addons/catalog/%s/%s/)", r.Version, p.Name, r.Version)
		}
		if r.Deprecated && r.Included {
			v += " (deprecated)"
		}
		var ms []string
		for _, m := range r.Minors {
			ms = append(ms, p.Config.Label(m))
		}
		for_ := strings.Join(ms, ", ")
		if for_ == "" {
			for_ = "earlier"
		}
		b.add(fmt.Sprintf("| %s | %s | %s | [%s](https://github.com/kubevela/catalog/tree/%s/%s) |", v, for_, r.Date, r.Tag, r.Tag, r.Path))
	}
	return b.String()
}

// withPicker puts the version picker on a page, after its front matter.
func withPicker(s string, p Page, key string) string {
	fm, body := splitFrontMatter(s)
	if p.offSidebar() && !strings.Contains(fm, "displayed_sidebar:") {
		fm += "displayed_sidebar: addons\n"
	}
	return fmt.Sprintf("---\n%s---\n\nimport AddonVersion from '@site/src/components/AddonVersion';\n"+
		"import versions from '@site/addons/catalog/%s/versions.json';\n\n<AddonVersion data={versions} current=%q page=%q />\n%s",
		fm, p.Name, p.Release.Version, strings.TrimSuffix(key, "/"), body)
}

// VersionsJSON is versions.json, which the site's catalog page, sidebar and version picker read.
func VersionsJSON(a *Addon, p Page, pages map[string][]string) ([]byte, error) {
	type ver struct {
		Version    string   `json:"version"`
		For        []string `json:"for"`
		Deprecated bool     `json:"deprecated"`
		Released   string   `json:"released"`
		Pages      []string `json:"pages"`
	}
	data := struct {
		Name         string   `json:"name"`
		Latest       string   `json:"latest"`
		Description  string   `json:"description"`
		Experimental bool     `json:"experimental"`
		Tags         []string `json:"tags"`
		Logo         string   `json:"logo"`
		Category     string   `json:"category"`
		Versions     []ver    `json:"versions"`
	}{Name: p.Name, Latest: p.Release.Version, Description: a.Meta.Description, Experimental: p.experimental(),
		Tags: a.Meta.Tags, Logo: p.Logo, Category: p.Category}
	if data.Tags == nil {
		data.Tags = []string{}
	}
	for _, r := range p.History {
		if r.Included {
			ms := r.Minors
			if ms == nil {
				ms = []string{}
			}
			data.Versions = append(data.Versions, ver{r.Version, ms, r.Deprecated, r.Date, pages[r.Version]})
		}
	}
	return json.MarshalIndent(data, "", " ")
}

// PageKeys are a version's pages as the picker names them: "" for the overview, "parameters", "definitions/x". The
// guide isn't one: the site's sidebar adds it on its own.
func PageKeys(rendered map[string]string) []string {
	var keys []string
	for path := range rendered {
		if path == "guide.md" {
			continue
		}
		keys = append(keys, strings.TrimSuffix(strings.TrimSuffix(strings.TrimSuffix(path, ".md"), "index"), "/"))
	}
	sort.Strings(keys)
	return keys
}

type lines []string

func (l *lines) add(s ...string) { *l = append(*l, s...) }

func (l lines) String() string {
	var keep []string
	for _, s := range l {
		if s != "" {
			keep = append(keep, s)
		}
	}
	return strings.Join(keep, "\n") + "\n"
}
