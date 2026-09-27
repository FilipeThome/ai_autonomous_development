param(
    [Parameter(Mandatory = $true)]
    [string]$Task,
    [string]$LogFile = ""
)

$ErrorActionPreference = "Stop"

Write-Output "Delivery plan for: $Task"
Write-Output "Gates are sequential. Start the next gate only after the current one passes."
Write-Output "This script prints the gates. It does not launch a model."

if ($LogFile) {
    Write-Output "0. diagnostics - analyze $LogFile before editing"
}

Write-Output "1. architect - approve boundaries before code, except a small fix inside an existing boundary"
Write-Output "2. implement - kotlin-engineer, java-engineer, or react-engineer. Keep existing Kotlin."
Write-Output "3. test - run the stack test command and return failures to the implementer"
Write-Output "4. review - reject architecture, test, or memory-rule failures"
Write-Output "Done: build succeeds, tests passed, boundaries hold, memory updated when a new pattern appeared."
