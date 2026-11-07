#!/usr/bin/env bash
#
# Usage: scripts/update-formula.sh <formula> <owner/repo>
#
# Points Formula/<formula>.rb at the latest GitHub release of <owner/repo>.
# The release must publish SHA256SUMS and the assets
# <formula>-{macos,linux}-{arm64,x64}.tar.gz.
# Exits 0 without touching the file if the formula is already up to date.

set -euo pipefail

if [ "$#" -ne 2 ]; then
  echo "usage: $0 <formula> <owner/repo>" >&2
  exit 2
fi

formula=$1
repo=$2

cd "$(dirname "$0")/.."
file="Formula/$formula.rb"

if [ ! -f "$file" ]; then
  echo "error: $file not found" >&2
  exit 1
fi

# gh picks up GITHUB_TOKEN / GH_TOKEN in CI and the stored login locally.
if command -v gh >/dev/null 2>&1; then
  tag=$(gh api "repos/$repo/releases/latest" --jq .tag_name)
else
  tag=$(curl -fsSL "https://api.github.com/repos/$repo/releases/latest" |
    sed -n 's/^ *"tag_name": *"\([^"]*\)".*/\1/p')
fi

if ! printf '%s\n' "$tag" | grep -Eq '^v[0-9]+\.[0-9]+\.[0-9]+$'; then
  echo "error: unexpected latest release tag '$tag' in $repo" >&2
  exit 1
fi

new_version=${tag#v}
current_version=$(sed -n 's|.*/releases/download/v\([^/]*\)/.*|\1|p' "$file" | head -n 1)

if [ "$current_version" = "$new_version" ]; then
  echo "$formula is up to date ($current_version)"
  exit 0
fi

sums=$(curl -fsSL "https://github.com/$repo/releases/download/$tag/SHA256SUMS")

for os in macos linux; do
  for arch in arm64 x64; do
    asset="$formula-$os-$arch.tar.gz"
    if ! printf '%s\n' "$sums" | awk -v asset="$asset" '$2 == asset { found = 1 } END { exit !found }'; then
      echo "error: $asset is missing from SHA256SUMS of $tag" >&2
      exit 1
    fi
  done
done

# For every url line pointing at a release asset, switch it to the new tag and
# replace the sha256 line that follows it with that asset's checksum.
tmp=$(mktemp)
printf '%s\n' "$sums" | awk -v tag="$tag" '
  FNR == NR { sha[$2] = $1; next }
  /^ *url "/ {
    asset = $0
    sub(/^.*\//, "", asset)
    sub(/".*$/, "", asset)
    if (asset in sha) {
      sub(/\/releases\/download\/[^\/]*\//, "/releases/download/" tag "/")
    }
  }
  /^ *sha256 "/ && asset in sha {
    sub(/"[^"]*"/, "\"" sha[asset] "\"")
    asset = ""
  }
  { print }
' - "$file" >"$tmp"

for os in macos linux; do
  for arch in arm64 x64; do
    asset="$formula-$os-$arch.tar.gz"
    if ! grep -q "/releases/download/$tag/$asset\"" "$tmp"; then
      echo "error: $file has no url for $asset" >&2
      rm -f "$tmp"
      exit 1
    fi
  done
done

cat "$tmp" >"$file"
rm -f "$tmp"

echo "$formula: $current_version -> $new_version"
