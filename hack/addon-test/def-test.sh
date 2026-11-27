#!/usr/bin/env bash
# Runs `vela def test` for each addon a change touches.
#
# Takes the changed paths, relative to the repository root, as arguments or one per
# line on stdin. A path under addons/<name>/ or experimental/addons/<name>/ selects
# that addon, unless it is documentation: docs/, Markdown or an image (png, jpg,
# jpeg, gif, svg, webp, avif, ico). A change to the shared addon tooling
# (hack/addon-*/) or this workflow selects every addon. Each selected addon with
# tests/*_test.cue is tested; one without tests is skipped.
#
#   hack/addon-test/def-test.sh [-v] [--all] [path...]
#
#   --all   test every addon that has tests, whatever changed
#   -v      print each addon's full output, and the addons skipped
#
# VELA names the vela binary (default: vela on PATH), 1.12.0-alpha.3 or later.
# Exit: 0 when every test passes, 1 when any fails, 2 on a usage or tool error.
set -euo pipefail

self="$(cd "$(dirname "$0")" && pwd)/$(basename "$0")"
cd "$(git rev-parse --show-toplevel)"
vela=${VELA:-vela}
verbose=0
all=0
paths=""
while [ $# -gt 0 ]; do
	case $1 in
	-v) verbose=1 ;;
	--all) all=1 ;;
	-h | --help)
		sed -n '2,17p' "$self" | sed 's/^# \{0,1\}//'
		exit 0
		;;
	-*)
		echo "def-test: unknown flag $1" >&2
		exit 2
		;;
	*) paths="$paths$1"$'\n' ;;
	esac
	shift
done
if [ "$all" = 0 ] && [ -z "$paths" ] && [ ! -t 0 ]; then
	paths=$(cat)
fi

if ! command -v "$vela" >/dev/null 2>&1; then
	echo "def-test: $vela not found; install the vela CLI (1.12.0-alpha.3 or later) or set VELA" >&2
	exit 2
fi
if ! "$vela" def test --help >/dev/null 2>&1; then
	echo "def-test: $vela has no 'def test'; it needs 1.12.0-alpha.3 or later" >&2
	exit 2
fi

# Paths that change how every addon is tested.
everything() {
	case $1 in
	hack/addon-*/* | .github/workflows/addon-def-test.yaml) return 0 ;;
	esac
	return 1
}

selected=""
add() {
	if ! printf '%s' "$selected" | grep -qxF "$1"; then
		selected="$selected$1"$'\n'
	fi
}

if [ "$all" = 0 ]; then
	while IFS= read -r p; do
		[ -n "$p" ] || continue
		if everything "$p"; then
			all=1
			break
		fi
		case $p in
		experimental/addons/*/*) rest=${p#experimental/addons/} && dir=experimental/addons/${rest%%/*} ;;
		addons/*/*) rest=${p#addons/} && dir=addons/${rest%%/*} ;;
		*) continue ;;
		esac
		case ${rest#*/} in
		docs/* | *.md | *.png | *.jpg | *.jpeg | *.gif | *.svg | *.webp | *.avif | *.ico) continue ;;
		esac
		add "$dir"
	done <<EOF
$paths
EOF
fi
if [ "$all" = 1 ]; then
	selected=""
	for d in addons/*/ experimental/addons/*/; do
		add "${d%/}"
	done
fi

if [ -z "$selected" ]; then
	echo "def-test: no addon changes to test"
	exit 0
fi

passed=0
failed=0
skipped=0
while IFS= read -r dir; do
	[ -n "$dir" ] || continue
	if [ ! -d "$dir" ] || ! ls "$dir"/tests/*_test.cue >/dev/null 2>&1; then
		skipped=$((skipped + 1))
		[ "$verbose" = 0 ] || echo "skip $dir: no tests"
		continue
	fi
	if out=$("$vela" def test "$dir/tests" 2>&1); then
		passed=$((passed + 1))
		if [ "$verbose" = 1 ]; then
			printf '%s\n' "$out"
		fi
		echo "ok   $dir: $(printf '%s\n' "$out" | tail -1)"
	else
		failed=$((failed + 1))
		echo "FAIL $dir"
		printf '%s\n' "$out"
	fi
done <<EOF
$selected
EOF

echo "def-test: $passed passed, $failed failed, $skipped without tests"
[ "$failed" = 0 ]
