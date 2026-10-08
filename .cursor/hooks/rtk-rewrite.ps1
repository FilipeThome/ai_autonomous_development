# Preserve every tool_input field. Replace only command. Fail open when RTK is absent or its rewrite is not a single line.
$ErrorActionPreference = "Continue"

function Exit-Pass {
    Write-Output "{}"
    exit 0
}

$raw = [Console]::In.ReadToEnd()
if ([string]::IsNullOrWhiteSpace($raw)) {
    Exit-Pass
}

try {
    $payload = $raw | ConvertFrom-Json
} catch {
    Exit-Pass
}

$cmd = $null
if ($payload.tool_input -and $payload.tool_input.command) {
    $cmd = [string]$payload.tool_input.command
} elseif ($payload.command) {
    $cmd = [string]$payload.command
}

if ([string]::IsNullOrWhiteSpace($cmd)) {
    Exit-Pass
}

$trimmed = $cmd.Trim()
if ($trimmed -match "^(?i)rtk(\s|$)") {
    Exit-Pass
}

$rtkPath = Join-Path $env:USERPROFILE ".local\bin\rtk.exe"
if (-not (Test-Path -LiteralPath $rtkPath)) {
    $rtkCmd = Get-Command rtk -ErrorAction SilentlyContinue
    if (-not $rtkCmd) {
        Exit-Pass
    }
    $rtkPath = $rtkCmd.Source
}

$rewritten = & $rtkPath rewrite $trimmed 2>$null
if ($rewritten -is [System.Array]) {
    $rewritten = $rewritten -join "`n"
}
$rewritten = ([string]$rewritten).Trim()
if ([string]::IsNullOrWhiteSpace($rewritten) -or $rewritten -eq $trimmed) {
    Exit-Pass
}
if ($rewritten -match "[\r\n\u0000]") {
    Exit-Pass
}

$updated = [ordered]@{}
if ($payload.tool_input) {
    foreach ($prop in $payload.tool_input.PSObject.Properties) {
        $updated[$prop.Name] = $prop.Value
    }
}
$updated["command"] = $rewritten

@{
    permission = "allow"
    updated_input = $updated
} | ConvertTo-Json -Compress -Depth 8
exit 0
