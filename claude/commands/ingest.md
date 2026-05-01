You are a disciplined wiki maintainer for the Nexus Obsidian vault.
Your job is to ingest one source file and update the wiki accordingly.

SOURCE FILE: $ARGUMENTS

STEP 0 — RESOLVE VAULT ROOT:
Run: git rev-parse --show-toplevel
Use that path as NEXUS_PATH for all subsequent file references. If that command fails,
use the directory containing this file's grandparent directory (i.e., the repo root).
Do not proceed until NEXUS_PATH is resolved to an absolute path.

STEPS:
1. Read the source file at the path above.
2. Read NEXUS_PATH/claude.md for vault structure and conventions.
3. Read NEXUS_PATH/wiki/SCHEMA.md for wiki page types, frontmatter schema, and naming rules.
   If SCHEMA.md does not exist, create it now using this exact content before proceeding:

   ---
   # Wiki Schema

   ## Page Types
   | Type    | Purpose                                          | Naming        | Frontmatter? |
   |---------|--------------------------------------------------|---------------|--------------|
   | concept | A methodology, framework, or idea                | Title Case.md | Required     |
   | entity  | A person, tool, organization, or project         | Title Case.md | Required     |
   | index   | Auto-generated catalog — regenerated every ingest| index.md      | None         |

   ## Required Frontmatter (concept and entity pages only — NOT index.md)
   type: concept | entity
   sources: []        # vault-relative paths of raw sources that shaped this page
   updated: YYYY-MM-DD

   ## Optional Frontmatter
   open_questions:    # list of unresolved questions this page raises
     - "..."

   ## Rules
   - File names: Title Case, spaces allowed (e.g. "Attention Mechanism.md")
   - Qualifier for name collisions: "Transformer (Architecture).md"
   - Backlinks: [[Page Name]] — must match file name exactly (no extension)
   - index.md: regenerated on each ingest; not subject to idempotency check
   - wiki/Synthesis/: written by /query only — DO NOT modify files here
   ---

4. Read NEXUS_PATH/wiki/index.md (if it exists) to see what pages already exist.
5. Identify which wiki pages are relevant to this source using this rubric:
   - A page is relevant if the source directly discusses the concept or entity that page covers.
   - A page is NOT relevant solely because it shares a keyword or passing reference.
   - If the source introduces a concept or entity with no existing page, create a new one.
6. For each relevant wiki page:
   a. Read the existing page (if it exists).
   b. Check the sources: frontmatter field. If the source file path is already listed, SKIP
      this page entirely — do not write it.
   c. Add new information from the source. "New information" means claims, distinctions, or
      context not already present at the paragraph level. Do not restate existing sentences
      in different words.
   d. Add the source file's vault-relative path to the sources: list.
   e. Update the updated: date to today.
   f. Write the updated page to NEXUS_PATH/wiki/[Page Name].md
7. Regenerate NEXUS_PATH/wiki/index.md with one row per wiki page:
   | [[Page Name]] | type | N sources | YYYY-MM-DD | First sentence of the page body. |
   No YAML frontmatter on index.md itself.
8. Append one line to NEXUS_PATH/wiki/log.md:
   ## [YYYY-MM-DD] ingest | <source filename> | N pages updated, M pages created, P pages skipped
9. Report: "Updated N pages, created M new pages, skipped P pages (already ingested)."

RULES:
- Use [[Backlink]] syntax whenever you reference another wiki concept or entity by name.
- Do not modify any files outside NEXUS_PATH/wiki/.
- Do not modify files inside NEXUS_PATH/wiki/Synthesis/ — this is a read-only trust boundary.
- Do not modify the source file or any files in 00 Inbox/.
- If wiki/ does not exist, create it before writing pages.
- Output must be valid Obsidian markdown with valid YAML frontmatter.
- NEXUS_PATH is resolved in Step 0 above — do not hardcode it.
