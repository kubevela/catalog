#!/usr/bin/env bash
# Checks that every addon a change touches has a new version: present, changed since <base>, and not
# released already (no release/<addon>/<version> tag on the remote), and that its metadata.yaml name
# matches its directory. Changes only to an addon's docs/ need no bump, since its pages are built
# from master.
#
#   hack/addon-release/check-version-bump.sh <base> [remote]
#
#   base    the commit the change is compared with, such as the pull request's base
#   remote  where release tags are read from (default origin)
set -euo pipefail

base=${1:?usage: check-version-bump.sh <base> [remote]}
remote=${2:-origin}
cd "$(git rev-parse --show-toplevel)"

field_of() { # <field> <ref or empty for the working tree> <dir>
  if [ -z "$2" ]; then cat "$3/metadata.yaml" 2>/dev/null; else git show "$2:$3/metadata.yaml" 2>/dev/null; fi |
    sed -n "s/^$1:[[:space:]]*[\"']\{0,1\}\([^\"'[:space:]]*\).*/\1/p" | head -1 || true
}

released=$(git ls-remote --tags --refs "$remote" 'refs/tags/release/*' | awk '{sub("refs/tags/", "", $2); print $2}')
dirs=$(git diff --name-only "$(git merge-base "$base" HEAD)" HEAD -- addons experimental/addons |
  { grep -Ev '^(experimental/)?addons/[^/]+/docs/' || true; } |
  sed -nE 's#^((experimental/)?addons/[^/]+)/.*#\1#p' | sort -u)

checked=0 failed=0
for dir in $dirs; do
  [ -f "$dir/metadata.yaml" ] || continue # removed
  checked=$((checked + 1))
  addon=${dir##*/}
  now=$(field_of version "" "$dir")
  before=$(field_of version "$base" "$dir")
  name=$(field_of name "" "$dir")
  if [ -z "$now" ]; then
    echo "$dir has no version in its metadata.yaml"
    failed=$((failed + 1))
  elif [ "$name" != "$addon" ]; then
    # The registry publishes by name and release tags are by directory: they have to agree.
    echo "$dir is named ${name:-nothing} in its metadata.yaml: name it $addon, after its directory"
    failed=$((failed + 1))
  elif [ -n "$before" ] && [ "$now" = "$before" ]; then
    echo "$dir changed but its version is still $now: bump version in $dir/metadata.yaml"
    failed=$((failed + 1))
  elif grep -qxF "release/$addon/$now" <<<"$released"; then
    echo "$dir is at $now, which was released already: choose a version not yet released"
    failed=$((failed + 1))
  fi
done

echo "$checked changed addons checked, $failed without a new version"
[ "$failed" -eq 0 ]
