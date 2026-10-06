#!/bin/sh
# Install or update Steel Thread in a project.
#
#   path/to/steel-thread/install.sh [project-dir]
#
# Safe to re-run. Framework files (the manual, templates, and skills) are
# updated. If you edited one since it was installed, you are asked before it
# is overwritten. Only .steel-thread/framework/ and the skill folders are
# written; your project state elsewhere in .steel-thread/ is never touched.

set -eu

# Everything under project/ is what gets installed into your project.
SRC=$(cd "$(dirname "$0")/project" && pwd)
DEST=$(cd "${1:-.}" && pwd)

if [ "$DEST" = "$SRC" ]; then
  echo "Refusing to install into Steel Thread's own project/ folder." >&2
  exit 1
fi

BEGIN='<!-- steel-thread:start -->'
END='<!-- steel-thread:end -->'

# Skill folders read by each supported agent.
SKILL_DIRS=".claude/skills .agents/skills .kiro/skills"

# Fingerprints of what was last installed, used to tell local edits
# apart from files that are simply out of date.
MANIFEST="$DEST/.steel-thread/framework/install-manifest"

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
      if ! confirm "$rel has local changes. Overwrite with the Steel Thread version?"; then
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

echo "Installing Steel Thread into $DEST"

# 1. Framework files
mkdir -p "$DEST/.steel-thread/framework" "$DEST/.steel-thread/history" \
  "$DEST/.steel-thread/examples/good" "$DEST/.steel-thread/examples/bad"
install_item "$SRC/.steel-thread/framework/steel-thread.md" .steel-thread/framework/steel-thread.md
install_item "$SRC/.steel-thread/framework/templates" .steel-thread/framework/templates

# 2. Skills, one identical copy per agent
for dir in $SKILL_DIRS; do
  for skill in "$SRC"/skills/foundational/*/; do
    install_item "${skill%/}" "$dir/$(basename "$skill")"
  done
done

# 3. AGENTS.md — the entry point every agent reads. The Steel Thread block
#    from project/AGENTS.md is added or replaced; the rest is left alone.
BLOCK=$(cat "$SRC/AGENTS.md")

AGENTS="$DEST/AGENTS.md"
if [ ! -f "$AGENTS" ]; then
  printf '%s\n' "$BLOCK" > "$AGENTS"
elif grep -qF "$BEGIN" "$AGENTS"; then
  tmp=$(mktemp)
  BEGIN="$BEGIN" END="$END" BLOCK="$BLOCK" awk '
    $0 == ENVIRON["BEGIN"] { print ENVIRON["BLOCK"]; skip = 1; next }
    $0 == ENVIRON["END"]   { skip = 0; next }
    !skip                  { print }
  ' "$AGENTS" > "$tmp"
  mv "$tmp" "$AGENTS"
else
  printf '\n%s\n' "$BLOCK" >> "$AGENTS"
fi

# 4. CLAUDE.md — Claude Code skips AGENTS.md when CLAUDE.md exists, so the
#    import line from project/CLAUDE.md goes at the top.
IMPORT=$(cat "$SRC/CLAUDE.md")
CLAUDE="$DEST/CLAUDE.md"
if [ ! -f "$CLAUDE" ]; then
  printf '%s\n' "$IMPORT" > "$CLAUDE"
elif ! grep -qxF "$IMPORT" "$CLAUDE"; then
  tmp=$(mktemp)
  { printf '%s\n\n' "$IMPORT"; cat "$CLAUDE"; } > "$tmp"
  mv "$tmp" "$CLAUDE"
fi

echo "Done. Start your agent and run the onboard skill:"
echo "  Claude Code: /onboard    Codex CLI: \$onboard    Kiro CLI: /onboard"
