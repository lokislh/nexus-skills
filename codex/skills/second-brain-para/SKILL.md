---
name: second-brain-para
description: >
  Use this skill to organize, classify, and maintain a second brain using the
  PARA method (Projects, Areas, Resources, Archives). Trigger whenever the user
  wants to: organize notes in Obsidian, Notion, Google Drive, OneDrive, or local
  folders; decide where a file or note belongs; clean up a chaotic knowledge base;
  apply or refactor PARA structure; build a folder hierarchy; process inbox items;
  rename or regroup content; define naming conventions; or review whether something
  belongs in Projects, Areas, Resources, or Archives. Also applies to personal
  knowledge management systems like Nexus, Roam, Logseq, or any "second brain"
  setup — even if the user does not explicitly say "PARA". Trigger on phrases like
  "my notes are a mess", "where should I put this", "help me organize my knowledge
  base", or "clean up my folders".
version: 2.1.0
---

# Second Brain with PARA

## Purpose

Help the user build, maintain, or refactor a second brain based on the **PARA method**:

| Category | Definition | Ends? |
|---|---|---|
| **Projects** | Short-term effort with a clear outcome and deadline | Yes — when delivered |
| **Areas** | Long-term responsibility maintained to a standard | No finish line |
| **Resources** | Reference material and topics of ongoing interest | No obligation |
| **Archives** | Inactive items from Projects, Areas, or Resources | Preserved for retrieval |

---

## Agent Behavior

### Creating new entries

When this skill creates a new note or compiled entry, use the separate template
file at `templates/para-note-template.md` as the default structure. Resolve this
path relative to this `SKILL.md`.

Apply the template after the PARA destination is chosen:

1. Fill the YAML fields from the source note when available.
2. Use today's ISO date for `created` when the source has no date.
3. Keep unknown metadata empty rather than inventing it.
4. Fill `PARA Placement` with the selected category, destination path, and
   actionability-based reason.
5. Preserve useful source links and add Obsidian backlinks where relevant.
6. Remove placeholder bullets or sections that remain genuinely empty.

If the user asks only to move an existing note without rewriting it, preserve the
note body and use the template only for any newly created companion/index note.

### Classifying a single note or file

Run through this decision tree in order. Stop at the first match.

1. Does it have a clear deliverable and an active working horizon? → **Projects**
2. Is it an ongoing responsibility that still requires care? → **Areas**
3. Is it useful reference material with no active obligation? → **Resources**
4. Is it inactive, completed, or outdated? → **Archives**
5. Cannot determine? → Place in `/00 Inbox` and flag for user decision.

### Proposing a folder structure

- Output a tree view
- Annotate each folder with a one-line rationale
- Flag items that require user judgment before placing

### Refactoring an existing system

1. Audit the current structure first — list what exists
2. Propose moves as a table: `Current Path | Proposed Path | Reason`
3. Flag ambiguous items separately
4. **Do not move anything without explicit user confirmation**

### Processing the Inbox

For each item in `/00 Inbox`:
1. Apply the classification decision tree above
2. Propose a destination path
3. If a Project: check whether a project folder exists or needs to be created
4. If still unclear after two attempts: leave in Inbox and note *why*

Rule: **Nothing lives in Inbox permanently.** Inbox is a staging area, not a category.

---

## Core Principles

### 1. Organize by actionability, not by topic
PARA is an operational system, not a taxonomy. The question is not "what is this about?" but "what do I need to do with this?"

### 2. Default to the smallest useful structure
- Prefer clear names over deep hierarchies
- Prefer shallow folders over elaborate tag systems
- Add structure only when the user clearly needs it

### 3. Projects are the center of gravity
When in doubt, organize around what the user is actively trying to deliver now.

### 4. Areas are not Projects
An Area has no finish line. If something can be marked done, it is a Project, not an Area.

### 5. Archives are a feature, not a cemetery
Move inactive material out of active space aggressively. Preserve retrieval paths so archived material can be found later.

---

## Definitions

### Projects

A Project is outcome-oriented, finite, and active now or soon.

**Examples:**
- "Launch DevOps team structure"
- "Document Open Banking Get Fee API"
- "Prepare audit package for BCRC migration"
- "Deploy local dev environment for EVO project"
- "Publish Q2 architecture review"

**Tests:**
- Does it have a clear deliverable?
- Can it be marked done?
- Is it active within a meaningful working horizon?

→ If yes to all three, it is a Project.

### Areas

An Area is a standard to maintain, a continuing responsibility, never "done."

**Examples:**
- Architecture Governance
- Team Leadership
- Banking Integrations
- DevOps Capability
- Health
- Personal Finance

**Tests:**
- Does this require ongoing care?
- Would it still exist next year?
- Is success measured by maintenance rather than completion?

→ If yes, it is an Area.

### Resources

A Resource is reference material — useful to keep, but not an active obligation.

**Examples:**
- Kafka patterns and notes
- RabbitMQ architecture references
- OpenTelemetry concepts
- TOGAF method documentation
- Tool evaluations for future use

**Tests:**
- Is this useful to keep?
- Is it not an active project?
- Is it not a responsibility to maintain?

→ If yes to all three, it is a Resource.

### Archives

Archives contain completed projects, inactive areas, outdated resources, and old notes kept only for retrieval or audit.

**Examples:**
- Completed migration plans
- Past vendor evaluation reports
- Old architecture drafts
- Documentation for decommissioned systems
- Meeting notes from closed projects

---

## Default Folder Structure

