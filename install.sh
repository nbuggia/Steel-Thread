#!/bin/sh
# Install or update the Hashbang Agent Framework in a project.
#
#   path/to/hashbang/install.sh [project-dir]
#
# Safe to re-run. Framework files (the manual, templates, and skills) are
# updated. If you edited one since it was installed, you are asked before it
# is overwritten. Only .hashbang/framework/ and the skill folders are
# written; your project state elsewhere in .hashbang/ is never touched.

set -eu

# Everything under project/ is what gets installed into your project.
SRC=$(cd "$(dirname "$0")/project" && pwd)
DEST=$(cd "${1:-.}" && pwd)

if [ "$DEST" = "$SRC" ]; then
  echo "Refusing to install into Hashbang's own project/ folder." >&2
  exit 1
fi

BEGIN='<!-- hashbang:start -->'
END='<!-- hashbang:end -->'
LEGACY_BEGIN='<!-- steel-thread:start -->'
LEGACY_END='<!-- steel-thread:end -->'

# Skill folders read by each supported agent.
SKILL_DIRS=".claude/skills .agents/skills .kiro/skills"

# Fingerprints of what was last installed, used to tell local edits
# apart from files that are simply out of date.
migrated_legacy=false
if [ -e "$DEST/.steel-thread" ] && [ -e "$DEST/.hashbang" ]; then
  echo "Cannot migrate .steel-thread because .hashbang already exists." >&2
  echo "Merge or remove one of those folders, then run the installer again." >&2
  exit 1
elif [ -e "$DEST/.steel-thread" ]; then
  mv "$DEST/.steel-thread" "$DEST/.hashbang"
  migrated_legacy=true
  echo "  migrated .steel-thread to .hashbang"
fi

MANIFEST="$DEST/.hashbang/framework/install-manifest"
if [ "$migrated_legacy" = true ] && [ -f "$MANIFEST" ]; then
  tmp=$(mktemp)
  awk -F '\t' 'BEGIN { OFS = FS } { sub(/^\.steel-thread\//, ".hashbang/", $1); print }' \
    "$MANIFEST" > "$tmp"
  mv "$tmp" "$MANIFEST"
fi

# Fingerprint a file or folder: names and contents of every file in it.
fingerprint() {
  if [ -d "$1" ]; then
    (cd "$1" && find . -type f ! -name .DS_Store | LC_ALL=C sort | while IFS= read -r f; do
      printf '%s\n' "$f"; cat "$f"
    done) | cksum
  else
    cksum < "$1"
  fi
}

recorded() {
  [ -f "$MANIFEST" ] && awk -F '\t' -v k="$1" '$1 == k { print $2 }' "$MANIFEST"
  return 0
}

record() {
  tmp=$(mktemp)
  { [ -f "$MANIFEST" ] && awk -F '\t' -v k="$1" '$1 != k' "$MANIFEST"
    printf '%s\t%s\n' "$1" "$2"; } > "$tmp"
  mv "$tmp" "$MANIFEST"
}

unrecord() {
  [ -f "$MANIFEST" ] || return 0
  tmp=$(mktemp)
  awk -F '\t' -v k="$1" '$1 != k' "$MANIFEST" > "$tmp"
  mv "$tmp" "$MANIFEST"
}

# Ask a yes/no question on the terminal. No terminal means no.
confirm() {
  if [ -t 0 ]; then
    printf '%s [y/N] ' "$1"; read -r answer || answer=
  elif { : < /dev/tty; } 2>/dev/null; then
    printf '%s [y/N] ' "$1" > /dev/tty; read -r answer < /dev/tty || answer=
  else
    answer=
  fi
  case "$answer" in y|Y|yes|YES) return 0 ;; *) return 1 ;; esac
}

# Install one framework file or folder, asking before replacing local edits.
install_item() {
  src=$1 rel=$2 dest="$DEST/$2"
  new=$(fingerprint "$src")
  if [ -e "$dest" ]; then
    cur=$(fingerprint "$dest")
    if [ "$cur" = "$new" ]; then
      record "$rel" "$new"; return
    fi
    if [ "$cur" != "$(recorded "$rel")" ]; then
      if ! confirm "$rel has local changes. Overwrite with the Hashbang version?"; then
        echo "  kept $rel"; return
      fi
    fi
    rm -rf "$dest"
  fi
  mkdir -p "$(dirname "$dest")"
  cp -R "$src" "$dest"
  record "$rel" "$new"
  echo "  installed $rel"
}

echo "Installing Hashbang into $DEST"

# Remove the retired manual after a legacy install is migrated.
if [ "$migrated_legacy" = true ]; then
  legacy_manual=.hashbang/framework/steel-thread.md
  if [ -e "$DEST/$legacy_manual" ]; then
    if [ "$(fingerprint "$DEST/$legacy_manual")" != "$(recorded "$legacy_manual")" ] &&
       ! confirm "$legacy_manual has local changes. Delete the retired file?"; then
      echo "  kept $legacy_manual"
    else
      rm -f "$DEST/$legacy_manual"
      echo "  removed $legacy_manual"
    fi
    unrecord "$legacy_manual"
  fi
fi

# 1. Framework files
mkdir -p "$DEST/.hashbang/framework" "$DEST/.hashbang/history" \
  "$DEST/.hashbang/examples/good" "$DEST/.hashbang/examples/bad"
