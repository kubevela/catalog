#!/usr/bin/env bash
# publish.sh: generates the addon docs pages and pushes them to the docs-site branch, which the KubeVela docs site
# fetches when it builds. The branch holds one commit, the generated pages; each run replaces it.
#
#   hack/addon-docs/publish.sh [--dry-run]
#
# Run from the catalog's root with every release/* tag fetched. --dry-run generates and stops before the push.
# Prints the generator's summary, and the commit pushed.
set -euo pipefail

dry_run=false
[ "${1:-}" = "--dry-run" ] && dry_run=true
root=$(git rev-parse --show-toplevel)
branch=${ADDON_DOCS_BRANCH:-docs-site}
remote=${ADDON_DOCS_REMOTE:-origin}

[ -n "$(git -C "$root" tag -l 'release/*' | head -1)" ] ||
  { echo "publish.sh: no release/* tags; fetch them first (git fetch --tags)" >&2; exit 1; }

out=$(mktemp -d)
trap 'rm -rf "${out:?}"' EXIT
(cd "$root/hack/addon-docs" && go run . -repo "$root" -out "$out/site")

if $dry_run; then
  echo "publish.sh: dry run, $(find "$out/site" -name '*.md' | wc -l | tr -d ' ') pages in $out/site, not pushed"
  trap - EXIT
  exit 0
fi

# One commit on an empty history: the branch is build output, not something to review or merge.
git -C "$out/site" init -q -b "$branch"
git -C "$out/site" add -A
git -C "$out/site" -c user.name="${GIT_AUTHOR_NAME:-github-actions[bot]}" \
  -c user.email="${GIT_AUTHOR_EMAIL:-41898282+github-actions[bot]@users.noreply.github.com}" \
  commit -q -m "Addon docs from $(git -C "$root" rev-parse --short HEAD)"
commit=$(git -C "$out/site" rev-parse HEAD)
# Pushed from the catalog's own checkout, which holds the credentials (actions/checkout keeps them in its config).
git -C "$root" fetch -q "$out/site" "$commit"
git -C "$root" push -q --force "$remote" "${commit}:refs/heads/${branch}"
echo "publish.sh: pushed $(git -C "$root" rev-parse --short "$commit") to ${branch}"
