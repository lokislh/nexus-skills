# nexus-skills Agent Rules

## Versioning

- Every committed repository change must increment `VERSION` by one patch level.
- Example: `0.1.0` becomes `0.1.1`.
- Do not batch multiple committed changes under the same version.

## Skill Changes

- When adding or removing a Codex skill, update `README.md` and `scripts/test-installer.sh`.
- Keep skills as explicit checked-in files. Do not add a generator or template system unless the user explicitly asks for it.

## Update Policy

- Keep updates manual and simple.
- Do not add hooks, background checks, startup preambles, telemetry, or automatic update prompts.
- The `update-nexus-skills` skill is the only supported update path.

