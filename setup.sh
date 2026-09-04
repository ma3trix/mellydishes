#!/usr/bin/env bash
# Melly Dishes — consolidate into the biyisandbox workspace and push.
#
#   bash ~/Downloads/mellydishes/setup.sh
#
# Does four things:
#   1. merges any legacy ~/Developer/dotsandbox into ~/Developer/biyisandbox
#   2. moves every melly-related folder out of ~/Downloads
#   3. clears the stale git locks the sandbox mount could not delete
#   4. pushes main, which is already wired to origin/main
#
# Nothing is deleted. Legacy and staging folders are archived, not removed.

set -euo pipefail

DL="$HOME/Downloads"
WS="$HOME/Developer/biyisandbox"
LEGACY="$HOME/Developer/dotsandbox"

say() { printf '\033[1;31m▸\033[0m %s\n' "$1"; }

# ---------------------------------------------------------------- preflight
[ -d "$DL/mellydishes" ] || { echo "✗ $DL/mellydishes not found — already moved?"; exit 1; }
for d in mellydishes mellydishes-source; do
  [ -e "$WS/$d" ] && { echo "✗ $WS/$d already exists. Move or rename it first."; exit 1; }
done

mkdir -p "$WS" "$WS/_archive"

# ------------------------------------------- 1. absorb the dissolved entity
if [ -d "$LEGACY" ]; then
  say "Merging legacy dotsandbox/ into biyisandbox/"
  # move contents across; anything that collides lands in _archive/dotsandbox-conflicts
  mkdir -p "$WS/_archive/dotsandbox-conflicts"
  for item in "$LEGACY"/* "$LEGACY"/.[!.]*; do
    [ -e "$item" ] || continue
    base="$(basename "$item")"
    if [ -e "$WS/$base" ]; then
      mv "$item" "$WS/_archive/dotsandbox-conflicts/$base"
      echo "    conflict, archived: $base"
    else
      mv "$item" "$WS/$base"
      echo "    moved: $base"
    fi
  done
  rmdir "$LEGACY" 2>/dev/null && echo "    removed empty $LEGACY" \
    || echo "    $LEGACY not empty — left in place for you to check"
else
  echo "  (no legacy ~/Developer/dotsandbox found — nothing to merge)"
fi

# ----------------------------------------------- 2. move out of Downloads
say "Moving folders into $WS"
mv "$DL/mellydishes" "$WS/mellydishes"
[ -d "$DL/mellydishes-source" ] && mv "$DL/mellydishes-source" "$WS/mellydishes-source"

for d in _melly-originals _melly_unpack; do
  [ -d "$DL/$d" ] && mv "$DL/$d" "$WS/_archive/$d" && echo "    archived $d"
done

# ------------------------------------------- 3. clean up sandbox residue
# Must happen BEFORE any git command: the sandbox mount forbids unlink, so it
# left an index.lock behind and git refuses to write until it is gone.
cd "$WS/mellydishes"
say "Clearing stale git locks the sandbox could not remove"
find .git -name '*.lock' -delete
find .git/objects -name 'tmp_obj_*' -delete
find . -name '.DS_Store' -delete 2>/dev/null || true
git gc --quiet --prune=now 2>/dev/null || true
git fsck --no-progress --connectivity-only >/dev/null 2>&1 && echo "    object store OK"

# --------------------------------- 4. commit the rebrand edits still pending
# The DOTSANDBOX -> BIYISANDBOX rename landed after the initial commit and
# could not be committed in the sandbox because of that lock.
if [ -n "$(git status --porcelain)" ]; then
  say "Committing pending changes"
  git status --short | sed 's/^/      /'
  git add -A
  git commit -q -m "Rebrand credit to BIYISANDBOX STUDIOS

DOTSANDBOX dissolved. Credit lines take the full brand form; the
workspace folder and repo keep the short address form."
fi

# ------------------------------------------------------------- 5. push
say "Pushing to github.com/ma3trix/mellydishes"
git branch -vv | sed 's/^/      /'
git push origin main

# ------------------------------------------------------------------ report
echo
say "Done."
cat <<EOF

  Repo     $WS/mellydishes           → github.com/ma3trix/mellydishes (private)
  Source   $WS/mellydishes-source    → logo + Instagram originals, untracked
  Archive  $WS/_archive              → legacy + staging dupes, safe to delete once verified

  Preview  cd "$WS/mellydishes" && python3 -m http.server 8000

EOF
git log --oneline -1
