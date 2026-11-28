#!/usr/bin/env bash
# Runs tag.sh and check-version-bump.sh against a scratch catalog with a local remote.
#
#   hack/addon-release/test.sh [-v]
set -euo pipefail

here=$(cd "$(dirname "$0")" && pwd)
verbose=; [ "${1:-}" = "-v" ] && verbose=1
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
export GIT_AUTHOR_NAME=test GIT_AUTHOR_EMAIL=test@example.com GIT_COMMITTER_NAME=test GIT_COMMITTER_EMAIL=test@example.com
export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1

git init -q --bare "$work/remote.git"
git init -q -b master "$work/repo"
cd "$work/repo"
git remote add origin "$work/remote.git"

addon() { # <dir> <version>
  mkdir -p "$1"
  printf 'name: %s\nversion: %s\n' "${1##*/}" "$2" >"$1/metadata.yaml"
}
commit() { git add -A && git commit -q -m "$1"; }

pass=0 fail=0
expect() { # <name> <exit code wanted> <output pattern> -- <command...>
  local name=$1 want=$2 pattern=$3 out code=0
  shift 4
  out=$("$@" 2>&1) || code=$?
  if [ "$code" = "$want" ] && grep -qE -- "$pattern" <<<"$out"; then
    pass=$((pass + 1))
    [ -z "$verbose" ] || echo "ok    $name"
  else
    fail=$((fail + 1))
    printf 'FAIL  %s: exit %s, wanted %s matching %s\n%s\n' "$name" "$code" "$want" "$pattern" "$out"
  fi
}

addon addons/alpha 1.0.0
addon addons/beta 2.0.0
addon experimental/addons/gamma 0.1.0
commit "three addons"
git push -q origin master

expect "tag: refuses with no release tags" 1 "backfill the existing versions" -- "$here/tag.sh"

git tag -a release/alpha/1.0.0 -m "alpha 1.0.0" && git push -q origin release/alpha/1.0.0
expect "tag: dry run lists an addon" 0 "^release/beta/2.0.0$" -- "$here/tag.sh" -n
expect "tag: dry run lists an experimental addon" 0 "^release/gamma/0.1.0$" -- "$here/tag.sh" -n
expect "tag: dry run creates nothing" 0 "^1$" -- sh -c "git ls-remote --tags --refs origin 'refs/tags/release/*' | wc -l | tr -d ' '"
expect "tag: tags the untagged" 0 "2 release tags created" -- "$here/tag.sh"
head=$(git rev-parse HEAD)
for tag in release/beta/2.0.0 release/gamma/0.1.0; do
  # Only an annotated tag has a peeled ^{} entry on the remote.
  expect "tag: $tag pushed, annotated, at HEAD" 0 "^$head	refs/tags/$tag\^\{\}$" -- git ls-remote --tags origin "refs/tags/$tag^{}"
done
expect "tag: nothing new on a rerun" 0 "^0 new release tags$" -- "$here/tag.sh"

addon addons/epsilon 1.0.0 && commit "epsilon"
git tag -a release/epsilon/1.0.0 -m "left by a failed push" HEAD~1
expect "tag: a tag left by a failed push is redone" 0 "1 release tags created" -- "$here/tag.sh"
expect "tag: the redone tag is at HEAD on the remote" 0 "^$(git rev-parse HEAD)	" -- git ls-remote --tags origin "refs/tags/release/epsilon/1.0.0^{}"

# Another run pushes the same tag between this run's listing and its push: race <tag> <commit-ish>.
git clone -q "$work/remote.git" "$work/other"
race() {
  rm -f "$work/raced"
  cat >.git/hooks/pre-push <<HOOK
#!/bin/sh
[ -e "$work/raced" ] && exit 0
touch "$work/raced"
git -C "$work/other" fetch -q "$work/repo" "$2" &&
  git -C "$work/other" tag -a "$1" -m "from another run" FETCH_HEAD &&
  git -C "$work/other" push -q origin "$1"
HOOK
  chmod +x .git/hooks/pre-push
}
addon addons/eta 1.0.0 && addon addons/theta 1.0.0 && commit "eta and theta"
race release/eta/1.0.0 HEAD
expect "tag: a tag another run pushed first is accepted" 0 "1 release tags created at [0-9a-f]+, 1 already pushed by another run" -- "$here/tag.sh"
expect "tag: the rest of that run's tags are pushed" 0 "refs/tags/release/theta/1.0.0" -- git ls-remote --tags origin "refs/tags/release/theta/1.0.0"

