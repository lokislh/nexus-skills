---
name: lm-wiki-ingest
description: >
  Ingest a source file into the Nexus wiki knowledge base. Use when the user
  wants to add a note, article, or document to the wiki. Trigger on: "ingest
  this", "add to wiki", "process this note", "add [filename] to the wiki",
  "ingest [file path]". Reads the source, identifies concepts and entities,
  creates or updates wiki pages in wiki/, updates wiki/index.md, and appends
  to wiki/log.md. Never modifies source files or wiki/Synthesis/.
version: 1.0.0
---

<!-- Adapted from .claude/commands/ingest.md — keep in sync when prompt logic changes -->

# LM Wiki — Ingest

## Purpose

Add a source file to the Nexus wiki. The wiki is the compiled knowledge layer
above PARA (`wiki/` at vault root). Source files are read but never modified.

## Agent Behavior

### Resolving the vault root

Run: git rev-parse --show-toplevel
Use that output as NEXUS_PATH for all file references in this session.
If the command fails, report: "Run lm-wiki-ingest from inside the Nexus vault
directory." and stop.

### Identifying the source file

Use the file path the user specified in their message (the first path-like
argument in the user turn). If no path is provided, ask: "Which file would you
like to ingest?"

### Ingest steps

1. Read the source file. If the file does not exist, report: "Source file not found: [path]." and stop.
2. Read NEXUS_PATH/agents.md for vault structure and conventions.
3. Read NEXUS_PATH/wiki/SCHEMA.md for page types, frontmatter schema, and naming rules.
4. Read NEXUS_PATH/wiki/index.md (if it exists) to see what pages already exist.
5. Identify which wiki pages are relevant to this source:
   - Relevant: source directly discusses the concept or entity the page covers.
   - Not relevant: shares only a keyword or passing reference.
   - Create a new page for any concept/entity with no existing page.
6. For each relevant wiki page:
   a. Read the existing page (if it exists).
   b. Check sources: frontmatter. If source file path already listed, SKIP this page entirely.
   c. Add new information (claims or distinctions not already present at paragraph level).
   d. Add source file's vault-relative path to the sources: list.
   e. Update the updated: date to today.
   f. Write the updated page to NEXUS_PATH/wiki/[Page Name].md
7. Regenerate NEXUS_PATH/wiki/index.md with one row per wiki page:
   | [[Page Name]] | type | N sources | YYYY-MM-DD | First sentence of page body. |
   No YAML frontmatter on index.md itself. Full overwrite on each ingest.
8. Append one entry to NEXUS_PATH/wiki/log.md:
   ## [YYYY-MM-DD] ingest | <source filename> | N updated, M created, P skipped
9. Report: "Updated N pages, created M new pages, skipped P pages (already ingested)."

## Core Principles

- Use [[Backlink]] syntax whenever referencing a wiki concept or entity by name.
- Only write to NEXUS_PATH/wiki/ — no other directories.
- NEVER write to NEXUS_PATH/wiki/Synthesis/ — this folder is read-only for ingest.
  It is owned by lm-wiki-query. Violating this creates a hallucination feedback loop.
- Do not modify the source file.
- All wiki pages must have valid YAML frontmatter with type:, sources:, and updated: fields.
- If index.md write fails, report the error explicitly — do not silently leave a partial state.
