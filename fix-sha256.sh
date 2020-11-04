#!/usr/bin/env bash
NAME=$1
SOURCE_FILE="sources/sources.json"

REAL_SHA256=$(nix-prefetch-git --rev "$(jq ".[\"$NAME\"].rev" $SOURCE_FILE)" --url "https://github.com/$(jq ".[\"$NAME\"].owner" $SOURCE_FILE)/$(jq ".[\"$NAME\"].repo" $SOURCE_FILE).git" --fetch-submodules | jq '.sha256')

echo "$(jq ".[\"$NAME\"].sha256 = $REAL_SHA256" $SOURCE_FILE)" > $SOURCE_FILE
