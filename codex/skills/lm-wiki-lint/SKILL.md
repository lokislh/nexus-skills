---
name: lm-wiki-lint
description: >
  Run a health check on the Nexus wiki. Find contradictions, orphan pages,
  stale claims, and missing cross-references. Trigger on: "lint the wiki",
  "check wiki health", "find contradictions", "wiki health check". Outputs
  a dated Lint-Report file. Read-only for all existing wiki pages.
version: 1.0.0
---

<!-- Adapted from .claude/commands/lint.md — keep in sync when prompt logic changes -->

# LM Wiki — Lint

## Purpose

Audit the wiki for health issues without modifying any content. Report-only.

## Agent Behavior

### Resolving the vault root

Run: git rev-parse --show-toplevel
Use that output as NEXUS_PATH for all file references in this session.
If the command fails, report: "Run lm-wiki-lint from inside the Nexus vault
directory." and stop.

### Check content page count

List files in NEXUS_PATH/wiki/ that are not log.md, index.md, SCHEMA.md, or
files whose name starts with "Lint-Report". If fewer than 3 such files exist,
report: "Wiki too small for lint — add more pages first." and stop.

### Lint steps

1. Read NEXUS_PATH/wiki/index.md to get the full page list.
2. Read every wiki page in NEXUS_PATH/wiki/ (skip wiki/Synthesis/ entirely).
3. Find and report the following (all findings are advisory — verify manually before acting):
   a. POSSIBLE CONTRADICTIONS: two pages making claims that appear incompatible
      about the same topic. Quote both sentences. Label as "Possible contradiction —
      verify manually" (LLM judgment is probabilistic; false positives are expected).
   b. ORPHAN PAGES: pages with 0 inbound [[Page Name]] links from other wiki pages.
      Check by searching wiki/*.md (excluding Synthesis/) for [[Page Name]] references.
      Synthesis/ pages are excluded from both the orphan-target list AND the link-source scan
      — they are query outputs, not knowledge nodes, and their link patterns are expected to
      differ from the main wiki graph.
   c. STALE CLAIMS: pages where the `updated:` frontmatter date is more than
      90 days ago. (sources: contains file paths, not dates — use updated: field.)
   d. MISSING PAGES: concepts cited via [[Link]] syntax multiple times across pages
      but lacking their own page.
   e. MISSING CROSS-REFERENCES: two pages clearly related by topic that don't
      link to each other.
4. Write report to NEXUS_PATH/wiki/Lint-Report-YYYY-MM-DD.md:
   ## Lint Report — YYYY-MM-DD
   Pages checked: N
   Possible contradictions: N | Orphan pages: N | Stale claims: N |
   Missing pages: N | Missing cross-refs: N
   [detailed findings with "verify manually" labels on contradictions]
5. Append to NEXUS_PATH/wiki/log.md:
   ## [YYYY-MM-DD] lint | N pages checked | N possible contradictions, N orphans
6. Report: "Lint complete. Report at wiki/Lint-Report-YYYY-MM-DD.md"

## Core Principles

- Do NOT modify any wiki pages. Report only.
- Only write the Lint-Report file and append to log.md.
- Contradiction findings are probabilistic — always label as "Possible" to prevent
  false confidence. The user verifies; the wiki agent reports.
