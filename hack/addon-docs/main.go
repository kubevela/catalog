// addon-docs writes the docs site's addon catalog pages from the catalog's published addons: for each addon, its
// overview, parameters, definitions, guides and versions, for every version back to the oldest KubeVela release the
// docs cover. The docs site fetches the result from the docs-site branch.
//
//	go run . -out <dir> [-repo <catalog>] [addon...]
//
// With no addons named it writes every addon with release tags. It prints one line per failure and a summary.
package main

import (
	"bytes"
	"flag"
	"fmt"
	"io"
	"net/http"
	neturl "net/url"
	"os"
	"os/exec"
	"path/filepath"
	"sort"
	"strings"
	"sync"
	"time"

	"github.com/kubevela/pkg/cue/cuex"
)

func main() {
	repo := flag.String("repo", "../..", "the catalog repository, with its release tags fetched")
	out := flag.String("out", "", "the directory to write each addon's pages into (required)")
	configPath := flag.String("config", "config.yaml", "the KubeVela releases the docs cover")
	overridesPath := flag.String("overrides", "overrides.yaml", "categories and logos")
	logos := flag.Bool("logos", true, "download each addon's logo")
	strict := flag.Bool("strict", false, "exit non-zero when any addon fails, rather than leaving it out")
	jobs := flag.Int("jobs", 6, "addons rendered at once")
	flag.Parse()
	if err := checkJobs(*jobs); err != nil {
		fmt.Fprintln(os.Stderr, "addon-docs:", err)
		os.Exit(2)
	}
	if *out == "" {
		fmt.Fprintln(os.Stderr, "addon-docs: -out is required")
		os.Exit(2)
	}
	if err := offline(); err != nil {
		fmt.Fprintln(os.Stderr, "addon-docs:", err)
		os.Exit(2)
	}

	var cfg Config
	var ov Overrides
	for path, into := range map[string]interface{}{*configPath: &cfg, *overridesPath: &ov} {
		if err := readYAML(path, into); err != nil {
			fmt.Fprintln(os.Stderr, "addon-docs:", err)
			os.Exit(2)
		}
	}
	if err := ov.check(); err != nil {
		fmt.Fprintln(os.Stderr, "addon-docs:", err)
		os.Exit(2)
	}
	names := flag.Args()
	if len(names) == 0 {
		var err error
		if names, err = Published(*repo); err != nil {
			fmt.Fprintln(os.Stderr, "addon-docs:", err)
			os.Exit(2)
		}
	}

	g := &generator{repo: *repo, out: *out, cfg: cfg, ov: ov, logos: *logos, today: time.Now().UTC().Format("2006-01-02")}
	var (
		mu     sync.Mutex
		failed []string
		pages  int
		wg     sync.WaitGroup
		queue  = make(chan string)
	)
	for i := 0; i < *jobs; i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			for name := range queue {
				n, err := g.addon(name)
				mu.Lock()
				pages += n
				if err != nil {
					failed = append(failed, name)
					fmt.Fprintf(os.Stderr, "%s: %v\n", name, err)
				}
				mu.Unlock()
			}
		}()
	}
	for _, n := range names {
		queue <- n
	}
	close(queue)
	wg.Wait()
	sort.Strings(failed)
	fmt.Printf("addon-docs: %d addons, %d pages, %d failed%s\n", len(names)-len(failed), pages, len(failed),
		map[bool]string{true: " (" + strings.Join(failed, ", ") + ")", false: ""}[len(failed) > 0])
	if *strict && len(failed) > 0 {
		os.Exit(1)
	}
}

func checkJobs(n int) error {
	if n < 1 {
		return fmt.Errorf("-jobs is %d; it must be at least 1", n)
	}
	return nil
}

