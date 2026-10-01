#!/bin/sh
# Release the version at the top of CHANGELOG.md: build, sign the update (EdDSA),
# write appcast.xml with the changelog and publish a GitHub release with the zip,
# the DMG, appcast.xml and install.sh. Run on main after merging development.
set -eu
cd "$(dirname "$0")/.."
REPO="iameryksadowski/estools-app-clean-paste"
[ -s Resources/sparkle-public-key.txt ] || { echo "Resources/sparkle-public-key.txt missing - run scripts/setup-signing.sh" >&2; exit 1; }
./scripts/build-app.sh
VERSION="$(sed -n 's/^## \[\([0-9][0-9.]*\)\].*/\1/p' CHANGELOG.md | head -1)"
BUILD="$(git rev-list --count HEAD)"
ZIP="dist/CleanPaste-$VERSION.zip"
BIN="$(find .build -type d -path '*artifacts/sparkle/Sparkle/bin' | head -1)"
KEY="${SPARKLE_PRIVATE_KEY_FILE:-$HOME/.config/estools/signing/sparkle-private-key.txt}"
[ -f "$KEY" ] || { echo "Update signing key not found: $KEY (1Password: ES Tools - Clean Paste signing)" >&2; exit 1; }
SIGNATURE="$("$BIN/sign_update" --ed-key-file "$KEY" "$ZIP")"
# Changelog section of this version, as HTML for the update window (cleaned by our own CLI)
NOTES="$(awk -v v="$VERSION" '$0 ~ "^## \\[" v "\\]" {on=1; next} /^## \[/ {on=0} on' CHANGELOG.md)"
NOTES_HTML="$(printf '%s\n' "$NOTES" | "dist/Clean Paste.app/Contents/Helpers/cleanpaste" --markdown --font-size 0 --keep-quotes --print html)"
cp "$ZIP" dist/CleanPaste.zip
cat > dist/appcast.xml <<XML
<?xml version="1.0" encoding="utf-8"?>
<rss version="2.0" xmlns:sparkle="http://www.andymatuschak.org/xml-namespaces/sparkle">
  <channel>
    <title>ES Tools Clean Paste</title>
    <item>
      <title>Clean Paste $VERSION</title>
      <pubDate>$(LC_ALL=C date -u "+%a, %d %b %Y %H:%M:%S +0000")</pubDate>
      <sparkle:version>$BUILD</sparkle:version>
      <sparkle:shortVersionString>$VERSION</sparkle:shortVersionString>
      <sparkle:minimumSystemVersion>14.0</sparkle:minimumSystemVersion>
      <description><![CDATA[$NOTES_HTML]]></description>
      <enclosure url="https://github.com/$REPO/releases/download/v$VERSION/CleanPaste-$VERSION.zip" $SIGNATURE type="application/octet-stream"/>
    </item>
  </channel>
</rss>
XML
cp scripts/install.sh dist/install.sh
printf '%s\n' "$NOTES" > dist/notes.md
gh release create "v$VERSION" --repo "$REPO" --target main --title "Clean Paste $VERSION" --notes-file dist/notes.md \
  "$ZIP" "dist/CleanPaste-$VERSION.dmg" dist/CleanPaste.zip dist/appcast.xml dist/install.sh
echo "Released v$VERSION"
