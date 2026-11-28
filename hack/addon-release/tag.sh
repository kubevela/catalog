#!/usr/bin/env bash
# Tags every addon's current version as release/<addon>/<version> at HEAD, for each one not tagged yet,
# and pushes the new tags to the remote. Run by the publish workflow after the registry is deployed.
#
#   hack/addon-release/tag.sh [-n] [remote]
#
#   -n      print the tags it would create, create nothing
#   remote  where tags are read from and pushed to (default origin)
#
# A version is tagged once, at the first published commit carrying it; the version-bump check keeps
# its files unchanged after that. With no release/* tags on the remote at all, it stops: the existing
# versions are backfilled first, or every addon would be tagged at today's commit.
set -euo pipefail

dry=
if [ "${1:-}" = "-n" ]; then dry=1; shift; fi
remote=${1:-origin}
cd "$(git rev-parse --show-toplevel)"

existing=$(git ls-remote --tags --refs "$remote" 'refs/tags/release/*' | awk '{sub("refs/tags/", "", $2); print $2}')
if [ -z "$existing" ]; then
  echo "no release/* tags on $remote: backfill the existing versions before tagging new ones" >&2
  exit 1
fi

new=() dirs=()
for meta in addons/*/metadata.yaml experimental/addons/*/metadata.yaml; do
  [ -f "$meta" ] || continue
  dir=${meta%/metadata.yaml}
  addon=${dir##*/}
  version=$(sed -n 's/^version:[[:space:]]*["'\'']\{0,1\}\([^"'\''[:space:]]*\).*/\1/p' "$meta" | head -1)
  if [ -z "$version" ]; then
    echo "$meta has no version" >&2
    exit 1
  fi
  tag="release/$addon/$version"
  if ! grep -qxF "$tag" <<<"$existing"; then
    new+=("$tag")
    dirs+=("$dir")
  fi
done

if [ ${#new[@]} -eq 0 ]; then
  echo "0 new release tags"
  exit 0
fi
printf '%s\n' "${new[@]}"
if [ -n "$dry" ]; then
  echo "${#new[@]} release tags to create (dry run)"
  exit 0
fi

# Runs may overlap. A version's files never change while it is current (the version-bump check), so
# a tag another run pushed first holds the same files: accept it once its version is checked.
head=$(git rev-parse HEAD)
created=0 raced=0
for i in "${!new[@]}"; do
  tag=${new[$i]} dir=${dirs[$i]}
  rest=${tag#release/}
  git tag -a -f "$tag" -m "${rest%%/*} ${rest#*/}" "$head" >/dev/null # -f: a local tag left by a failed push
  if err=$(git push -q "$remote" "refs/tags/$tag" 2>&1); then
    created=$((created + 1))
  elif git fetch -q -f "$remote" "refs/tags/$tag:refs/tags/$tag" 2>/dev/null; then
    if [ "$(git show "$tag:$dir/metadata.yaml" 2>/dev/null | sed -n 's/^version:[[:space:]]*["'\'']\{0,1\}\([^"'\''[:space:]]*\).*/\1/p' | head -1)" != "${rest#*/}" ]; then
      echo "$tag is on $remote, but not at a commit with $dir at ${rest#*/}" >&2
      exit 1
    fi
    raced=$((raced + 1))
  else
    echo "pushing $tag failed: $err" >&2
    exit 1
  fi
done
if [ "$raced" -gt 0 ]; then
  echo "$created release tags created at ${head:0:10}, $raced already pushed by another run"
else
  echo "$created release tags created at ${head:0:10}"
fi
