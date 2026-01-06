# Claude SWE starter

Configuration and best practices for software engineering projects.

## Next.js projects

When creating a new Next.js project, assign a stable port that avoids conflicts:

1. Run `npx detect-port 3000` to find an available port
2. Add the result to `.env.local`:
   ```
   PORT=<detected-port>
   ```
3. Leave the dev script as default (`next dev`) — Next.js automatically reads PORT from .env.local

This gives each project a stable, bookmarkable port while avoiding conflicts with other running services.

## Package management

- Use Yarn (e.g. `yarn add`, `yarn install`, `yarn remove`) instead of NPM for package management, unless the project contains a package-lock.json file.

## Project documentation

When setting up a new project, create a `CLAUDE.md` file in the project root with:
- Project overview and purpose
- Key architectural decisions
- Development setup instructions
- Team conventions and coding standards
