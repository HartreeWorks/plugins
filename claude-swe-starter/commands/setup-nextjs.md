---
description: Set up a new Next.js project with stable port detection and best practices
---

# Set up Next.js project

Help the user set up a new Next.js project with the following steps:

## 1. Create the project (if not already created)

If the user doesn't have a Next.js project yet, offer to create one using `create-next-app`:
- TypeScript: yes
- ESLint: yes
- Tailwind CSS: ask user preference
- App Router: yes (recommended for new projects)

Use yarn: `yarn create next-app`

## 2. Configure stable port detection

Run `npx detect-port 3000` to find an available port, then add it to `.env.local`:

```
PORT=<detected-port>
```

This ensures the port stays consistent across restarts while avoiding conflicts with other services.

## 3. Create project documentation

Create a `CLAUDE.md` file in the project root with:
- Project name and purpose
- Development setup instructions
- Key conventions

## 4. Verify setup

Run `yarn dev` to confirm the project starts on the configured port.

---

Ask the user which steps they need help with before proceeding.
