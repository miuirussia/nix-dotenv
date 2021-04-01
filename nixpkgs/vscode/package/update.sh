#!/usr/bin/env bash

cd "$(pwd)/$(dirname ${BASH_SOURCE})"
version=$(curl "https://api.github.com/repos/VSCodium/vscodium/tags" | jq -r ".[0].name")
if [ -z "$version" ]
then
  echo "version fetch failed"
  exit 1
fi

url="https://github.com/VSCodium/vscodium/releases/download/$version/VSCodium-darwin-x64-$version.zip"
sha256=$(nix-prefetch-url $url)

echo -n $version | tee version
echo "{}" \
  | jq ".url=\"$url\" | .sha256=\"$sha256\" | .name=\"VSCodium.zip\"" \
  | tee source.json
