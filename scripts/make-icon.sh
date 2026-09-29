#!/bin/sh
# design/icon.svg -> Resources/AppIcon.icns (needs rsvg-convert: brew install librsvg).
set -eu
cd "$(dirname "$0")/.."
SET="$(mktemp -d)/AppIcon.iconset"
mkdir -p "$SET"
for size in 16 32 128 256 512; do
  rsvg-convert -w $size -h $size design/icon.svg -o "$SET/icon_${size}x${size}.png"
  rsvg-convert -w $((size * 2)) -h $((size * 2)) design/icon.svg -o "$SET/icon_${size}x${size}@2x.png"
done
iconutil -c icns "$SET" -o Resources/AppIcon.icns
rsvg-convert -w 1024 -h 1024 design/icon.svg -o design/icon-1024.png
echo "Resources/AppIcon.icns"
