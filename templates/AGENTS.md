# Nexus - Agents Context

## About This Vault

**Nexus** is an Obsidian vault serving as a personal Second Brain, built around the **CODE principles** from Tiago Forte's book *Build a Second Brain*.

## The CODE Framework

### C - Capture

Collect information that resonates: ideas, insights, quotes, references, and anything worth remembering. Notes here are the raw inputs - saved from articles, books, conversations, or fleeting thoughts.

### O - Organize

Structure captured notes using the **PARA method** (Projects, Areas, Resources, Archives) or any folder/tag system that supports retrieval. The goal is to organize for action, not perfect categorization.

### D - Distill

Refine and highlight the most valuable ideas within notes. This includes progressive summarization: bolding key passages, adding highlights, and writing summaries so the essence is easy to retrieve later.

### E - Express

Turn stored knowledge into outputs - writing, presentations, decisions, or creative work. Notes are not just for storage; they feed real projects and creative expression.

## Vault Folder Structure

The vault follows the **PARA method** inside the CODE workflow:

| Folder          | CODE Stage         | Purpose                                                      |
| --------------- | ------------------ | ------------------------------------------------------------ |
| `00 Inbox/`     | Capture            | Raw, unprocessed notes and ideas - first landing zone        |
| `01 Projects/`  | Organize           | Active projects with a defined goal and deadline             |
| `02 Areas/`     | Organize           | Ongoing responsibilities with no end date (architecture, ai, claude, codex) |
| `03 Resources/` | Organize / Distill | Reference material on topics of interest - processed and refined |
| `04 Archive/`   | Organize           | Inactive projects, areas, or resources no longer relevant    |
| `Templates/`    |                    | Reusable note templates                                      |
| `wiki/`         | Express            | Compiled wiki — LLM-maintained knowledge layer, sits above PARA |

**Flow:** New notes land in `00 Inbox` → organized into Projects/Areas/Resources → distilled in place → expressed as outputs. The `wiki/` layer compiles across all PARA content automatically via `/ingest`.

**Wiki layer:** `wiki/` is NOT a PARA category. It is the compiled, LLM-maintained knowledge base. Use `/ingest <file>` to add a source. Use `/query <question>` to ask questions. Use `/lint` when 20+ pages exist. Schema: `wiki/SCHEMA.md`. Do not edit wiki pages manually — owned by the LLM.

---

## Catalogs

Reference collections stored under `03 Resources/` for structured, reusable knowledge:

| Catalog             | Location                                     | Contents                                                     |
| ------------------- | -------------------------------------------- | ------------------------------------------------------------ |
| **Abbreviations**   | `03 Resources/Dictionaries/Abbreviations.md` | Acronyms and short forms used across the vault (CODE, PARA, PKM) |
| **Concepts**        | `03 Resources/Dictionaries/Concepts.md`      | Distilled definitions of key methodologies and frameworks    |
| **Biases**          | `03 Resources/Dictionaries/Biases.md`        | Cognitive biases relevant to decision-making and knowledge work |
| **Prompts Library** | `02 Areas/AI/Prompts/`                       | Reusable LLM prompts indexed in `00 Index.md`                |

---

## Usage Notes for Agent

- This vault is a **personal knowledge base**, not a task manager or calendar.
- Notes may be loosely structured - prioritize understanding intent over rigid formatting.
- When helping with notes, respect the CODE workflow: new raw inputs go in Capture, refined ideas get Distilled, finished outputs come from Express.
- Prefer **linking ideas** over creating isolated notes when possible.
- Tags and backlinks are meaningful - preserve and suggest them when relevant.
- When adding abbreviations, concepts, or biases, append to the relevant file in `03 Resources/Dictionaries/` rather than creating isolated notes.
- When adding prompts, create a numbered file in `02 Areas/AI/Prompts/` and register it in `00 Index.md`.

