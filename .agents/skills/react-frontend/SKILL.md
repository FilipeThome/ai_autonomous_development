---
name: react-frontend
description: Implements React UI with the app's existing framework, local state, and tests. Use when the task touches React, JSX, TSX, hooks, Vite, Next.js, or frontend components.
---

# React

## Before editing

1. Read `package.json`, the lockfile, and `stacks/react/AGENTS.template.md`.
2. Follow the framework already chosen (Vite, Next.js, or another). Do not introduce a second one.
3. Keep TypeScript when `tsconfig.json` exists. Do not convert a JavaScript app unless the user asks.
4. Query Context7 for the major version of React, the router, and the data library already in the repo.

## Components

- Function components and hooks.
- A component file owns its view. Put shared behavior in a hook when a second component needs it.
- Props that are required are required in the type. Do not default a required id to an empty string.
- Give every input an accessible name. Use a button for actions and a link for navigation.

## State

- Server state uses the client cache already in `package.json` (React Query, SWR, Router loaders, or Server Components). Do not add another one.
- Local UI state uses `useState` or `useReducer`.
- Derived values are computed during render. Do not copy them into state with `useEffect`.
- An effect synchronizes with a system outside React (subscription, browser API, imperative widget) and returns a cleanup.
- List keys are stable ids from the data, not the array index, when the list can reorder.

## Tests and UI checks

- React Testing Library. Assert on roles, names, and text the user sees.
- Do not assert on component state or CSS class names as the primary check.
- For a flow the user can click through, run the app and check it with Playwright.
- When browser tools are available, exercise the changed path. A screenshot alone is not verification.

## Verify

Use the package manager that matches the lockfile:

```text
npm test
npm run build
```

Replace `npm` with `pnpm` or `yarn` when that lockfile is the one present. Run the lint script only when `package.json` already defines it.