// offline keeps the tool off any cluster: kubevela's CUE compiler would otherwise read external packages from
// whatever cluster the kubeconfig names, and its client singletons exit the process without a kubeconfig at all.
func offline() error {
	cuex.EnableExternalPackageForDefaultCompiler = false
	if os.Getenv("KUBECONFIG") != "" {
		return nil
	}
	if home, err := os.UserHomeDir(); err == nil {
		if _, err := os.Stat(filepath.Join(home, ".kube", "config")); err == nil {
			return nil
		}
	}
	f, err := os.CreateTemp("", "addon-docs-kubeconfig-*")
	if err != nil {
		return err
	}
	defer f.Close() // nolint:errcheck
	// A kubeconfig that parses and points nowhere: nothing here talks to a cluster.
	_, err = f.WriteString("apiVersion: v1\nkind: Config\nclusters:\n- name: none\n  cluster:\n    server: https://127.0.0.1:1\n" +
		"contexts:\n- name: none\n  context:\n    cluster: none\n    user: none\ncurrent-context: none\nusers:\n- name: none\n  user: {}\n")
	if err != nil {
		return err
	}
	return os.Setenv("KUBECONFIG", f.Name())
}

type generator struct {
	repo, out string
	cfg       Config
	ov        Overrides
	logos     bool
	today     string
}

// addon writes every included version of one addon: the latest at <out>/<name>/, older ones at <out>/<name>/<v>/.
func (g *generator) addon(name string) (int, error) {
	rels, err := Releases(g.repo, name)
	if err != nil {
		return 0, err
	}
	Classify(g.cfg, rels, g.today)
	final := filepath.Join(g.out, name)
	if err := os.RemoveAll(final); err != nil {
		return 0, err
	}
	work, err := os.MkdirTemp("", "addon-docs-"+name+"-")
	if err != nil {
		return 0, err
	}
	defer os.RemoveAll(work) // nolint:errcheck
	// The pages are written beside the output and moved into place only once all of them are, so an addon that
	// fails part way leaves nothing to publish.
	if err := os.MkdirAll(g.out, 0o750); err != nil {
		return 0, err
	}
	dir, err := os.MkdirTemp(g.out, "."+name+"-")
	if err != nil {
		return 0, err
	}
	defer os.RemoveAll(dir) // nolint:errcheck

	ov := g.ov.Addons[name]
	pages := map[string][]string{}
	var latest *Addon
	var latestPage Page
	n := 0
	for i, r := range rels {
		if !r.Included {
			continue
		}
		src, err := g.extract(r, filepath.Join(work, r.Version))
		if err != nil {
			return n, err
		}
		a, err := LoadAddon(src)
		if err != nil {
			return n, fmt.Errorf("%s: %w", r.Version, err)
		}
		for _, d := range a.Definitions {
			if d.Err != nil && i == 0 {
				fmt.Fprintf(os.Stderr, "%s: %s: definitions/%s.cue doesn't load: %v\n", name, r.Version, d.File, d.Err)
			}
		}
		p := Page{Name: name, Release: r, History: rels, Latest: i == 0, Config: g.cfg, Category: ov.Category}
		target := dir
		if i == 0 {
			latest = a
			if g.logos {
				p.Logo = fetchLogo(firstNonEmpty(ov.Logo, a.Meta.Icon), dir, name, ov.LogoCrop == "square")
			}
		} else {
			target = filepath.Join(dir, r.Version)
		}
		rendered, err := Render(a, p)
		if err != nil {
			return n, fmt.Errorf("%s: %w", r.Version, err)
		}
		for path, body := range rendered {
			if err := writeFile(filepath.Join(target, path), []byte(body)); err != nil {
				return n, err
			}
			n++
		}
		pages[r.Version] = PageKeys(rendered)
		if i == 0 {
			latestPage = p
		}
	}
	// versions.json lists every version's pages, so it is written last.
	data, err := VersionsJSON(latest, latestPage, pages)
	if err != nil {
		return n, err
	}
	if err := writeFile(filepath.Join(dir, "versions.json"), data); err != nil {
		return n, err
	}
	return n + 1, os.Rename(dir, final)
}

