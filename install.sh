#!/bin/sh
# Install or update the Hashbang Agent Framework in a project.
#
#   path/to/hashbang/install.sh [--agent claude|codex|kiro] [project-dir]
#
# Safe to re-run. Hashbang installs for one agent per project; without
# --agent it uses the one recorded at the last install, or detects it, or
# asks. On update, files you haven't changed are updated. Files you have
# customized are never overwritten: the new Hashbang version is saved in
# .hashbang/upstream/incoming/ for the hb-update skill to merge in. Your
# project state in docs/ and elsewhere in .hashbang/ is never touched.

set -eu

usage() {
  echo "Usage: install.sh [--agent claude|codex|kiro] [project-dir]" >&2
  exit 1
}

AGENT=
DEST_ARG=.
while [ $# -gt 0 ]; do
  case "$1" in
    --agent) [ $# -ge 2 ] || usage; AGENT=$2; shift 2 ;;
    --agent=*) AGENT=${1#--agent=}; shift ;;
    -*) usage ;;
    *) DEST_ARG=$1; shift ;;
  esac
done

# Everything under project/ is what gets installed into your project.
ROOT=$(cd "$(dirname "$0")" && pwd)
SRC="$ROOT/project"
DEST=$(cd "$DEST_ARG" && pwd)
VERSION=$(cat "$SRC/VERSION")

if [ "$DEST" = "$SRC" ]; then
  echo "Refusing to install into Hashbang's own project/ folder." >&2
  exit 1
fi

BEGIN='<!-- hashbang:start -->'
END='<!-- hashbang:end -->'
LEGACY_BEGIN='<!-- steel-thread:start -->'
LEGACY_END='<!-- steel-thread:end -->'

# The skills folder each supported agent reads.
skills_dir_for() {
  case "$1" in
    claude) echo .claude/skills ;;
    codex) echo .agents/skills ;;
    kiro) echo .kiro/skills ;;
    *) return 1 ;;
  esac
}

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

# The pristine Hashbang files each local file is based on. A local file
# that matches its base has not been customized and is safe to update.
UP="$DEST/.hashbang/upstream"
INSTALLED="$UP/installed"
INCOMING="$UP/incoming"

# Older installs kept fingerprints here instead, and copied the
# skills into every agent's folder.
MANIFEST="$DEST/.hashbang/framework/install-manifest"
if [ "$migrated_legacy" = true ] && [ -f "$MANIFEST" ]; then
  tmp=$(mktemp)
  awk -F '\t' 'BEGIN { OFS = FS } { sub(/^\.steel-thread\//, ".hashbang/", $1); print }' \
    "$MANIFEST" > "$tmp"
  mv "$tmp" "$MANIFEST"
fi

# Fingerprint a file or folder the way the old manifest did.
fingerprint() {
  if [ -d "$1" ]; then
    (cd "$1" && find . -type f ! -name .DS_Store | LC_ALL=C sort | while IFS= read -r f; do
      printf '%s\n' "$f"; cat "$f"
    done) | cksum
  else
    cksum < "$1"
  fi
}

# Ask a question on the terminal and print the answer. No terminal, no answer.
ask() {
  answer=
  if [ -t 0 ]; then
    printf '%s ' "$1" >&2; read -r answer || answer=
  elif { : < /dev/tty; } 2>/dev/null; then
    printf '%s ' "$1" > /dev/tty; read -r answer < /dev/tty || answer=
  fi
  printf '%s' "$answer"
}

same() { cmp -s "$1" "$2"; }

echo "Installing Hashbang $VERSION into $DEST"

# 0. Choose the agent: --agent, else the one recorded, else detect, else ask.
saved_agent=
[ -f "$UP/agent" ] && saved_agent=$(cat "$UP/agent")
if [ -z "$AGENT" ]; then
  AGENT=$saved_agent
