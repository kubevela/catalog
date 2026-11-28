#!/usr/bin/env bash
# Syncs the shared chart install into every addon that uses it.
#
# An addon uses it when it has resources/install.cue. That file is replaced with
# hack/addon-install/install.cue, and the block in its parameter.cue between the
# markers below is replaced with hack/addon-install/parameter.cue.
#
#   hack/addon-install/sync.sh            sync every addon that uses it
#   hack/addon-install/sync.sh --check    change nothing; exit 1 if any addon is out of step
#   hack/addon-install/sync.sh -v         also name the addons already in step
#
# Exit codes: 0 in step (or synced), 1 out of step under --check, 2 usage or a broken addon.
set -euo pipefail

BEGIN='	// --- shared install parameters: synced from hack/addon-install/parameter.cue, do not edit ---'
END='	// --- end shared install parameters ---'

check=0
verbose=0
for arg in "$@"; do
	case "$arg" in
	--check) check=1 ;;
	-v) verbose=1 ;;
	-h | --help)
		sed -n '2,12p' "$0" | sed 's/^# \{0,1\}//'
		exit 0
		;;
	*)
		echo "unknown argument: $arg" >&2
		exit 2
		;;
	esac
done

root=$(cd "$(dirname "$0")/../.." && pwd)
src="$root/hack/addon-install"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

synced=0
stale=0
same=0
broken=0

# render_params writes parameter.cue with the marked block replaced by the shared one.
render_params() {
	awk -v begin="$BEGIN" -v end="$END" -v shared="$src/parameter.cue" '
		$0 == begin { print; while ((getline line < shared) > 0) print line; skip = 1; found++; next }
		$0 == end { if (skip) closed++; skip = 0; print; next }
		!skip { print }
		END { if (found != 1 || closed != 1 || skip) exit 3 }
	' "$1"
}

for dir in "$root"/addons/*/ "$root"/experimental/addons/*/; do
	[ -f "$dir/resources/install.cue" ] || continue
	name=${dir%/}
	name=${name#"$root"/}

	if ! render_params "$dir/parameter.cue" >"$tmp/parameter.cue"; then
		echo "BROKEN $name: parameter.cue needs exactly one block between the shared install markers" >&2
		broken=$((broken + 1))
		continue
	fi

	changed=""
	cmp -s "$src/install.cue" "$dir/resources/install.cue" || changed="resources/install.cue"
	cmp -s "$tmp/parameter.cue" "$dir/parameter.cue" || changed="${changed:+$changed, }parameter.cue"

	if [ -z "$changed" ]; then
		same=$((same + 1))
		[ "$verbose" = 1 ] && echo "ok     $name"
		continue
	fi
	if [ "$check" = 1 ]; then
		echo "STALE  $name: $changed"
		stale=$((stale + 1))
	else
		cp "$src/install.cue" "$dir/resources/install.cue"
		cp "$tmp/parameter.cue" "$dir/parameter.cue"
		echo "synced $name: $changed"
		synced=$((synced + 1))
	fi
done

echo "addon-install: $synced synced, $stale stale, $same in step, $broken broken"
[ "$broken" = 0 ] || exit 2
[ "$stale" = 0 ] || exit 1
