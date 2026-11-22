#!/usr/bin/env bash
# Refresh .omp-plugin/marketplace.json from each plugin repository's latest
# release. Every source repo publishes its own marketplace.json as a release
# asset; its plugin entries are upserted here by name, so entries from other
# sources stay untouched. Prints "changed" or "unchanged" as the last line.
set -euo pipefail

# Plugin repositories whose latest release carries a marketplace.json asset.
SOURCES=(
	trozzelle/omp-antigravity-bridge
)

root="$(cd "$(dirname "$0")/.." && pwd)"
catalog="$root/.omp-plugin/marketplace.json"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

cp "$catalog" "$work/catalog.json"

for repo in "${SOURCES[@]}"; do
	url="https://github.com/${repo}/releases/latest/download/marketplace.json"
	if ! curl -fsSL --retry 3 "$url" -o "$work/source.json"; then
		echo "error: could not download $url" >&2
		exit 1
	fi
	# Only accept well-formed entries that point back at their own repository.
	if ! jq -e --arg repo "$repo" '
		(.plugins | type == "array" and length > 0) and
		all(.plugins[];
			(.name | type == "string" and test("^[A-Za-z0-9]([A-Za-z0-9.-]{0,62}[A-Za-z0-9])?$")) and
			(.version | type == "string" and length > 0) and
			.source.source == "github" and
			.source.repo == $repo and
			(.source.ref | type == "string" and length > 0))
	' "$work/source.json" >/dev/null; then
		echo "error: $url is not a valid catalog for $repo" >&2
		exit 1
	fi
	jq --slurpfile src "$work/source.json" '
		($src[0].plugins | map(.name)) as $names
		| .plugins = ((.plugins | map(select(.name as $n | ($names | index($n)) == null))) + $src[0].plugins
			| sort_by(.name))
	' "$work/catalog.json" >"$work/next.json"
	mv "$work/next.json" "$work/catalog.json"
done

if cmp -s "$work/catalog.json" "$catalog"; then
	echo "unchanged"
else
	cp "$work/catalog.json" "$catalog"
	echo "changed"
fi
