---
description: Archive a completed project
---

# /archive-project

Archive a project by moving it to the `_archive/` folder and updating its status in the central index.

## Prerequisites

Must be in a project folder (contains `project.yaml`), OR provide project folder name as argument.

## Flow

### Step 1: Identify project
If in a project folder, use current project.
If argument provided (`/archive-project forethought-research`), use that.
Otherwise, ask: "Which project do you want to archive? (folder name)"

### Step 2: Verify project exists
Read `project.yaml` from the project folder to confirm it exists.
If not found, display error:
```
Error: Project folder not found: {folder}
Use /list-projects to see available projects.
```

### Step 3: Confirm archival
Display project info and ask for confirmation:
```
Archive this project?

  Name: {project name}
  Folder: {folder}
  Type: {type}

This will:
- Move the folder to ~/Documents/Projects/_archive/{folder}/
- Update status to 'archived' in projects.yaml

Proceed? (yes/no)
```

### Step 4: Create archive folder
Create `~/Documents/Projects/_archive/` if it doesn't exist.

### Step 5: Move project folder
Move the project folder from:
  `~/Documents/Projects/{folder}/`
to:
  `~/Documents/Projects/_archive/{folder}/`

### Step 6: Update central index
In `~/Documents/Projects/projects.yaml`, update the project entry:
- Change `status` to `archived`
- Update folder path to reflect new location (optional - could just use status)

### Step 7: Confirm
Display:
```
Project archived: {project name}
New location: ~/Documents/Projects/_archive/{folder}/

To unarchive, move the folder back and update projects.yaml.
```

## Unarchiving (manual process)

To restore an archived project:
1. Move folder from `_archive/` back to projects root
2. Edit `projects.yaml` and change status back to `active`

A future `/unarchive-project` skill could automate this.

## Error handling

- **Permission error:** "Failed to move folder. Check permissions."
- **Already archived:** "This project is already archived."
- **Folder in use:** "Cannot move folder - it may be in use. Close any open files and try again."
