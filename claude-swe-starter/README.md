# Claude SWE starter

A Claude Code plugin that provides sensible defaults for software engineering projects, with a focus on Next.js development.

## Features

- **Stable port detection**: Automatically assigns an available port during project setup, persisted in `.env.local` so it stays consistent
- **Next.js best practices**: Project structure, environment variable patterns, and configuration guidance
- **Setup command**: Interactive `/claude-swe-starter:setup-nextjs` command for new projects
- **Shell alias**: Script to add `cc` as a shortcut for `claude`

## Installation

### Via Claude Code
```
/plugins install claude-swe-starter
```

### Manual installation
```bash
claude plugin install ./path/to/claude-swe-starter --scope user
```

## Usage

### Set up a new Next.js project
```
/claude-swe-starter:setup-nextjs
```

### Automatic guidance
When working on Next.js projects, Claude will automatically apply the configuration best practices from this plugin.

## What it does

### Port configuration
Instead of hardcoding port 3000 (which is often in use), this plugin instructs Claude to:

1. Run `npx detect-port 3000` to find an available port
2. Write that port to `.env.local`
3. Leave the dev script unchanged (Next.js reads PORT automatically)

This gives you stable, bookmarkable URLs without port conflicts.

### Shell alias

Add `cc` as a shortcut for `claude`:

```bash
./scripts/setup-alias.sh
```

This adds `alias cc='claude'` to your `.zshrc` or `.bashrc`.

## Licence

MIT
