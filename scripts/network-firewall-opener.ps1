#Requires -Version 5.1
#Requires -RunAsAdministrator

<#
.SYNOPSIS
Creates, updates, or removes the Windows Defender Firewall rule for eMule.

.DESCRIPTION
This script is intended to ship inside a release package under `scripts\`.
When `-ExePath` is not supplied, it looks for `..\emule.exe` relative to the
script location. If that file is not present, the script prompts for the full
path to `emule.exe`.
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory = $false)]
    [string]$ExePath,

    [Parameter(Mandatory = $false)]
    [string]$RuleName = 'eMule',

    [switch]$Remove
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

. (Join-Path $PSScriptRoot 'app-emule-support.ps1')

<#
.SYNOPSIS
Reads the program paths associated with existing firewall rules.

.PARAMETER Rules
Firewall rules to inspect.
#>
function Get-RulePrograms {
    param(
        [Parameter(Mandatory = $true)]
        [object[]]$Rules
    )

    $programs = @()
    foreach ($rule in $Rules) {
        $appFilters = Get-NetFirewallApplicationFilter -AssociatedNetFirewallRule $rule -ErrorAction SilentlyContinue
        foreach ($filter in $appFilters) {
            if (-not [string]::IsNullOrWhiteSpace($filter.Program)) {
                $programs += $filter.Program
            }
        }
    }

    return $programs
}

<#
.SYNOPSIS
Resolves the executable path from parameter, release layout, or prompt.
#>
function Resolve-RequestedExecutablePath {
    param(
        [Parameter(Mandatory = $false)]
        [string]$CandidatePath
    )

    $resolvedPath = Resolve-EmuleExecutablePath -ScriptRoot $PSScriptRoot -CandidatePath $CandidatePath
    if (-not [string]::IsNullOrWhiteSpace($resolvedPath)) {
        Write-Host "Using eMule executable '$resolvedPath'."
        return $resolvedPath
    }

    $promptedPath = Read-Host 'Enter the full path to emule.exe'
    if ([string]::IsNullOrWhiteSpace($promptedPath)) {
        throw 'No executable path was provided.'
    }

    return (Get-NormalizedExistingLeafPath -Path $promptedPath)
}

try {
    if ($Remove) {
        $existingRules = @(Get-NetFirewallRule -DisplayName $RuleName -ErrorAction SilentlyContinue)
        if ($existingRules.Count -eq 0) {
            Write-Host "No firewall rule named '$RuleName' exists."
            exit 0
        }

        if ($PSCmdlet.ShouldProcess($RuleName, 'Remove Windows Firewall rule')) {
            $existingRules | Remove-NetFirewallRule
            Write-Host "Removed firewall rule '$RuleName'."
        }

        exit 0
    }

    $resolvedExePath = Resolve-RequestedExecutablePath -CandidatePath $ExePath

    $existingRules = @(Get-NetFirewallRule -DisplayName $RuleName -ErrorAction SilentlyContinue)
    $existingPrograms = @()
    $firewallRuleChanged = $false
    if ($existingRules.Count -gt 0) {
        $existingPrograms = @(Get-RulePrograms -Rules $existingRules)
        if ($PSCmdlet.ShouldProcess($RuleName, 'Replace existing Windows Firewall rule')) {
            $existingRules | Remove-NetFirewallRule
        }
    }

    if ($PSCmdlet.ShouldProcess($resolvedExePath, 'Create Windows Firewall allow rule for eMule')) {
        New-NetFirewallRule `
            -DisplayName $RuleName `
            -Direction Inbound `
            -Action Allow `
            -Enabled True `
            -Profile Any `
            -Program $resolvedExePath | Out-Null
        $firewallRuleChanged = $true
    }

    if ($firewallRuleChanged) {
        if ($existingPrograms.Count -eq 0) {
            Write-Host "Created firewall rule '$RuleName' for '$resolvedExePath'."
        } else {
            Write-Host "Replaced firewall rule '$RuleName' for '$resolvedExePath'."
            Write-Host "Previous rule program paths: $($existingPrograms -join ', ')"
        }
    }
} catch {
    Write-Error $_
    exit 1
}
