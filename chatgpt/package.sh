#!/usr/bin/env bash
# Builds the ZIP submitted to the ChatGPT plugin directory: the portable
# Agent Plugins layout (root plugin.json and mcp.json, with the OAuth settings
# ChatGPT reads from mcp.json) around the same skill and assets Codex and
# Claude Code install from this repository.
#
#   chatgpt/package.sh            writes dist/onbox-chatgpt-<version>.zip
#   chatgpt/package.sh <out.zip>  writes that file instead
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
version="$(node -p "require('$root/chatgpt/plugin.json').version")"
out="${1:-$root/dist/onbox-chatgpt-$version.zip}"
stage="$(mktemp -d)"
trap 'rm -rf "$stage"' EXIT

cp "$root/chatgpt/plugin.json" "$root/chatgpt/mcp.json" "$root/LICENSE" "$root/README.md" "$stage/"
cp -R "$root/skills" "$root/assets" "$stage/"

mkdir -p "$(dirname "$out")"
# zip runs inside the staging directory, so a relative path must be made absolute first.
out="$(cd "$(dirname "$out")" && pwd)/$(basename "$out")"
rm -f "$out"
(cd "$stage" && zip -qr "$out" .)
echo "$out"
