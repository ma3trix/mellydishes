#!/usr/bin/env bash
# Melly Dishes — move into the dotsandbox workspace and push to the private GitHub repo.
# Run once:  bash ~/Downloads/mellydishes/setup.sh
set -euo pipefail

DEST="$HOME/Developer/dotsandbox/mellydishes"
SRC="$HOME/Downloads/mellydishes"

if [ -e "$DEST" ]; then
  echo "✗ $DEST already exists. Move or rename it first."
  exit 1
fi

mkdir -p "$(dirname "$DEST")"
mv "$SRC" "$DEST"
cd "$DEST"

git init -q
git add -A
git commit -qm "Melly Dishes site — initial build

One-page static site: hero, menu with live DoorDash pricing, catering,
gallery, about, order. 16 client photos at 1080px from the Instagram grid.
Targets mellydishes.com."
git branch -M main
git remote add origin git@github.com:ma3trix/mellydishes.git
git push -u origin main

echo
echo "✓ $DEST is now mirroring github.com/ma3trix/mellydishes"
echo "  Preview:  cd \"$DEST\" && python3 -m http.server 8000"
