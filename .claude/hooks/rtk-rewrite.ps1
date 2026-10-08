# Fail open when RTK is absent. Otherwise let the installed binary speak Claude's hook protocol.
$ErrorActionPreference = "Continue"

$rtkPath = Join-Path $env:USERPROFILE ".local\bin\rtk.exe"
if (-not (Test-Path -LiteralPath $rtkPath)) {
    $rtkCmd = Get-Command rtk -ErrorAction SilentlyContinue
    if (-not $rtkCmd) {
        Write-Output "{}"
        exit 0
    }
    $rtkPath = $rtkCmd.Source
}

$raw = [Console]::In.ReadToEnd()
if ([string]::IsNullOrWhiteSpace($raw)) {
    Write-Output "{}"
    exit 0
}

$raw | & $rtkPath hook claude
exit 0
