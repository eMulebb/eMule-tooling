#Requires -Version 5.1
#Requires -RunAsAdministrator

<#
.SYNOPSIS
Creates, updates, or removes Windows Defender Firewall rules for eMule.

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
    [string]$RuleName = 'eMule BB',

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

<#
.SYNOPSIS
Builds the broad program-scoped eMule firewall rules.
#>
function Get-DesiredFirewallRules {
    param(
        [Parameter(Mandatory = $true)]
        [string]$BaseRuleName
    )

    return @(
        [pscustomobject]@{ Name = "$BaseRuleName Inbound TCP"; Direction = 'Inbound'; Protocol = 'TCP' }
        [pscustomobject]@{ Name = "$BaseRuleName Inbound UDP"; Direction = 'Inbound'; Protocol = 'UDP' }
        [pscustomobject]@{ Name = "$BaseRuleName Outbound TCP"; Direction = 'Outbound'; Protocol = 'TCP' }
        [pscustomobject]@{ Name = "$BaseRuleName Outbound UDP"; Direction = 'Outbound'; Protocol = 'UDP' }
    )
}

try {
    $desiredRules = @(Get-DesiredFirewallRules -BaseRuleName $RuleName)

    if ($Remove) {
        $existingRules = @()
        foreach ($rule in $desiredRules) {
            $existingRules += @(Get-NetFirewallRule -DisplayName $rule.Name -ErrorAction SilentlyContinue)
        }

        if ($existingRules.Count -eq 0) {
            Write-Host "No eMule firewall rules with base name '$RuleName' exist."
            exit 0
        }

        if ($PSCmdlet.ShouldProcess($RuleName, 'Remove eMule Windows Firewall rules')) {
            $existingRules | Remove-NetFirewallRule
            Write-Host "Removed $($existingRules.Count) eMule firewall rule(s) with base name '$RuleName'."
        }

        exit 0
    }

    $resolvedExePath = Resolve-RequestedExecutablePath -CandidatePath $ExePath

    Write-Host 'Opening eMule across all ports, all hosts, all interfaces, and all firewall profiles.'
    Write-Host "Program: $resolvedExePath"
    Write-Host "Profiles: Domain, Private, Public"

    foreach ($rule in $desiredRules) {
        $existingRules = @(Get-NetFirewallRule -DisplayName $rule.Name -ErrorAction SilentlyContinue)
        $existingPrograms = @()
        $ruleChanged = $false
        if ($existingRules.Count -gt 0) {
            $existingPrograms = @(Get-RulePrograms -Rules $existingRules)
            if ($PSCmdlet.ShouldProcess($rule.Name, 'Replace exact-name Windows Firewall rule')) {
                $existingRules | Remove-NetFirewallRule
                $ruleChanged = $true
            }
        }

        if ($PSCmdlet.ShouldProcess($resolvedExePath, "Create Windows Firewall allow rule '$($rule.Name)'")) {
            New-NetFirewallRule `
                -DisplayName $rule.Name `
                -Direction $rule.Direction `
                -Action Allow `
                -Enabled True `
                -Profile Domain,Private,Public `
                -Program $resolvedExePath `
                -Protocol $rule.Protocol | Out-Null
            $ruleChanged = $true
        }

        if ($ruleChanged) {
            if ($existingPrograms.Count -eq 0) {
                Write-Host "Created firewall rule '$($rule.Name)' for '$resolvedExePath'."
            } else {
                Write-Host "Replaced firewall rule '$($rule.Name)' for '$resolvedExePath'."
                Write-Host "Previous rule program paths: $($existingPrograms -join ', ')"
            }
        }
    }

    Write-Host 'Windows Firewall rules now allow eMule TCP/UDP inbound and outbound across all ports.'
} catch {
    Write-Error $_
    exit 1
}
