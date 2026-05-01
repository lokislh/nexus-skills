#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

fail() {
  printf 'FAIL: %s\n' "$*" >&2
  exit 1
}

assert_link_to_root() {
  local path="$1"
  local target
  [ -L "$path" ] || fail "expected symlink: $path"
  target="$(readlink "$path")"
  case "$target" in
    "$ROOT"/*) ;;
    *) fail "expected $path to point into $ROOT, got $target" ;;
  esac
}

assert_not_exists() {
  local path="$1"
  [ ! -e "$path" ] && [ ! -L "$path" ] || fail "expected absent: $path"
}

printf 'test: dry-run does not write\n'
HOME="$TMP/dry-home" "$ROOT/setup" --dry-run --host all >/tmp/nexus-skills-dry-run.out
assert_not_exists "$TMP/dry-home/.claude"
assert_not_exists "$TMP/dry-home/.codex"
grep -q 'ln -s' /tmp/nexus-skills-dry-run.out || fail "dry-run did not print planned symlinks"

printf 'test: setup installs claude and codex into temp HOME\n'
HOME="$TMP/home" "$ROOT/setup" --host all --quiet
assert_link_to_root "$TMP/home/.claude/commands/ingest.md"
assert_link_to_root "$TMP/home/.claude/commands/query.md"
assert_link_to_root "$TMP/home/.claude/commands/lint.md"
for name in lm-wiki-ingest lm-wiki-query lm-wiki-lint nexus-maintainer second-brain-para; do
  assert_link_to_root "$TMP/home/.codex/skills/$name"
done

printf 'test: prefixed claude install switches command names\n'
HOME="$TMP/home" "$ROOT/setup" --host claude --prefix --quiet
assert_not_exists "$TMP/home/.claude/commands/ingest.md"
assert_link_to_root "$TMP/home/.claude/commands/nexus-ingest.md"
assert_link_to_root "$TMP/home/.claude/commands/nexus-query.md"
assert_link_to_root "$TMP/home/.claude/commands/nexus-lint.md"

printf 'test: conflict protection and --force\n'
mkdir -p "$TMP/conflict-home/.claude/commands"
printf 'mine\n' > "$TMP/conflict-home/.claude/commands/ingest.md"
if HOME="$TMP/conflict-home" "$ROOT/setup" --host claude --quiet 2>/tmp/nexus-skills-conflict.err; then
  fail "setup unexpectedly replaced non-owned target without --force"
fi
grep -q 'target exists and is not owned' /tmp/nexus-skills-conflict.err || fail "conflict error was not clear"
HOME="$TMP/conflict-home" "$ROOT/setup" --host claude --force --quiet
assert_link_to_root "$TMP/conflict-home/.claude/commands/ingest.md"

printf 'test: uninstall removes only owned symlinks\n'
mkdir -p "$TMP/uninstall-home/.claude/commands" "$TMP/external"
printf 'external\n' > "$TMP/external/query.md"
ln -s "$TMP/external/query.md" "$TMP/uninstall-home/.claude/commands/query.md"
HOME="$TMP/uninstall-home" "$ROOT/setup" --host claude --force --quiet
rm "$TMP/uninstall-home/.claude/commands/query.md"
ln -s "$TMP/external/query.md" "$TMP/uninstall-home/.claude/commands/query.md"
HOME="$TMP/uninstall-home" "$ROOT/uninstall" --host claude --quiet
assert_not_exists "$TMP/uninstall-home/.claude/commands/ingest.md"
[ -L "$TMP/uninstall-home/.claude/commands/query.md" ] || fail "uninstall removed non-owned query symlink"

printf 'test: codex skill frontmatter\n'
for skill in "$ROOT"/codex/skills/*/SKILL.md; do
  grep -q '^---$' "$skill" || fail "missing frontmatter fence: $skill"
  grep -q '^name:' "$skill" || fail "missing name: $skill"
  grep -q '^description:' "$skill" || fail "missing description: $skill"
  grep -q '^version:' "$skill" || fail "missing version: $skill"
done

printf 'all installer tests passed\n'

