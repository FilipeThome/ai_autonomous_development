# Cache

Facts already paid for. Read this before scanning the repo or repeating a command.

## Rules

- One fact per line: `key: value`.
- Replace a line when the fact changes. Do not append history.
- No secrets, source, or logs.
- Keep this file under 40 lines.
- A failed RTK command stores its tee path here, not the log text.

## Facts

- project: ai_autonomous_development
- author: Filipe de Brito Thomé
- stacks: kotlin, java, react
- validate: powershell -File scripts/validate_framework.ps1
- rtk-hook: .cursor/hooks/rtk-rewrite.ps1
- rtk-status: not required for validation; shell output is compressed when rtk is on PATH
