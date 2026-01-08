# Proofreader

LLM-powered proofreading for markdown documents.

## Features

- **Two engines**: Fast aspell spell-check or thorough LLM analysis via Gemini
- **Background execution**: Long documents can be proofread in the background while you continue working
- **Interactive review**: Auto-applies safe corrections, suggests style/clarity improvements for your approval
- **Language choice**: Supports British English or American English — saves your preference per project

## Installation

### From HartreeWorks marketplace

```
/plugin marketplace add hartreeworks/claude-plugins
/plugin install proofreader@hartreeworks-plugins
```

### First-time setup

Install dependencies:
```bash
cd ~/.claude/plugins/*/proofreader && yarn install
```

Install aspell for the spellcheck engine:
```bash
brew install aspell
```

Configure your Gemini API key:
```bash
cd ~/.claude/plugins/*/proofreader
cp .env.example .env
# Edit .env and add your GOOGLE_AI_API_KEY
```

## Usage

Say "proofread my document" and Claude will guide you through the process.

### Language preference

On first use, you'll be asked whether you prefer British or American English:

- **British English**: colour, organisation, analyse
- **American English**: color, organization, analyze

You can save this preference permanently for the project, or choose to be asked each time.

Preferences are stored in `.claude/proofreader.local.md`. Delete this file to reset.

### Spellcheck engine (~2 seconds)

Fast, deterministic spell-checking using aspell. Good for quick checks.

### LLM engine (30-60s per 100 lines)

Thorough AI-powered analysis using Gemini Flash. Three levels:

- **Level 1**: Mechanical only (spelling, punctuation, grammar)
- **Level 2**: Light style pass (recommended) — level 1 + top 5-10 style suggestions
- **Level 3**: Comprehensive — all style/clarity suggestions

### Background execution

For long documents or when proofreading is part of a larger workflow, the proofreader agent runs in the background. Claude continues with other tasks and checks the results when ready.

### Interactive review

After proofreading:
1. **Auto-corrections** are applied automatically (spelling, punctuation, grammar)
2. **Suggestions** are listed with IDs (S1, S2, etc.) for your review
3. Accept suggestions by typing their IDs: "S1 S3" or "all" or "none"

## For workflow integration

Other skills can spawn the proofreader agent directly:

```
Task tool:
  description: "Proofread article"
  prompt: |
    file_path: /path/to/document.md
    level: 2
    language: british
  subagent_type: "proofreader:proofreader"
  run_in_background: true
```

## Components

- **Skill**: `proofread` — Orchestrates the workflow and handles interactive review
- **Agent**: `proofreader` — Runs the LLM analysis, can execute in background

## Settings

Preferences are stored in `.claude/proofreader.local.md`:

```markdown
---
language: british
---

# Proofreader settings
```

## Requirements

- Node.js 18+
- aspell (for spellcheck engine): `brew install aspell`
- Google AI API key (for LLM engine)

## Licence

MIT
