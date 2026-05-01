# nexus-skills

`nexus-skills` packages the agent skills that maintain a Nexus-style second brain:
an Obsidian vault organized with CODE/PARA and a compiled LM wiki layer.

It is intentionally smaller than gstack. There is no runtime, no generator, and no
Node dependency in v1: just Markdown skills, Claude slash commands, and a Bash
installer that symlinks them into place.

## What It Installs

Claude Code commands:

| Command | Purpose |
| --- | --- |
| `/ingest` | Add one source note to the LM wiki. |
| `/query` | Ask cited questions against the compiled wiki. |
| `/lint` | Audit wiki health for contradictions, stale pages, orphans, and missing links. |

Codex skills:

| Skill | Purpose |
| --- | --- |
| `lm-wiki-ingest` | Native Codex equivalent of `/ingest`. |
| `lm-wiki-query` | Native Codex equivalent of `/query`. |
| `lm-wiki-lint` | Native Codex equivalent of `/lint`. |
| `nexus-maintainer` | Maintain raw-to-compiled Nexus knowledge. |
| `second-brain-para` | Route notes through CODE/PARA. |
| `grill-session` | Stress-test a plan or design one decision at a time. |

## Install

```bash
git clone https://github.com/lokislh/nexus-skills.git ~/.nexus-skills
cd ~/.nexus-skills
./setup
```

By default, setup installs both Claude and Codex targets:

- Claude commands symlink into `~/.claude/commands/`.
- Codex skills symlink into `~/.codex/skills/`.

Install only one host:

```bash
./setup --host claude
./setup --host codex
```

Use namespaced Claude commands if you already have `/ingest`, `/query`, or
`/lint` commands from another pack:

```bash
./setup --host claude --prefix
```

That installs `/nexus-ingest`, `/nexus-query`, and `/nexus-lint`. Codex skill
directory names are unchanged.

Preview without writing anything:

```bash
./setup --dry-run --host all
```

## Uninstall

```bash
./uninstall
```

If you installed prefixed Claude commands, pass the same prefix flag:

```bash
./uninstall --host claude --prefix
```

Uninstall removes only symlinks that point back into this `nexus-skills` checkout.
It will not delete copied files or commands owned by another package.

## Vault Setup

This repository installs agent skills and commands only. It does not migrate or
rewrite an Obsidian vault.

For a new vault, copy or adapt:

- `templates/wiki/SCHEMA.md`
- `templates/AGENTS.md`

The expected vault shape is:

```text
00 Inbox/
01 Projects/
02 Areas/
03 Resources/
04 Archive/
wiki/
  SCHEMA.md
  index.md
  log.md
  Synthesis/
```

## Development

The installer uses symlinks by design. When this repository is edited, installed
skills update immediately.

Run the test harness:

```bash
scripts/test-installer.sh
```

The tests use a temporary `HOME` and do not touch your real Claude or Codex
directories.