// extract checks the addon out of its release tag into dir and returns the addon's directory.
func (g *generator) extract(r *Release, dir string) (string, error) {
	if err := os.MkdirAll(dir, 0o750); err != nil {
		return "", err
	}
	archive := exec.Command("git", "-C", g.repo, "archive", r.Tag, r.Path) // #nosec G204
	tar := exec.Command("tar", "-x", "-C", dir)
	var stderr bytes.Buffer
	archive.Stderr, tar.Stderr = &stderr, &stderr
	pipe, err := archive.StdoutPipe()
	if err != nil {
		return "", err
	}
	tar.Stdin = pipe
	if err := tar.Start(); err != nil {
		return "", err
	}
	if err := archive.Run(); err != nil {
		return "", fmt.Errorf("git archive %s: %w: %s", r.Tag, err, strings.TrimSpace(stderr.String()))
	}
	if err := tar.Wait(); err != nil {
		return "", fmt.Errorf("tar: %w: %s", err, strings.TrimSpace(stderr.String()))
	}
	return filepath.Join(dir, r.Path), nil
}

func writeFile(path string, data []byte) error {
	if err := os.MkdirAll(filepath.Dir(path), 0o750); err != nil {
		return err
	}
	return os.WriteFile(path, data, 0o600)
}

func firstNonEmpty(s ...string) string {
	for _, x := range s {
		if x != "" {
			return x
		}
	}
	return ""
}

// fetchLogo downloads a logo beside the pages, so the site never hotlinks it, and returns its file name; "" when
// there is none or it isn't an image under 4 MB (the site then draws a placeholder). Raster logos are shrunk to
// logoSize, and cropped to their centre square when square is set.
func fetchLogo(url, dir, name string, square bool) string {
	if !strings.HasPrefix(url, "https://") && !strings.HasPrefix(url, "http://") {
		return ""
	}
	req, err := http.NewRequest(http.MethodGet, url, nil)
	if err != nil {
		return ""
	}
	req.Header.Set("User-Agent", "kubevela-addon-docs")
	resp, err := (&http.Client{Timeout: 15 * time.Second}).Do(req)
	if err != nil {
		fmt.Fprintf(os.Stderr, "%s: no logo, %s: %v\n", name, redact(url), err)
		return ""
	}
	defer resp.Body.Close() // nolint:errcheck
	data, err := io.ReadAll(io.LimitReader(resp.Body, maxLogoBytes+1))
	kind := imageKind(data)
	if err != nil || resp.StatusCode != http.StatusOK || len(data) > maxLogoBytes || kind == "" {
		fmt.Fprintf(os.Stderr, "%s: no logo, %s: %s, not an image under 4 MB\n", name, redact(url), resp.Status)
		return ""
	}
	if kind != "svg" {
		if data, kind, err = shrinkLogo(data, kind, square); err != nil {
			fmt.Fprintf(os.Stderr, "%s: no logo, %s: %v\n", name, redact(url), err)
			return ""
		}
	}
	file := "logo." + kind
	if err := writeFile(filepath.Join(dir, file), data); err != nil {
		return ""
	}
	return file
}

// redact is a URL fit for a log: its host and path, without credentials, query or fragment.
func redact(raw string) string {
	u, err := neturl.Parse(raw)
	if err != nil {
		return "(a URL that doesn't parse)"
	}
	return u.Scheme + "://" + u.Host + u.Path
}

// imageKind is the image format of the bytes by their signature, or "" when they aren't an image: a URL to a web
// page about the file answers with HTML.
func imageKind(data []byte) string {
	head := bytes.ToLower(bytes.TrimSpace(data[:min(len(data), 1024)]))
	switch {
	case bytes.HasPrefix(data, []byte("\x89PNG\r\n\x1a\n")):
		return "png"
	case bytes.HasPrefix(data, []byte("\xff\xd8\xff")):
		return "jpg"
	case bytes.HasPrefix(data, []byte("GIF87a")), bytes.HasPrefix(data, []byte("GIF89a")):
		return "gif"
	case len(data) > 12 && string(data[:4]) == "RIFF" && string(data[8:12]) == "WEBP":
		return "webp"
	case bytes.Contains(head, []byte("<svg")) && !bytes.Contains(head, []byte("<html")):
		return "svg"
	}
	return ""
}
