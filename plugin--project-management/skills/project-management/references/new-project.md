---
description: Create a new project with full scaffolding for non-coding work
---

# /new-project

Create a new project folder with all necessary files for managing non-coding work (client projects, personal projects, planning).

## What this skill does

1. Creates a project folder at `~/Documents/Projects/{slug}/`
2. Sets up all required files:
   - `project.yaml` - Project metadata
   - `CLAUDE.md` - About, conventions, instructions, and behaviour rules
   - `MEMORY.md` - Dynamic memory for context tracking
   - `TODO.md` - Task tracking
   - `.gitignore` - Sensible defaults for Git
   - `.claude/archive/` - Folder for archived memories
3. Adds the project to the central index (`~/Documents/Projects/projects.yaml`)
4. Optionally chains to `/add-google-doc` to add Google Docs

## Flow

### Step 1: Gather basic info
Ask the user:
- "What's the project name?"
- "What type of project? (client / personal / planning)"

### Step 2: Generate folder name
Create folder name as `{slug}` where:
- slug is the project name converted to lowercase, spaces replaced with hyphens, special characters removed

### Step 3: Create folder structure
Create `~/Documents/Projects/{folder-name}/` with:
- `project.yaml`
- `CLAUDE.md`
- `MEMORY.md`
- `TODO.md`
- `.gitignore`
- `context/` subfolder - Reference materials for Claude to understand
  - `google-docs.yaml` inside context/
- `work/` subfolder - Active work (drafts, outputs, deliverables)
- `assets/` subfolder - Images, data files, attachments
- `.claude/archive/` subfolder - Archived memories (auto-managed)

### Step 4: Cold start prompts
Ask the user:
- "Briefly, what's this project about?" → Use answer for the About section in CLAUDE.md
- "What are you working on first?" → Use answer for "Where we are" in MEMORY.md

### Step 5: Populate files with templates

**project.yaml:**
```yaml
name: "{project name}"
folder: "{slug}"
type: {client|personal|planning}
start_date: {YYYY-MM-DD}
skill_version: "1.0"
template: default
```

**CLAUDE.md:**
```markdown
# Project: {project name}

## About
{user's description from cold start prompt}

## Conventions
[Add project-specific spelling, terminology, or formatting conventions here]

## Instructions
[Add project-specific behavior instructions here]

## Behaviour

**On conversation start:**
- Read MEMORY.md, TODO.md, context/google-docs.yaml, and list context/ folder
- Present a brief orientation based on current project state
- Mention active task count if there are tasks

**During conversation:**
- Load relevant docs proactively when context suggests they'd help
- Update MEMORY.md when significant things happen (decisions, focus changes, meaningful progress)
- Update TODO.md when tasks are completed or new tasks emerge
- When wrapping up or after significant work, add a handoff note to the log

**Folder purposes:**
- `context/` - Reference materials to understand the project
- `work/` - Active work (drafts, outputs, deliverables)
- `assets/` - Supporting files (images, data, attachments)
```

**MEMORY.md:**
```markdown
# Project Memory

**Status:** Active - getting started

## Context
[Background context will develop as the project progresses]

## Where we are
- {user's answer from cold start prompt}

## What's next
[To be determined]

## Log
[No sessions yet]
```

**context/google-docs.yaml:**
```yaml
# Google Docs for this project
# Use /add-google-doc to add documents, or edit manually
# Local files can be placed directly in context/ - no registration needed

docs: []
```

**TODO.md:**
```markdown
# Tasks

## Active
[Add tasks as you go]

## Waiting
[Tasks blocked on something/someone]

## Later
[Ideas to revisit when time allows]

## Done
[Recently completed - periodically cleared]
```

**.gitignore:**
```gitignore
# macOS system files
.DS_Store
.AppleDouble
.LSOverride
._*

# Security - never commit these
.env
.env.*
*.pem
*.key
credentials.json
secrets.yaml

# Logs
*.log
logs/

# Python
__pycache__/
*.py[cod]
.venv/
venv/

# Node
node_modules/

# Editor/IDE
.idea/
.vscode/
*.swp
*.swo
*~

# Temporary files
*.tmp
*.temp
.cache/
```

### Step 6: Update central index
Add entry to `~/Documents/Projects/projects.yaml`:
```yaml
- folder: {slug}
  name: "{project name}"
  type: {type}
  status: active
```

### Step 7: Ensure VS Code workspace exists
If `~/Documents/Projects/projects.code-workspace` doesn't exist, create it:
```json
{
  "folders": [
    { "path": "." }
  ],
  "settings": {}
}
```

This file lets users open all projects in VS Code/Cursor. No update needed when adding projects - the wildcard path includes everything.

### Step 8: Initialize git
Run `git init` in the project folder.

### Step 9: Offer to add docs
Ask: "Want to add any Google Docs now? (yes/no)"
If yes, explain they can use `/add-google-doc` or paste URLs.

### Step 10: Confirm completion
Display:
```
Project created: {project name}
Location: ~/Documents/Projects/{slug}/

Next steps:
- cd ~/Documents/Projects/{slug}
- Use /add-google-doc to add Google Docs
- Place local reference files in context/
- Start a conversation and I'll load the project context

Tip: Open projects.code-workspace in VS Code/Cursor for easy access to all projects.
```
