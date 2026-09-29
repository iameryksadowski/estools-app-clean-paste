#!/bin/sh
# One-time setup on the release Mac (run it yourself, it changes your keychain):
# 1. "ES Tools Code Signing" - a free self-signed certificate. A stable signature keeps
#    the Accessibility permission across updates.
# 2. Sparkle EdDSA key - installed apps accept only updates signed with it.
# Backups land in ~/.config/estools/signing; move them to 1Password right after.
set -eu
cd "$(dirname "$0")/.."
OUT="$HOME/.config/estools/signing"
mkdir -p "$OUT" && chmod 700 "$HOME/.config/estools" "$OUT"

if security find-certificate -c "ES Tools Code Signing" >/dev/null 2>&1; then
  echo "Certificate: already in the keychain"
else
  PASS="$(openssl rand -hex 16)"
  /usr/bin/openssl req -x509 -newkey rsa:2048 -nodes -days 3650 \
    -keyout "$OUT/es-tools-code-signing.key" -out "$OUT/es-tools-code-signing.crt" \
    -subj "/CN=ES Tools Code Signing/O=Eryk Sadowski" \
    -addext "basicConstraints=critical,CA:false" -addext "keyUsage=critical,digitalSignature" \
    -addext "extendedKeyUsage=critical,codeSigning" 2>/dev/null
  /usr/bin/openssl pkcs12 -export -name "ES Tools Code Signing" -inkey "$OUT/es-tools-code-signing.key" \
    -in "$OUT/es-tools-code-signing.crt" -out "$OUT/es-tools-code-signing.p12" -passout "pass:$PASS"
  printf '%s\n' "$PASS" > "$OUT/es-tools-code-signing.p12-password.txt"
  rm -f "$OUT/es-tools-code-signing.key"
  chmod 600 "$OUT"/*
  security import "$OUT/es-tools-code-signing.p12" -k "$HOME/Library/Keychains/login.keychain-db" -P "$PASS" -T /usr/bin/codesign
  echo "Certificate: imported"
fi

swift package resolve >/dev/null 2>&1 || true
BIN="$(find .build -type d -path '*artifacts/sparkle/Sparkle/bin' | head -1)"
[ -n "$BIN" ] || { echo "Sparkle tools not found - run swift build first" >&2; exit 1; }
"$BIN/generate_keys" --account estools-clean-paste | sed -n 's/.*<string>\(.*\)<\/string>.*/\1/p' | head -1 > Resources/sparkle-public-key.txt
[ -s Resources/sparkle-public-key.txt ] || "$BIN/generate_keys" --account estools-clean-paste -p > Resources/sparkle-public-key.txt
[ -f "$OUT/sparkle-private-key.txt" ] || { "$BIN/generate_keys" --account estools-clean-paste -x "$OUT/sparkle-private-key.txt"; chmod 600 "$OUT/sparkle-private-key.txt"; }
echo "Sparkle public key: $(cat Resources/sparkle-public-key.txt) (Resources/sparkle-public-key.txt, commit it)"
echo
echo "Now add to 1Password (item \"ES Tools - Clean Paste signing\") and delete the local copies:"
ls -1 "$OUT"
