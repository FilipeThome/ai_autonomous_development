$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot

function Assert-File([string]$RelativePath) {
    $path = Join-Path $root $RelativePath
    if (-not (Test-Path -LiteralPath $path)) {
        throw "Missing $RelativePath"
    }
}

$required = @(
    "AGENTS.md",
    "CLAUDE.md",
    "README.md",
    "docs/architecture.md",
    ".gemini/settings.json",
    ".github/copilot-instructions.md",
    ".github/instructions/kotlin.instructions.md",
    ".github/instructions/java.instructions.md",
    ".github/instructions/react.instructions.md",
    ".cursor/rules/orchestrator.mdc",
    ".cursor/rules/kotlin-spring.mdc",
    ".cursor/rules/java.mdc",
    ".cursor/rules/react.mdc",
    ".cursor/hooks.json",
    ".cursor/hooks/rtk-rewrite.ps1",
    ".cursor/mcp.json",
    ".mcp.json",
    ".vscode/mcp.json",
    "mcp/optional.github.json",
    ".env.example",
    "memory/memory.md",
    "memory/context.md",
    "memory/error_patterns.md",
    "memory/cache.md",
    "stacks/kotlin/AGENTS.template.md",
    "stacks/java/AGENTS.template.md",
    "stacks/react/AGENTS.template.md",
    "scripts/run_delivery.ps1",
    "scripts/run_delivery.sh",
    "scripts/setup_rtk.ps1",
    ".idea/ai_autonomous_development.iml",
    ".idea/.name",
    ".claude/agents/architect.md",
    ".claude/agents/kotlin-engineer.md",
    ".claude/agents/java-engineer.md",
    ".claude/agents/react-engineer.md",
    ".claude/agents/test_engineer.md",
    ".claude/agents/reviewer.md",
    ".claude/agents/diagnostics.md",
    ".claude/commands/deliver.md",
    ".github/agents/architect.agent.md",
    ".github/agents/kotlin-engineer.agent.md",
    ".github/agents/java-engineer.agent.md",
    ".github/agents/react-engineer.agent.md",
    ".github/agents/test-engineer.agent.md",
    ".github/agents/reviewer.agent.md",
    ".github/agents/diagnostics.agent.md",
    "ai/tickets/ticket_processor.md",
    "ai/refactoring/auto_refactor.md",
    "ai/observability/diagnostics.md",
    "ai/observability/self_healing.md",
    "ai/memory/learning_system.md"
)

foreach ($relativePath in $required) {
    Assert-File $relativePath
}

$skills = @(
    "autonomous-delivery",
    "architecture-review",
    "kotlin-spring",
    "java-spring",
    "react-frontend",
    "diagnostics-self-heal",
    "token-economy"
)

foreach ($name in $skills) {
    $relativePath = ".agents/skills/$name/SKILL.md"
    Assert-File $relativePath
    $text = Get-Content -LiteralPath (Join-Path $root $relativePath) -Raw
    if ($text -notmatch "(?m)^name:\s*$name\s*$") {
        throw "$relativePath name must be $name"
    }
    if ($text -notmatch "(?m)^description:\s*\S+") {
        throw "$relativePath missing description"
    }
}

$agentLines = Get-Content -LiteralPath (Join-Path $root "AGENTS.md")
if ($agentLines.Count -gt 160) {
    throw "AGENTS.md has $($agentLines.Count) lines (max 160)"
}
$agentText = $agentLines -join "`n"
foreach ($word in @("Kotlin", "Java", "React", "ai_autonomous_development")) {
    if ($agentText -notmatch $word) {
        throw "AGENTS.md missing $word"
    }
}
if ($agentText -match "AI_RUNNER") {
    throw "AGENTS.md must not require a model runner"
}

function Assert-Mcp([string]$RelativePath, [string]$PropertyName) {
    Assert-File $RelativePath
    $path = Join-Path $root $RelativePath
    $raw = Get-Content -LiteralPath $path -Raw
    if ($raw -match "ghp_|github_pat_|sk-|AKIA[0-9A-Z]{16}") {
        throw "$RelativePath looks like it contains a secret"
    }
    $json = $raw | ConvertFrom-Json
    $servers = $json.$PropertyName
    if (-not $servers.context7) {
        throw "$RelativePath missing context7"
    }
    if (-not $servers.playwright) {
        throw "$RelativePath missing playwright"
    }
    $contextArgs = @($servers.context7.args) -join " "
    $playwrightArgs = @($servers.playwright.args) -join " "
    if ($contextArgs -notmatch "@upstash/context7-mcp@4\.1\.1") {
        throw "$RelativePath context7 must be pinned to 4.1.1"
    }
    if ($playwrightArgs -notmatch "@playwright/mcp@0\.0\.82") {
        throw "$RelativePath playwright must be pinned to 0.0.82"
    }
    if ($raw -match "@latest") {
        throw "$RelativePath must not use @latest"
    }
}

