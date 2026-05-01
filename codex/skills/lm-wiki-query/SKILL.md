---
name: lm-wiki-query
description: >
  Answer a question using the Nexus wiki knowledge base. Use when the user
  asks something their accumulated notes might answer. Trigger on: "what does
  my wiki say about", "query the wiki", "search my notes for", or any question
  that could be answered by the user's personal knowledge base. Synthesizes
  an answer with citations from wiki pages. Files the answer to wiki/Synthesis/
  when it draws from 2+ distinct pages.
version: 1.0.0
---

<!-- Adapted from .claude/commands/query.md — keep in sync when prompt logic changes -->

# LM Wiki — Query

## Purpose

Answer questions using the compiled knowledge in wiki/. Return cited answers
and optionally file synthesized answers back into the wiki.

## Agent Behavior

### Resolving the vault root

Run: git rev-parse --show-toplevel
Use that output as NEXUS_PATH for all file references in this session.
If the command fails, report: "Run lm-wiki-query from inside the Nexus vault
directory." and stop.

### Query steps

1. Read NEXUS_PATH/wiki/index.md to find the most relevant wiki pages (max 5).
   If index.md is missing, or exists but contains no table rows (header-only or empty file),
   report: "Wiki is empty — run lm-wiki-ingest first." and stop.
   Treat a table with only the header row (| Page | Type | Sources | Updated | Summary |)
   as equivalent to empty.
2. Read each relevant page in full.
3. Synthesize a markdown answer with citations: (see [[Page Name]])
4. Count distinct [[wikilinks]] in the answer.
   File it if: 2 or more distinct [[Page Name]] links appear in the answer.
   Do not file if: 0 or 1 wiki links. This is a mechanical rule — no judgment needed.
5. If filing: write the answer to NEXUS_PATH/wiki/Synthesis/<Kebab-Case-Title>.md
   YAML frontmatter: type: synthesis, sources: [wiki pages used], updated: today
6. Append to NEXUS_PATH/wiki/log.md:
   ## [YYYY-MM-DD] query | <question summary> | filed: path OR not-filed
7. Report the answer. If filed: "Filed as wiki/Synthesis/<title>.md"

## Core Principles

- Only read from wiki/ — do not read source notes in PARA folders (00 Inbox/, 01 Projects/, etc.).
  Reason: wiki pages are the compiled, reliable layer; PARA sources are raw and may be contradictory.
- Only write to wiki/Synthesis/ and append to wiki/log.md.
- Never modify existing wiki/*.md pages.
