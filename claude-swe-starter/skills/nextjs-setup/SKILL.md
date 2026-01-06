---
name: nextjs-setup
description: Automatically configure Next.js projects with stable port detection. Use when creating new Next.js projects or when the user mentions port conflicts, development server setup, or Next.js configuration.
---

# Next.js project setup

When working with Next.js projects, follow these configuration practices:

## Port configuration

To avoid port conflicts while maintaining stable, bookmarkable URLs:

1. **Detect an available port** during initial setup:
   ```bash
   npx detect-port 3000
   ```

2. **Persist the port** in `.env.local`:
   ```
   PORT=<detected-port>
   ```

3. **Use the standard dev script** — Next.js automatically reads PORT from `.env.local`

This approach:
- Detects conflicts only once (at setup time)
- Keeps ports stable across restarts
- Requires no runtime dependencies

## Environment variables

- `.env.local` — Local overrides (gitignored)
- `.env.development` — Development defaults
- `.env.production` — Production defaults
- `.env.example` — Document required variables (committed)

## Recommended project structure

```
├── app/              # App Router pages and layouts
├── components/       # Reusable React components
├── lib/              # Utility functions
├── public/           # Static assets
├── styles/           # Global CSS
├── types/            # TypeScript definitions
└── CLAUDE.md         # Project documentation for Claude
```

## Package management

Use Yarn unless the project has a `package-lock.json` file.
