#!/bin/sh
# Bundles the converter shared with the Raycast extension (src/lib/convert.ts in
# estools-plugin-raycast-clean-paste) into Resources/convert.js for JavaScriptCore.
set -eu
cd "$(dirname "$0")/.."
SRC="${CLEAN_PASTE_EXTENSION:-../estools-plugin-raycast-clean-paste}"
ESBUILD="$SRC/node_modules/.bin/esbuild"
[ -x "$ESBUILD" ] || { echo "Run npm install in $SRC first" >&2; exit 1; }
REV="$(git -C "$SRC" rev-parse --short HEAD)"
TMP="$(mktemp -d)"
cat > "$TMP/entry.ts" <<TS
import { cleanContent, cleanMarkdown, markdownBody, DEFAULT_OPTIONS } from "$(cd "$SRC" && pwd)/src/lib/convert.ts";
(globalThis as unknown as { CleanPaste: unknown }).CleanPaste = { cleanContent, cleanMarkdown, markdownBody, DEFAULT_OPTIONS };
TS
"$ESBUILD" "$TMP/entry.ts" --bundle --format=iife --platform=browser --target=safari17 \
  --charset=utf8 --legal-comments=none --log-level=warning \
  --banner:js="/* ES Tools Clean Paste converter - generated from estools-plugin-raycast-clean-paste@$REV src/lib/convert.ts by scripts/build-converter.sh. Do not edit. */" \
  --outfile=Resources/convert.js
rm -rf "$TMP"
echo "Resources/convert.js from estools-plugin-raycast-clean-paste@$REV ($(wc -c < Resources/convert.js | tr -d ' ') bytes)"