fi
if [ -z "$AGENT" ]; then
  found=
  if [ -e "$DEST/.claude" ] || [ -e "$DEST/CLAUDE.md" ]; then found="$found claude"; fi
  if [ -e "$DEST/.codex" ] || [ -e "$DEST/.agents" ]; then found="$found codex"; fi
  if [ -e "$DEST/.kiro" ]; then found="$found kiro"; fi
  set -- $found
  if [ $# -eq 1 ]; then
    AGENT=$1
    echo "  detected $AGENT"
  else
    AGENT=$(ask "Which agent will you use in this project? [claude/codex/kiro]")
  fi
fi
if ! SKILLS_DIR=$(skills_dir_for "$AGENT"); then
  if [ -z "$AGENT" ]; then
    echo "Could not tell which agent this project uses. Run again with --agent claude, codex, or kiro." >&2
  else
    echo "Unknown agent '$AGENT'. Use claude, codex, or kiro." >&2
  fi
  exit 1
fi

# Switching agents moves the installed skills to the new agent's folder.
if [ -n "$saved_agent" ] && [ "$saved_agent" != "$AGENT" ]; then
  old_dir=$(skills_dir_for "$saved_agent")
  mkdir -p "$DEST/$SKILLS_DIR"
  for dir in "$DEST/$old_dir"/hb-*; do
    [ -d "$dir" ] || continue
    name=$(basename "$dir")
    if [ -e "$DEST/$SKILLS_DIR/$name" ]; then
      echo "  kept $old_dir/$name: $SKILLS_DIR/$name already exists"
    else
      mv "$dir" "$DEST/$SKILLS_DIR/$name"
      echo "  moved $old_dir/$name to $SKILLS_DIR/$name"
    fi
  done
  rmdir "$DEST/$old_dir" "$(dirname "$DEST/$old_dir")" 2>/dev/null || true
fi

# Where a file from project/ lands in the user's project.
dest_of() {
  case "$1" in
    skills/*) printf '%s/%s' "$SKILLS_DIR" "${1#skills/}" ;;
    *) printf '%s' "$1" ;;
  esac
}

# 1. Turn an old fingerprint manifest into base files. An item that still
#    matches its fingerprint was never customized, so it is its own base.
#    Copies in other agents' folders are removed unless they were edited.
if [ -f "$MANIFEST" ] && [ ! -d "$INSTALLED" ]; then
  mkdir -p "$INSTALLED"
  awk -F '\t' '{ print $1 "\t" $2 }' "$MANIFEST" | while IFS="$(printf '\t')" read -r rel sum; do
    clean=false
    if [ -e "$DEST/$rel" ] && [ "$(fingerprint "$DEST/$rel")" = "$sum" ]; then clean=true; fi
    case "$rel" in
      .hashbang/framework/*) base=$rel ;;
      "$SKILLS_DIR"/*) base="skills/${rel#"$SKILLS_DIR"/}" ;;
      .claude/skills/*|.agents/skills/*|.kiro/skills/*)
        if [ "$clean" = true ]; then
          rm -rf "$DEST/$rel"
          echo "  removed $rel: Hashbang now installs for one agent, $AGENT"
        elif [ -e "$DEST/$rel" ]; then
          echo "  kept $rel: it has local changes. Delete it once you no longer need it."
        fi
        continue ;;
      *) continue ;;
    esac
    if [ "$clean" = true ]; then
      mkdir -p "$(dirname "$INSTALLED/$base")"
      cp -R "$DEST/$rel" "$INSTALLED/$base"
    fi
  done
  for dir in .claude .agents .kiro; do
    rmdir "$DEST/$dir/skills" "$DEST/$dir" 2>/dev/null || true
  done
  rm -f "$MANIFEST"
fi

# Remove the retired manual after a legacy install is migrated.
if [ "$migrated_legacy" = true ]; then
  legacy_manual=.hashbang/framework/steel-thread.md
  if [ -e "$DEST/$legacy_manual" ]; then
    rm -f "$DEST/$legacy_manual"
    echo "  removed $legacy_manual"
  fi
fi

mkdir -p "$INSTALLED"

# 2. Framework files and skills, one file at a time.
PENDING=$(mktemp)
LIST=$(mktemp)
trap 'rm -f "$PENDING" "$LIST"' EXIT

flag() { printf '%s\t%s\t%s\n' "$1" "$2" "$3" >> "$PENDING"; }

set_base() {
  mkdir -p "$(dirname "$INSTALLED/$1")"
  cp -p "$SRC/$1" "$INSTALLED/$1"
}

(cd "$SRC" && find .hashbang/framework skills -type f ! -name .DS_Store \
  ! -path '*/__pycache__/*' | LC_ALL=C sort) > "$LIST"

while IFS= read -r s; do
  d=$(dest_of "$s")
  src="$SRC/$s" dst="$DEST/$d" base="$INSTALLED/$s"
  if [ ! -e "$dst" ]; then
    if [ -e "$base" ]; then
      # Deleted on purpose. Only worth a look if Hashbang changed it since.
      same "$src" "$base" || flag deleted "$s" "$d"
    else
      mkdir -p "$(dirname "$dst")"
      cp -p "$src" "$dst"
      set_base "$s"
      echo "  installed $d"
    fi
  elif same "$dst" "$src"; then
    set_base "$s"
  elif [ -e "$base" ] && same "$dst" "$base"; then
    cp -p "$src" "$dst"
    set_base "$s"
    echo "  updated $d"
  elif [ -e "$base" ] && same "$src" "$base"; then
    : # Customized, and Hashbang's version hasn't changed. Nothing to do.
  else
    flag modified "$s" "$d"
  fi
done < "$LIST"

# Files Hashbang no longer ships: delete them unless they were customized.
(cd "$INSTALLED" && find . -type f | sed 's|^\./||' | LC_ALL=C sort) > "$LIST"
while IFS= read -r s; do
  [ -e "$SRC/$s" ] && continue
  d=$(dest_of "$s")
  if [ ! -e "$DEST/$d" ] || same "$DEST/$d" "$INSTALLED/$s"; then
    rm -f "$DEST/$d" "$INSTALLED/$s"
    echo "  removed $d"
  else
    flag removed "$s" "$d"
  fi
done < "$LIST"
for dir in "$DEST/.hashbang/framework" "$DEST/$SKILLS_DIR" "$INSTALLED"; do
  [ -d "$dir" ] && find "$dir" -mindepth 1 -depth -type d -empty -delete
done

# 3. Hand customized files to hb-update: the new version of each, and a
#    list of what needs merging. Their base stays in installed/ until then.
from=$(cat "$UP/version" 2>/dev/null || echo unknown)
if [ -f "$INCOMING/PENDING" ]; then
  from=$(awk -F '\t' '$1 == "from" { print $2 }' "$INCOMING/PENDING")
fi
rm -rf "$INCOMING"
if [ -s "$PENDING" ]; then
  while IFS="$(printf '\t')" read -r kind s d; do
    if [ -e "$SRC/$s" ]; then
      mkdir -p "$(dirname "$INCOMING/$s")"
      cp -p "$SRC/$s" "$INCOMING/$s"
    fi
  done < "$PENDING"
  { printf 'from\t%s\nto\t%s\n' "$from" "$VERSION"; cat "$PENDING"; } > "$INCOMING/PENDING"
fi
printf '%s\n' "$VERSION" > "$UP/version"
printf '%s\n' "$AGENT" > "$UP/agent"

# 4. AGENTS.md — the entry point every agent reads. The Hashbang block
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

# 5. .ignore — ripgrep-based search tools skip what it lists, and git
#    ignores the file itself. Planning docs stay committed but out of
#    agents' searches; the rule in AGENTS.md covers agents that don't use it.
IGNORE="$DEST/.ignore"
WORK_LINE=docs/work/
if [ ! -f "$IGNORE" ]; then
  printf '%s\n' "$WORK_LINE" > "$IGNORE"
  echo "  installed .ignore"
elif ! grep -qxF "$WORK_LINE" "$IGNORE"; then
  if [ -s "$IGNORE" ] && [ -n "$(tail -c 1 "$IGNORE")" ]; then printf '\n' >> "$IGNORE"; fi
  printf '%s\n' "$WORK_LINE" >> "$IGNORE"
  echo "  added $WORK_LINE to .ignore"
fi

# 6. CLAUDE.md — Claude Code reads CLAUDE.md, not AGENTS.md, so the import
#    line from project/CLAUDE.md goes at the top to pull AGENTS.md in.
if [ "$AGENT" = claude ]; then
  IMPORT=$(cat "$SRC/CLAUDE.md")
  CLAUDE="$DEST/CLAUDE.md"
  if [ ! -f "$CLAUDE" ]; then
    printf '%s\n' "$IMPORT" > "$CLAUDE"
  elif ! grep -qxF "$IMPORT" "$CLAUDE"; then
    tmp=$(mktemp)
    { printf '%s\n\n' "$IMPORT"; cat "$CLAUDE"; } > "$tmp"
    mv "$tmp" "$CLAUDE"
  fi
fi

case "$AGENT" in
  codex) run='$hb-' ;;
  *) run='/hb-' ;;
esac
if [ -f "$INCOMING/PENDING" ]; then
  n=$(awk -F '\t' 'NR > 2' "$INCOMING/PENDING" | wc -l | tr -d ' ')
  echo "Done. $n customized file(s) need the new version merged in."
  echo "  Start your agent and run ${run}update."
else
  echo "Done. Start your agent and ask what's next: ${run}whats-next"
fi
