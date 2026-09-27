param(
    [switch]$Apply
)

$ErrorActionPreference = "Stop"

$rtk = Get-Command rtk -ErrorAction SilentlyContinue
if (-not $rtk) {
    Write-Output "rtk is not on PATH."
    Write-Output "Install Rust Token Killer from https://github.com/rtk-ai/rtk (Windows zip: rtk-x86_64-pc-windows-msvc.zip)."
    Write-Output "Confirm with: rtk gain"
    Write-Output "The project hook already no-ops until that command exists."
    if ($Apply) { exit 1 }
    exit 0
}

Write-Output "rtk: $($rtk.Source)"
& $rtk.Source --version
if ($Apply) {
    & $rtk.Source init --agent cursor
    & $rtk.Source init
    Write-Output "Official RTK init finished. Restart the coding agent."
} else {
    Write-Output "Hook already in .cursor/hooks.json. Pass -Apply to run rtk init for this project."
}
