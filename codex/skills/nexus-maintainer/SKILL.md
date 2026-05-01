---
name: nexus-maintainer
description: >
  Use this skill to maintain the Nexus second brain knowledge base. Trigger
  whenever the user wants to: process raw notes into compiled documents; update
  existing knowledge pages with new information; run a wiki audit for contradictions,
  orphan pages, or stale claims; ingest a new source (meeting notes, article, draft);
  propagate a change from raw into compiled knowledge; or check what raw notes are
  unprocessed. Also trigger on phrases like "process my notes", "update the wiki",
  "what's unprocessed", "run a maintenance pass", or "compile my raw notes".
version: 1.0.0
---

# Nexus Maintainer

## Purpose

Maintain the Nexus knowledge base by processing raw notes (compartment `/05 Raw`) into
compiled knowledge documents (compartments `/01 Projects`, `/02 Areas`, `/03 Resources`),
keeping compiled pages accurate and linked, and running periodic audits.

The human chooses sources. The agent does the bookkeeping.

---

## Knowledge Architecture

```
/05 Raw/              ← immutable inputs; agent reads, never rewrites content
/01 Projects/         ← compiled project knowledge; agent updates
/02 Areas/            ← compiled area knowledge; agent updates
/03 Resources/        ← compiled reference knowledge; agent updates
/04 Archive/          ← inactive material; agent moves, never modifies
log.md                ← append-only operation log (root of Nexus)
```

---

## Agent Behavior

### Operation: Ingest

Triggered when the user adds a raw note or asks to process `/05 Raw`.

1. Read all files in `/05 Raw` with `status: raw`
2. For each raw note:
   - Identify which compiled document(s) it affects
   - Determine the operation: **extend**, **correct**, **contradict**, or **new page**
   - Apply the change to the compiled document
   - Add a back-link in the compiled doc: `Source: [[/05 Raw/...]]`
   - Update the raw note frontmatter: `status: compiled`, `compiled-into: <path>`
3. Append an entry to `log.md`

Never rewrite or delete raw note content. Only update its frontmatter.

### Operation: Update a compiled page

When new information affects an existing claim:

- **Extend**: add to the relevant section; note the source
- **Correct**: update the claim; mark the old version with `> ~~old claim~~ — superseded YYYY-MM-DD`
- **Contradict**: do not silently overwrite; add a `> ⚠ Contradiction:` block and flag for user resolution

### Operation: Audit

Run periodically or on user request.

Check for:
1. **Unprocessed raw notes** — files with `status: raw` in `/05 Raw`
2. **Orphan pages** — compiled pages with no incoming links
3. **Missing pages** — concepts referenced in `[[wiki-links]]` that have no file
4. **Stale claims** — compiled pages not updated in >90 days that have active raw sources
5. **Broken links** — `[[wiki-links]]` pointing to non-existent files

Output as an audit report (see Output Formats).

### Operation: Archive

When a project is closed:
1. Move compiled project folder from `/01 Projects/<n>/` to `/04 Archive/Projects/`
2. Move raw notes from `/05 Raw/Projects/<n>/` to `/04 Archive/Raw/<n>/`
3. Update all back-links in compiled docs that referenced the project
4. Log the operation

---

## Log Format

`log.md` is append-only. Each entry:

```markdown
## 2026-04-16T14:32Z — Ingest

- Processed: `/05 Raw/Projects/Migrate-T24-CoreBanking/2026-04-16-kickoff.md`
- Updated: `/01 Projects/Migrate-T24-CoreBanking/migration-plan.md` (extended)
- Action: Added timeline section from kickoff notes
- Flags: none
```

```markdown
## 2026-04-16T15:00Z — Audit

- Unprocessed raw: 3 files
- Orphan pages: 1 → `/03 Resources/BCRC-Notes.md`
- Missing pages: 2 → [[RabbitMQ-Patterns]], [[MIA-Instant-Payments]]
- Stale claims: 0
- Broken links: 0
```

---

## Contradiction Handling

When a raw note contradicts an existing compiled claim:

```markdown
> ⚠ **Contradiction** — flagged 2026-04-16
> Raw source: [[/05 Raw/Areas/Architecture/2026-04-16-review.md]]
> Existing claim: "T24 is the system of record for loan balances"
> New claim: "VBCredit is the system of record post-migration"
> **Resolution required** — do not update until confirmed.
```

Do not resolve contradictions autonomously. Present them to the user.

---

## Output Formats

### Ingest summary

```
Processed: 3 raw notes
Updated pages:
  - /01 Projects/Migrate-T24/migration-plan.md (extended)
  - /03 Resources/Kafka/patterns.md (corrected)
  - /02 Areas/Architecture/decisions.md (new section)
Contradictions flagged: 1 (see /02 Areas/Architecture/decisions.md)
Log updated: log.md
```

### Audit report

```
Nexus Audit ? 2026-04-16

Unprocessed raw notes:   3
  - /05 Raw/Projects/EVO-Wallet/2026-04-15-meeting.md
  - /05 Raw/Inbox/api-notes.md
  - /05 Raw/Areas/DevOps/rke2-issue.md

Orphan pages:            1
  - /03 Resources/BCRC-Notes.md (no incoming links)

Missing pages:           2
  - [[RabbitMQ-Patterns]] — referenced in 3 pages, no file exists
  - [[MIA-Instant-Payments]] — referenced in 1 page, no file exists

Stale claims:            0
Broken links:            0

Recommended actions:
  1. Process 3 unprocessed raw notes
  2. Link or archive BCRC-Notes.md
  3. Create stub pages for RabbitMQ-Patterns and MIA-Instant-Payments
```
