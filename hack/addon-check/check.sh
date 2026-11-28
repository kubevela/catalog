#!/usr/bin/env bash
# Checks that each addon built on the shared install has what an addon needs.
#
# An addon with resources/install.cue must have:
#   metadata.yaml   name, version, description, url, a system.vela floor, tags from
#                   hack/addon-check/tags.txt (a CNCF maturity and a landscape subcategory),
#                   and an icon URL that serves an image; url is the chart's home, read from
#                   the chart repository in template.cue (both fetched unless --offline)
#   README.md       for the catalog
#   docs/index.md   the reference page copied to the documentation site, with a title; every
#                   page under docs/ links the site by absolute URL (/docs/..., /addons/...,
#                   never to a .md file), and its own pages and images relatively, inside docs/
#   tests/          at least one *_test.cue, run with vela def test
#
#   hack/addon-check/check.sh             check every such addon
#   hack/addon-check/check.sh --offline   skip fetching icons
#   hack/addon-check/check.sh -v          also name the addons that pass
#
# Needs python3 with PyYAML, and curl unless --offline.
# Exit codes: 0 every addon passes, 1 an addon is missing something, 2 usage or a missing tool.
set -euo pipefail

offline=0
verbose=0
for arg in "$@"; do
	case "$arg" in
	--offline) offline=1 ;;
	-v) verbose=1 ;;
	-h | --help)
		sed -n '2,20p' "$0" | sed 's/^# \{0,1\}//'
		exit 0
		;;
	*)
		echo "unknown argument: $arg" >&2
		exit 2
		;;
	esac
done

if ! python3 -c 'import yaml' 2>/dev/null; then
	echo "python3 cannot import yaml: pip install pyyaml" >&2
	exit 2
fi
if [ "$offline" = 0 ] && ! command -v curl >/dev/null 2>&1; then
	echo "curl not found: install it, or pass --offline" >&2
	exit 2
fi

root=$(cd "$(dirname "$0")/../.." && pwd)
passed=0
failed=0

