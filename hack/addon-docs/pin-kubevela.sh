#!/usr/bin/env bash
# pin-kubevela.sh: pins the generator to KubeVela's newest release (no alphas, betas or release candidates), found
# from the tags in kubevela/kubevela, and copies that release's replace block into go.mod (Go ignores a dependency's
# replace directives, so the generator needs its own copy).
#
#   hack/addon-docs/pin-kubevela.sh [--check]
#
# --check changes nothing and exits 1 when go.mod is behind the newest release. Prints the pin it set or found.
set -euo pipefail

cd "$(dirname "$0")"
module=github.com/oam-dev/kubevela
check=false
[ "${1:-}" = "--check" ] && check=true

latest=$(git ls-remote --tags --refs https://github.com/kubevela/kubevela.git 'v*' |
  sed 's#.*refs/tags/##' | grep -E '^v[0-9]+\.[0-9]+\.[0-9]+$' | sort -V | tail -1)
[ -n "$latest" ] || { echo "pin-kubevela.sh: no release tags found in kubevela/kubevela" >&2; exit 1; }
current=$(go list -m -f '{{.Version}}' "$module")

if $check; then
  if [ "$current" != "$latest" ]; then
    echo "pin-kubevela.sh: go.mod pins $current; the newest release is $latest (run hack/addon-docs/pin-kubevela.sh)" >&2
    exit 1
  fi
  echo "pin-kubevela.sh: $current is the newest release"
  exit 0
fi

upstream=$(go mod download -json "$module@$latest" | sed -n 's/.*"GoMod": "\(.*\)".*/\1/p')
[ -f "$upstream" ] || { echo "pin-kubevela.sh: no go.mod downloaded for $module@$latest" >&2; exit 1; }

# go.mod is written fresh, so nothing from the previous pin outlives it: the module, our Go version, KubeVela at the
# release, and the release's replace block (its comments included). go mod tidy resolves the rest from KubeVela's own
# requirements.
goversion=$(sed -n 's/^go //p' go.mod)
replaces=$(sed -n '/^replace (/,/^)/p' "$upstream")
[ -n "$replaces" ] || { echo "pin-kubevela.sh: $module@$latest's go.mod has no replace block; check what it needs" >&2; exit 1; }
{
  echo "module github.com/kubevela/catalog/hack/addon-docs"
  echo
  echo "go $goversion"
  echo
  echo "// Set by pin-kubevela.sh: KubeVela's newest release, and its replace block."
  echo "require $module $latest"
  echo
  printf '%s\n' "$replaces"
} > go.mod
rm -f go.sum
go mod tidy
echo "pin-kubevela.sh: pinned $module $current -> $latest"
