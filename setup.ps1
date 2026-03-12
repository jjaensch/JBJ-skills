# setup.ps1 - Creates .github/ links for local agent discovery.
# Run once after cloning. Re-run when new agents are added.
# Uses hardlinks - no admin required.
#
# Usage:  powershell -ExecutionPolicy Bypass -File setup.ps1
#    or:  . .\setup.ps1   (dot-source from an existing terminal)

$ErrorActionPreference = "Continue"

if ($PSScriptRoot) { $root = $PSScriptRoot }
else               { $root = (Get-Location).Path }

# --- Agents ---
# Hardlink each .agent.md file into .github/agents/
$agentSource = Join-Path $root "Agents"
$agentTarget = Join-Path (Join-Path $root ".github") "agents"

if (Test-Path $agentSource) {
    New-Item -ItemType Directory -Path $agentTarget -Force | Out-Null

    Get-ChildItem -Path $agentSource -Filter "*.agent.md" | ForEach-Object {
        $link = Join-Path $agentTarget $_.Name
        if (Test-Path $link) {
            Write-Host "  skip (exists): $($_.Name)"
        } else {
            try {
                New-Item -ItemType HardLink -Path $link -Target $_.FullName -ErrorAction Stop | Out-Null
                Write-Host "  linked: $($_.Name)"
            } catch {
                Write-Host "  FAILED: $($_.Name) - $($_.Exception.Message)" -ForegroundColor Red
            }
        }
    }
    Write-Host "Agents done."
} else {
    Write-Host "No Agents/ folder found - skipping."
}

Write-Host "`nSetup complete. .github/ is gitignored and will not be committed."

# --- Skills ---
# Junction each skill folder into .github/skills/
# (Junctions link directories, hardlinks only work on files)
$skillsSource = Join-Path $root "Skills"
$skillsTarget = Join-Path (Join-Path $root ".github") "skills"
if (Test-Path $skillsSource) {
    New-Item -ItemType Directory -Path $skillsTarget -Force | Out-Null

    Get-ChildItem -Path $skillsSource -Directory | ForEach-Object {
        $link = Join-Path $skillsTarget $_.Name
        if (Test-Path $link) {
            Write-Host "  skip (exists): $($_.Name)"
        } else {
            try {
                New-Item -ItemType Junction -Path $link -Target $_.FullName -ErrorAction Stop | Out-Null
                Write-Host "  linked: $($_.Name)"
            } catch {
                Write-Host "  FAILED: $($_.Name) - $($_.Exception.Message)" -ForegroundColor Red
            }
        }
    }
    Write-Host "Skills done."
} else {
    Write-Host "No Skills/ folder found - skipping."
}