for dir in "$root"/addons/*/ "$root"/experimental/addons/*/; do
	addon=${dir%/}
	[ -f "$addon/resources/install.cue" ] || continue
	name=${addon#"$root"/}
	problems=$(python3 - "$addon" "$offline" "$root/hack/addon-check/tags.txt" <<'EOF'
import glob, os, re, subprocess, sys, yaml

addon, offline, vocab_file = sys.argv[1], sys.argv[2] == "1", sys.argv[3]
vocab = {l.strip() for l in open(vocab_file) if l.strip() and not l.startswith("#")}
out = []

try:
    meta = yaml.safe_load(open(os.path.join(addon, "metadata.yaml"))) or {}
    if not isinstance(meta, dict):
        raise ValueError("not a mapping")
except Exception as e:
    meta = {}
    out.append("metadata.yaml: %s" % e)
for key in ("name", "version", "description", "url"):
    if not meta.get(key):
        out.append("metadata.yaml: no %s" % key)
system = meta.get("system")
if not isinstance(system, dict) or not system.get("vela"):
    out.append("metadata.yaml: no system.vela floor")
tags = meta.get("tags") or []
if not isinstance(tags, list):
    out.append("metadata.yaml: tags is not a list")
    tags = []
for t in tags:
    if not isinstance(t, str):
        out.append("metadata.yaml: tag %r is not a string" % (t,))
    elif t not in vocab:
        out.append("metadata.yaml: tag %r is not in hack/addon-check/tags.txt" % t)
maturities = [t for t in tags if t in ("Graduated", "Incubating", "Sandbox", "Non-CNCF")]
if len(maturities) != 1:
    out.append("metadata.yaml: tags need exactly one of Graduated, Incubating, Sandbox, Non-CNCF")
if len(tags) - len(maturities) != 1:
    out.append("metadata.yaml: tags need exactly one landscape subcategory")

def fetch(url):
    r = subprocess.run(["curl", "-sSfL", "--max-time", "30", url], capture_output=True, text=True)
    return r.stdout if r.returncode == 0 else None

template_file = os.path.join(addon, "template.cue")
template = open(template_file).read() if os.path.isfile(template_file) else None
if template is None:
    out.append("no template.cue")
repo = re.search(r'repoURL:\s*"([^"]+)"', template or "")
source = re.search(r'source:\s*"([^"]+)"', template or "")
# An OCI repository has no index.yaml; its chart's home goes unchecked.
if not offline and meta.get("url") and template is not None and not (repo and repo.group(1).startswith("oci://")):
    index = fetch(repo.group(1).rstrip("/") + "/index.yaml") if repo and source else None
    if index is None:
        out.append("template.cue: cannot read the chart repository's index to compare url")
    else:
        entries = (yaml.safe_load(index) or {}).get("entries", {}).get(source.group(1)) or []
        # The entry for a version the addon pins, else the newest.
        pinned = set(re.findall(r'\bversion:\s*"([^"]+)"', template))
        entry = next((e for e in entries if e.get("version") in pinned), entries[0] if entries else {})
        home = entry.get("home") or ""
        if not home:
            out.append("chart %s has no home to compare url with" % source.group(1))
        elif home.rstrip("/") != meta["url"].rstrip("/"):
            out.append("metadata.yaml: url %s is not the chart's home, %s" % (meta["url"], home))

icon = meta.get("icon") or ""
if not icon.startswith("https://"):
    out.append("metadata.yaml: icon is not an https URL")
elif not offline:
    r = subprocess.run(["curl", "-sSL", "-o", "/dev/null", "--max-time", "20", "-w", "%{http_code} %{content_type}", icon],
                       capture_output=True, text=True)
    status = r.stdout.strip()
    if r.returncode != 0 or not status.startswith("200 image/"):
        out.append("metadata.yaml: icon %s gave %s" % (icon, (status or r.stderr.strip()) or "nothing"))

if not os.path.isfile(os.path.join(addon, "README.md")):
    out.append("no README.md")
page = os.path.join(addon, "docs", "index.md")
if not os.path.isfile(page):
    out.append("no docs/index.md")
else:
    front = re.match(r"---\n(.*?)\n---\n", open(page).read(), flags=re.S)
    try:
        fm = yaml.safe_load(front.group(1)) if front else None
    except yaml.YAMLError:
        fm = None
    if not isinstance(fm, dict) or not str(fm.get("title") or "").strip():
        out.append("docs/index.md: no front matter title")
docs = os.path.join(addon, "docs")
for page in sorted(glob.glob(os.path.join(docs, "**", "*.md"), recursive=True)):
    rel = os.path.relpath(page, addon)
    # Links outside code: fenced blocks (backtick or tilde) and inline code are examples, not links.
    tick = chr(96)
    body = re.sub(r"^ {0,3}(" + tick * 3 + "|~~~).*?^ {0,3}\\1", "", open(page).read(), flags=re.S | re.M)
    body = re.sub(tick + "[^" + tick + "\n]*" + tick, "", body)
    for angled, bare in re.findall(r"\]\(\s*(?:<([^>\n]+)>|([^)\s]+))", body):
        target = angled or bare
        path = re.split(r"[?#]", target, 1)[0]
        if not path or re.match(r"[a-z][a-z0-9+.-]*:", path, flags=re.I) or path.startswith("//"):
            continue
        if path.startswith("/"):
            if path.endswith(".md"):
                out.append("%s: %s links a .md file on the site; drop the .md" % (rel, target))
            elif not re.match(r"/(docs|addons)(/|$)", path):
                out.append("%s: %s is not a site page; site links start /docs/ or /addons/" % (rel, target))
            continue
        resolved = os.path.normpath(os.path.join(os.path.dirname(page), path))
        if not (resolved + os.sep).startswith(docs + os.sep):
            out.append("%s: %s leaves docs/; link the site by absolute URL (/docs/..., /addons/...)" % (rel, target))
        elif not os.path.exists(resolved):
            out.append("%s: %s does not exist" % (rel, target))
if not glob.glob(os.path.join(addon, "tests", "*_test.cue")):
    out.append("no tests/*_test.cue")

print("\n".join(out))
EOF
)
	if [ -z "$problems" ]; then
		passed=$((passed + 1))
		[ "$verbose" = 1 ] && echo "ok   $name"
		continue
	fi
	failed=$((failed + 1))
	echo "$problems" | sed "s|^|FAIL $name: |"
done

echo "addon-check: $passed passed, $failed failed"
[ "$failed" = 0 ]
