#!/bin/sh
# ES Tools Clean Paste installer: puts the latest version into Applications and opens it.
#   curl -fsSL https://github.com/iameryksadowski/estools-app-clean-paste/releases/latest/download/install.sh | sh
set -eu
URL="https://github.com/iameryksadowski/estools-app-clean-paste/releases/latest/download/CleanPaste.zip"
DEST="/Applications"
[ -w "$DEST" ] || { DEST="$HOME/Applications"; mkdir -p "$DEST"; }
TMP="$(mktemp -d)"
echo "Downloading Clean Paste..."
curl -fsSL "$URL" -o "$TMP/CleanPaste.zip"
ditto -x -k "$TMP/CleanPaste.zip" "$TMP"
osascript -e 'tell application id "com.eryksadowski.estools.cleanpaste" to quit' >/dev/null 2>&1 || true
rm -rf "$DEST/Clean Paste.app"
ditto "$TMP/Clean Paste.app" "$DEST/Clean Paste.app"
rm -rf "$TMP"
open "$DEST/Clean Paste.app"
echo "Clean Paste is in $DEST and open - look for its icon in the menu bar."
echo "Gotowe: Clean Paste jest w folderze $DEST i dziala - ikona jest w pasku menu u gory ekranu."