```text
/00 Inbox             ← unprocessed capture; nothing lives here permanently
/01 Projects          ← active, outcome-driven work
/02 Areas             ← ongoing responsibilities
/03 Resources         ← reference material by topic
/04 Archive           ← inactive material from any category
```

### Subfolders (add only when needed)

```text
/01 Projects/
  Active/
  On-Hold/

/02 Areas/
  Architecture/
  TeamLeadership/
  PersonalFinance/

/03 Resources/
  Templates/
  Tools/
  Concepts/

/04 Archive/
  Projects/
  Areas/
  Resources/
```

Do not create this full hierarchy upfront. Add subfolders when a category grows beyond 7–10 items.

---

## Naming Conventions

### Folders
- Projects: `Verb-Noun` → `Migrate-T24-CoreBanking`, `Document-OpenBanking-API`
- Areas: Domain noun → `Architecture`, `TeamLeadership`, `DevOps`
- Resources: Topic noun → `Kafka`, `TOGAF-Concepts`, `RabbitMQ-Patterns`
- Archives: Prefix with year → `2024-eMerchant-Integration`

### Files and Notes
- General: `YYYY-MM-DD-Short-Title` → `2026-04-16-Kickoff-Notes`
- Meeting notes: `YYYY-MM-DD-Meeting-Topic-Participants`
- Decisions / ADRs: `ADR-NNN-Short-Title`
- Templates: `TEMPLATE-Purpose`

### Rules
- Use hyphens, not spaces or underscores
- Avoid generic names: `notes.md`, `misc`, `stuff`, `temp`
- Dates in ISO 8601: `2026-04-16`, not `April 16` or `16-04-2026`

---

## Edge Cases

### "This could be a Project or an Area"
Apply the finish line test: *Can this be marked done?*
- If yes → Project
- If no → Area

Example: "Architecture Documentation" is an Area. "Document the Open Banking API" is a Project inside that Area.

### "This Resource is relevant to an active Project"
Do not duplicate. Keep the canonical copy in `/03 Resources`. Reference it from the Project folder using a shortcut, link, or note. Exception: if the resource will be modified as part of the project, move a working copy to the Project folder and archive or update the Resource when done.

### "An archived Project has a follow-up"
Reactivation: move the project back from `/04 Archive/Projects/` to `/01 Projects/` and update the name or date prefix. Do not create a copy.

### "Where do Templates go?"
`/03 Resources/Templates/` by default. If a template is specific to one Project, place it in that Project folder.

### "I have meeting notes with no clear project"
- If tied to an active project → `/01 Projects/<ProjectName>/`
- If tied to an Area → `/02 Areas/<AreaName>/`
- If standalone reference → `/03 Resources/MeetingNotes/`
- If old and inactive → `/04 Archive/`

---

## Compartment 5: Raw Notes (LLM Wiki Layer)

The standard PARA structure (00–04) holds **compiled knowledge** — documents that have been processed, structured, and are ready to use. Compartment 5 holds **raw inputs** before they are compiled.

```text
/05 Raw
  Projects/
    <ProjectName>/     ← raw notes, meeting dumps, drafts tied to a project
  Areas/
    <AreaName>/        ← raw observations, logs, unprocessed captures for an area
  Inbox/               ← raw notes not yet assigned to a project or area
```

### Rules for Raw Notes

- Raw notes are **inputs**, not knowledge assets. They are not browsed directly.
- Every raw note must link to the compiled document(s) it informed, once processed.
- Compiled documents (in 01–03) should back-link to their raw sources in `/05 Raw`.
- The `nexus-maintainer` skill is responsible for processing raw notes into compiled knowledge.

### Raw Note Format

Each raw note should include a header:

```markdown
---
date: 2026-04-16
project: Migrate-T24-CoreBanking   # or area: Architecture
status: raw | compiled | superseded
compiled-into: /01 Projects/Migrate-T24-CoreBanking/migration-plan.md
---
```

### Lifecycle

```
Capture → /05 Raw/Projects/<name>/   (status: raw)
       ↓
Maintainer processes → compiled document updated
       ↓
Raw note marked status: compiled + link added
       ↓
On project archive → raw notes move to /04 Archive/Raw/<name>/
```

Raw notes with `status: raw` are the queue for the `nexus-maintainer` skill.

---

## Output Formats

When proposing a classification, use:

```
Note/File: <name>
Proposed location: /01 Projects/Migrate-T24-CoreBanking/
Reason: Active project with a clear deliverable (T24 migration); finite scope.
Confidence: High | Medium | Low
```

When proposing a folder structure, use a tree view with annotations:

```
/01 Projects/
  Migrate-T24-CoreBanking/     ← active migration effort
  Document-OpenBanking-API/    ← API documentation sprint
/02 Areas/
  Architecture/                ← ongoing governance responsibility
  DevOps/                      ← team capability and infrastructure
/03 Resources/
  Kafka/                       ← integration reference
  TOGAF/                       ← architecture method notes
/04 Archive/
  2025-eMerchant-Integration/  ← completed project
```

When proposing moves during a refactor, use a table:

| Current Path | Proposed Path | Reason |
|---|---|---|
| `/misc/kafka-notes.md` | `/03 Resources/Kafka/kafka-notes.md` | Reference material, no active obligation |
| `/inbox/T24-migration-plan.md` | `/01 Projects/Migrate-T24-CoreBanking/` | Active project with clear deliverable |
| `/old/2023-vendor-eval.md` | `/04 Archive/Resources/2023-vendor-eval.md` | Outdated, keep for retrieval |
