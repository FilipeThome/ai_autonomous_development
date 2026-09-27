# React application template

Copy this file to the target application root as `AGENTS.md`. It is not a contract for ai_autonomous_development.

## Build

Use the package manager that matches the lockfile (`package-lock.json`, `pnpm-lock.yaml`, or `yarn.lock`):

```text
npm test
npm run build
```

## UI

- Follow the framework already in `package.json`.
- Function components.
- Keep TypeScript when `tsconfig.json` exists.
- Server state stays on the client library already installed.
- Derived data is computed during render.
- Effects synchronize with external systems and clean up after themselves.

## Checks

React Testing Library for component behavior. Playwright for a click-through flow.
