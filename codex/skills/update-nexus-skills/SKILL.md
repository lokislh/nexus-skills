---
name: update-nexus-skills
description: >
  Manually check the nexus-skills GitHub repository for a newer VERSION and
  update the local skill checkout with a git fast-forward. Use when the user
  asks to update nexus-skills, upgrade nexus-skills, check for nexus-skills
  updates, or get the latest Nexus skills.
version: 1.0.0
---

# Update Nexus Skills

## Purpose

Check whether the installed `nexus-skills` checkout is behind GitHub and, if a
new version is available, update it with a safe git fast-forward.

This skill is intentionally manual. It does not install hooks, add preambles,
create background checks, or prompt automatically.

## Agent Behavior

1. Resolve this skill directory.
2. Run `bin/update-nexus-skills` from this skill directory.
3. Report the result clearly.

Expected command outputs:

- `UP_TO_DATE <version>`: tell the user they are already current.
- `UPDATED <old> <new>`: tell the user nexus-skills updated from `<old>` to `<new>`.
- `BLOCKED_BY_LOCAL_CHANGES <old> <new>`: tell the user an update exists but local changes in the skill checkout must be committed, stashed, or discarded first.
- `FAILED_FETCH <old>`: tell the user the remote version check failed.
- `FAILED_MERGE <old> <new>`: tell the user the fast-forward update failed and no hard reset was attempted.
- `NOT_GIT_CHECKOUT <path>`: tell the user the installed skills path is not a git checkout and must be recloned.

## Rules

- Never run `git reset --hard`.
- Never discard local changes.
- Never edit files as part of this skill.
- If the command updated successfully, do not run any extra setup commands; the updater already reruns `./setup --host all`.