addon addons/iota 1.0.0 && commit "iota"
git branch -f before-iota HEAD~1 && race release/iota/1.0.0 before-iota
expect "tag: a raced tag without that version is refused" 1 "release/iota/1.0.0 is on origin, but not at a commit with addons/iota at 1.0.0" -- "$here/tag.sh"
rm .git/hooks/pre-push

base=$(git rev-parse HEAD)
check() { git checkout -q -B "$1" "$base"; }

check no-bump
echo "x" >addons/alpha/template.cue && commit "alpha change"
expect "check: change without a bump" 1 "addons/alpha changed but its version is still 1.0.0" -- "$here/check-version-bump.sh" "$base"

check bump
echo "x" >addons/alpha/template.cue && addon addons/alpha 1.0.1 && commit "alpha 1.0.1"
expect "check: change with a bump" 0 "1 changed addons checked, 0 without" -- "$here/check-version-bump.sh" "$base"

check docs-only
mkdir -p addons/alpha/docs && echo "# docs" >addons/alpha/docs/index.md && commit "alpha docs"
expect "check: docs/ alone needs no bump" 0 "0 changed addons checked" -- "$here/check-version-bump.sh" "$base"

check docs-and-code
mkdir -p addons/alpha/docs && echo "# docs" >addons/alpha/docs/index.md && echo "x" >addons/alpha/README.md && commit "alpha docs and readme"
expect "check: docs/ plus another file needs a bump" 1 "addons/alpha changed" -- "$here/check-version-bump.sh" "$base"

check released
git tag -a release/alpha/0.9.0 -m "alpha 0.9.0" "$base" && git push -q origin release/alpha/0.9.0
addon addons/alpha 0.9.0 && commit "alpha back to 0.9.0"
expect "check: a released version is refused" 1 "is at 0.9.0, which was released already" -- "$here/check-version-bump.sh" "$base"

check experimental
echo "x" >experimental/addons/gamma/template.cue && commit "gamma change"
expect "check: experimental addons are checked" 1 "experimental/addons/gamma changed" -- "$here/check-version-bump.sh" "$base"

check new-addon
addon addons/delta 0.1.0 && commit "delta"
expect "check: a new addon passes" 0 "1 changed addons checked, 0 without" -- "$here/check-version-bump.sh" "$base"

check removed
git rm -q -r addons/beta && commit "remove beta"
expect "check: a removed addon passes" 0 "0 changed addons checked" -- "$here/check-version-bump.sh" "$base"

check outside
echo "x" >README.md && commit "readme"
expect "check: changes outside addons pass" 0 "0 changed addons checked" -- "$here/check-version-bump.sh" "$base"

check no-version
echo "x" >addons/alpha/template.cue && printf 'name: alpha\n' >addons/alpha/metadata.yaml && commit "alpha loses its version"
expect "check: a missing version is refused" 1 "addons/alpha has no version" -- "$here/check-version-bump.sh" "$base"

check renamed
addon addons/zeta 0.1.0 && printf 'name: other\nversion: 0.1.0\n' >addons/zeta/metadata.yaml && commit "zeta named other"
expect "check: a name that differs from the directory is refused" 1 "addons/zeta is named other" -- "$here/check-version-bump.sh" "$base"

check stale-base
echo "x" >addons/beta/template.cue && addon addons/beta 2.1.0 && commit "beta 2.1.0 here"
git checkout -q -B master "$base" && echo "y" >addons/beta/other.cue && addon addons/beta 2.1.0 && commit "beta 2.1.0 on master"
git checkout -q stale-base
expect "check: the same bump already on the base is refused" 1 "addons/beta changed but its version is still 2.1.0" -- \
  "$here/check-version-bump.sh" master

echo "$pass passed, $fail failed"
[ "$fail" -eq 0 ]