install_item "$SRC/.hashbang/framework/hashbang.md" .hashbang/framework/hashbang.md
install_item "$SRC/.hashbang/framework/files.md" .hashbang/framework/files.md
install_item "$SRC/.hashbang/framework/templates" .hashbang/framework/templates

# 2. Skills, one identical copy per agent
for dir in $SKILL_DIRS; do
  for skill in "$SRC"/skills/foundational/*/; do
    install_item "${skill%/}" "$dir/$(basename "$skill")"
  done
done

# 2b. Remove skills that Hashbang no longer ships, asking first if edited
if [ -f "$MANIFEST" ]; then
  for dir in $SKILL_DIRS; do
    for rel in $(awk -F '\t' -v d="$dir/" 'index($1, d) == 1 { print $1 }' "$MANIFEST"); do
      name=${rel#"$dir/"}
      [ -d "$SRC/skills/foundational/$name" ] && continue
      if [ -e "$DEST/$rel" ]; then
        if [ "$(fingerprint "$DEST/$rel")" != "$(recorded "$rel")" ] &&
           ! confirm "$rel is no longer part of Hashbang but has local changes. Delete it?"; then
          echo "  kept $rel"; unrecord "$rel"; continue
        fi
        rm -rf "$DEST/$rel"
        echo "  removed $rel"
      fi
      unrecord "$rel"
    done
  done
fi

# 3. AGENTS.md — the entry point every agent reads. The Hashbang block
#    from project/AGENTS.md is added or replaced; the rest is left alone.
BLOCK=$(cat "$SRC/AGENTS.md")

AGENTS="$DEST/AGENTS.md"

# How the markers appear in AGENTS.md: "none", "ok" (one start line followed
# by one end line), or "broken" (anything else, e.g. an end line lost in a
# merge). A broken block is never rewritten — that could delete the user's
# own content after the start marker.
markers() {
  marker_begin=$2 marker_end=$3
  BEGIN="$marker_begin" END="$marker_end" awk '
    $0 == ENVIRON["BEGIN"] { b++; if (e) bad = 1 }
    $0 == ENVIRON["END"]   { e++; if (!b) bad = 1 }
    END {
      if (!b && !e) print "none"
      else if (b == 1 && e == 1 && !bad) print "ok"
      else print "broken"
    }' "$1"
}

if [ ! -f "$AGENTS" ]; then
  printf '%s\n' "$BLOCK" > "$AGENTS"
else
  marker_state=$(markers "$AGENTS" "$BEGIN" "$END")
  legacy_marker_state=$(markers "$AGENTS" "$LEGACY_BEGIN" "$LEGACY_END")
  if [ "$marker_state" != none ] && [ "$legacy_marker_state" != none ]; then
    echo "  skipped AGENTS.md: it contains both Hashbang and legacy Steel Thread sections." >&2
    echo "  Remove one section by hand, then run the installer again." >&2
  elif [ "$marker_state" = broken ]; then
    echo "  skipped AGENTS.md: its Hashbang section is damaged." >&2
    echo "  It needs exactly one '$BEGIN' line followed by one '$END' line." >&2
    echo "  Fix or remove the markers by hand, then run the installer again." >&2
  elif [ "$legacy_marker_state" = broken ]; then
    echo "  skipped AGENTS.md: its legacy Steel Thread section is damaged." >&2
    echo "  It needs exactly one '$LEGACY_BEGIN' line followed by one '$LEGACY_END' line." >&2
    echo "  Fix or remove the markers by hand, then run the installer again." >&2
  elif [ "$marker_state" = ok ]; then
    tmp=$(mktemp)
    BEGIN="$BEGIN" END="$END" BLOCK="$BLOCK" awk '
      $0 == ENVIRON["BEGIN"] { print ENVIRON["BLOCK"]; skip = 1; next }
      $0 == ENVIRON["END"]   { skip = 0; next }
      !skip                  { print }
    ' "$AGENTS" > "$tmp"
    mv "$tmp" "$AGENTS"
  elif [ "$legacy_marker_state" = ok ]; then
    tmp=$(mktemp)
    BEGIN="$LEGACY_BEGIN" END="$LEGACY_END" BLOCK="$BLOCK" awk '
      $0 == ENVIRON["BEGIN"] { print ENVIRON["BLOCK"]; skip = 1; next }
      $0 == ENVIRON["END"]   { skip = 0; next }
      !skip                  { print }
    ' "$AGENTS" > "$tmp"
    mv "$tmp" "$AGENTS"
  else
    printf '\n%s\n' "$BLOCK" >> "$AGENTS"
  fi
fi

# 4. CLAUDE.md — Claude Code reads CLAUDE.md, not AGENTS.md, so the import
#    line from project/CLAUDE.md goes at the top to pull AGENTS.md in.
IMPORT=$(cat "$SRC/CLAUDE.md")
CLAUDE="$DEST/CLAUDE.md"
if [ ! -f "$CLAUDE" ]; then
  printf '%s\n' "$IMPORT" > "$CLAUDE"
elif ! grep -qxF "$IMPORT" "$CLAUDE"; then
  tmp=$(mktemp)
  { printf '%s\n\n' "$IMPORT"; cat "$CLAUDE"; } > "$tmp"
  mv "$tmp" "$CLAUDE"
fi

echo "Done. Start your agent and ask what's next:"
echo "  Claude Code: /hb-whats-next    Codex CLI: \$hb-whats-next    Kiro CLI: /hb-whats-next"
