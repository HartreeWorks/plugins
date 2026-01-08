---
name: proofread
description: This skill should be used when the user says "proofread", "spell check", "check spelling", "check grammar", "proofread this document", "review for typos", "proofread my article", "check this for errors", or mentions proofreading a markdown file.
---

# Proofread skill

Proofreading for markdown documents. Supports British English or American English. Two engines available:

- **Spellcheck** (fast, deterministic): Uses aspell for spell-checking (~2 seconds) — runs directly
- **LLM** (thorough, AI-powered): Uses Gemini Flash (~30-60 seconds per 100 lines) — spawns the `proofreader` agent, can run in background

## How it works

1. **Check language preference**: Read from settings or ask user
2. **Spellcheck engine**: Reports possible misspellings as suggestions for review
3. **LLM engine**: Spawns the `proofreader:proofreader` agent for thorough analysis
4. **Interactive acceptance**: User types suggestion IDs to accept them

## Workflow

### Step 0: Check language preference

Before proofreading, check for saved language preference in `.claude/proofreader.local.md`:

```bash
if [[ -f ".claude/proofreader.local.md" ]]; then
  LANGUAGE=$(sed -n '/^---$/,/^---$/{ /^---$/d; p; }' ".claude/proofreader.local.md" | grep '^language:' | sed 's/language: *//')
fi
```

**If language is set** (british or american): Use it and proceed to Step 1.

**If language is not set or file doesn't exist**: Ask the user using AskUserQuestion:

> **Language preference**
>
> Which English spelling convention should I use for proofreading?
>
> - **British English** — colour, organisation, analyse (Recommended)
> - **American English** — color, organization, analyze

Then ask about saving the preference:

> **Save preference?**
>
> - **Save permanently** — Don't ask again for this project
> - **Use for this session** — Ask again next time

**If user chooses "Save permanently"**: Create/update `.claude/proofreader.local.md`:

```markdown
---
language: british
---

# Proofreader settings

Language preference saved. To change, edit this file or delete it to be asked again.
```

### Step 1: Ask which engine and level

When the user wants to proofread a document, ask:

> Which proofreading approach do you want?
>
> **Spellcheck** — Fast deterministic spell-check using aspell (~2 seconds). Good for quick checks.
>
> **LLM** — AI-powered proofreading using Gemini Flash (~30-60s per 100 lines). Choose a level:
> - **Level 1 — Mechanical only**: Spelling, punctuation, grammar (fast, minimal output)
> - **Level 2 — Light style pass**: Level 1 + top 5-10 style/clarity suggestions (recommended)
> - **Level 3 — Comprehensive**: All style/clarity suggestions (thorough, more output)

### Step 2: Run proofreading

#### For spellcheck engine (run directly):

```bash
cd "${CLAUDE_PLUGIN_ROOT}" && npx tsx scripts/proofread.ts "<file_path>" --engine spellcheck --language <british|american>
```

Parse the JSON output and present results (see Step 3).

#### For LLM engine (spawn the proofreader agent):

Use the Task tool to spawn the `proofreader:proofreader` agent:

```
Task tool parameters:
  description: "Proofread <filename>"
  prompt: |
    file_path: <absolute_path_to_file>
    level: <1|2|3>
    language: <british|american>
  subagent_type: "proofreader:proofreader"
  run_in_background: <true|false>
```

**When to run in background:**
- Documents > 500 lines — use `run_in_background: true`
- Part of a larger workflow — background allows parallel work
- Short documents — run foreground for immediate results

When `run_in_background: true`, the Task tool returns immediately with an `output_file` path. Continue with other work, then check that file later for results.

### Step 3: Present results

When proofreading completes (agent or script), format the output:

```
## Proofreading complete: <filename>

**Language**: <British|American> English

**Auto-applied (<count> corrections):**
- Line <n>: "<from>" → "<to>"
- ...

**Suggestions for review:**
- [S1] Line <n>: <description>
- [S2] Line <n>: <description>
- ...

Corrected file saved to: <filename>.proofread.md

**To accept suggestions**, type their IDs (e.g., "S1 S3") or "all", or "none" to skip.
```

### Step 4: Apply accepted suggestions

When the user provides IDs:

```bash
cd "${CLAUDE_PLUGIN_ROOT}" && npx tsx scripts/apply-suggestions.ts "<file>.proofread.md" <S1 S2 ...>
```

Or if they say "all":
```bash
cd "${CLAUDE_PLUGIN_ROOT}" && npx tsx scripts/apply-suggestions.ts "<file>.proofread.md" all
```

### Step 5: Confirm completion

```
Final file saved to: <filename>.final.md

Applied: S1, S3
Removed: S2, S4
```

---

## For other workflows

Other skills (publication, blog post preparation, etc.) can spawn the proofreader agent directly:

```
Task tool parameters:
  description: "Proofread article before publication"
  prompt: |
    file_path: /path/to/article.md
    level: 2
    language: british
  subagent_type: "proofreader:proofreader"
  run_in_background: true
```

The agent returns structured results. The calling workflow can then:
1. Continue with other tasks while proofreading runs
2. Check the output file when ready
3. Present results and handle suggestion acceptance using this skill's Step 3-5

**Note**: Other workflows should either:
- Read the language from `.claude/proofreader.local.md` if it exists
- Or specify the language explicitly in the agent prompt

---

## Settings file

The plugin stores user preferences in `.claude/proofreader.local.md`:

```markdown
---
language: british
---

# Proofreader settings

Language preference saved. To change, edit this file or delete it to be asked again.
```

**Fields:**
- `language`: `british` or `american`

To reset preferences, delete the file and the skill will ask again.

---

## First-time setup

Install dependencies:

```bash
cd "${CLAUDE_PLUGIN_ROOT}" && yarn install
```

Spellcheck engine requires aspell:
```bash
brew install aspell
```

## Configuration

Create a `.env` file in the plugin root (copy from `.env.example`):
- `GOOGLE_AI_API_KEY`: Google AI API key for Gemini
- `PROOFREAD_MODEL`: Model ID (default: gemini-2.0-flash)

## Output files

- `<filename>.proofread.md`: Auto-corrections applied, suggestions as HTML comments
- `<filename>.final.md`: After accepting/rejecting suggestions

## Notes

- Supports British English and American English conventions
- Preserves author's voice and technical terminology
- Processes long documents in chunks automatically
- Progress shown via stderr, results via stdout (JSON)