Assert-Mcp ".cursor/mcp.json" "mcpServers"
Assert-Mcp ".mcp.json" "mcpServers"
Assert-Mcp ".vscode/mcp.json" "servers"

$removed = @(
    "scripts/run_parallel_agents.sh",
    ".claude/agents/backend_engineer.md",
    ".idea/kotlin_ai_autonomous.iml",
    "GEMINI.md",
    "stacks/kotlin/AGENTS.md",
    "stacks/java/AGENTS.md",
    "stacks/react/AGENTS.md"
)
foreach ($relativePath in $removed) {
    if (Test-Path -LiteralPath (Join-Path $root $relativePath)) {
        throw "$relativePath must stay deleted"
    }
}

$kotlinSkill = Get-Content -LiteralPath (Join-Path $root ".agents/skills/kotlin-spring/SKILL.md") -Raw
foreach ($needle in @("runBlocking", "GlobalScope", "MockK", "!!")) {
    if ($kotlinSkill -notmatch [regex]::Escape($needle)) {
        throw "kotlin skill missing $needle"
    }
}

$delivery = Get-Content -LiteralPath (Join-Path $root "scripts/run_delivery.sh") -Raw
if ($delivery -match "claude run") {
    throw "run_delivery.sh must not hardcode claude run"
}
if ($delivery -notmatch "does not launch a model") {
    throw "run_delivery.sh must say it does not launch a model"
}
if ($delivery -match "AI_RUNNER") {
    throw "run_delivery.sh must not require a model runner"
}

$plan = & (Join-Path $root "scripts/run_delivery.ps1") -Task "validate gates"
$planText = $plan -join "`n"
if ($planText -notmatch "Keep existing Kotlin") {
    throw "delivery plan dropped Kotlin"
}

foreach ($doc in @(
    "ai/tickets/ticket_processor.md",
    "ai/refactoring/auto_refactor.md",
    "ai/observability/diagnostics.md",
    "ai/observability/self_healing.md",
    "ai/memory/learning_system.md"
)) {
    $count = (Get-Content -LiteralPath (Join-Path $root $doc)).Count
    if ($count -lt 8) {
        throw "$doc is still a stub"
    }
}

$cacheLines = Get-Content -LiteralPath (Join-Path $root "memory/cache.md")
if ($cacheLines.Count -gt 40) {
    throw "memory/cache.md has $($cacheLines.Count) lines (max 40)"
}

$tokenSkill = Get-Content -LiteralPath (Join-Path $root ".agents/skills/token-economy/SKILL.md") -Raw
foreach ($needle in @("rtk", "memory/cache.md", "prompt cache")) {
    if ($tokenSkill -notmatch [regex]::Escape($needle)) {
        throw "token-economy skill missing $needle"
    }
}

$hooks = Get-Content -LiteralPath (Join-Path $root ".cursor/hooks.json") -Raw
if ($hooks -notmatch "rtk-rewrite.ps1") {
    throw ".cursor/hooks.json must call the RTK rewrite hook"
}

function Invoke-Hook([string]$Payload) {
    $hook = Join-Path $root ".cursor/hooks/rtk-rewrite.ps1"
    $start = New-Object System.Diagnostics.ProcessStartInfo
    $start.FileName = "powershell"
    $start.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$hook`""
    $start.RedirectStandardInput = $true
    $start.RedirectStandardOutput = $true
    $start.RedirectStandardError = $true
    $start.UseShellExecute = $false
    $start.CreateNoWindow = $true
    $process = [System.Diagnostics.Process]::Start($start)
    $process.StandardInput.Write($Payload)
    $process.StandardInput.Close()
    $output = $process.StandardOutput.ReadToEnd()
    $process.WaitForExit()
    if ($process.ExitCode -ne 0) {
        throw "RTK hook exited $($process.ExitCode)"
    }
    return $output.Trim()
}

$missing = Invoke-Hook '{"tool_name":"Shell","tool_input":{"command":"git status"}}'
if ($missing -ne "{}") {
    $parsed = $missing | ConvertFrom-Json
    if ($parsed.permission -ne "allow" -or -not $parsed.updated_input.command) {
        throw "RTK hook must pass through or return a rewritten command"
    }
}
$already = Invoke-Hook '{"tool_name":"Shell","tool_input":{"command":"rtk git status"}}'
if ($already -ne "{}") {
    throw "RTK hook must not wrap a command that already starts with rtk"
}

Write-Output "Framework validation passed."
