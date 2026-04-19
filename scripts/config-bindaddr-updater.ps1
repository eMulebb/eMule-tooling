#Requires -Version 5.1

<#
.SYNOPSIS
Updates BindAddr in preferences.ini from a network interface name.

.DESCRIPTION
This script is intended to ship inside a release package under `scripts\`.
It resolves a network adapter by interface name, selects the preferred active
IPv4 address on that adapter, and writes that address to `BindAddr` in the
`[eMule]` section of `preferences.ini`.

When config paths are not supplied explicitly, the script looks for:
- `%LOCALAPPDATA%\eMule\config\preferences.ini`
- `..\config\preferences.ini`
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory = $true)]
    [string]$InterfaceName,

    [Parameter(Mandatory = $false)]
    [string]$ConfigDirectory,

    [Parameter(Mandatory = $false)]
    [string]$PreferencesIniPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

. (Join-Path $PSScriptRoot 'app-emule-support.ps1')

try {
    $resolvedPreferencesPath = Resolve-EmulePreferencesIniPath `
        -ScriptRoot $PSScriptRoot `
        -CandidatePath $PreferencesIniPath `
        -ConfigDirectory $ConfigDirectory `
        -MustExist

    $adapter = Resolve-EmuleNetworkAdapter -InterfaceName $InterfaceName
    $resolvedBindAddress = Get-PreferredAdapterIPv4Address -Adapter $adapter
    $currentPreferences = Read-EmulePreferencesMap -PreferencesPath $resolvedPreferencesPath
    $previousBindAddress = ''
    if ($currentPreferences.ContainsKey('BindAddr')) {
        $previousBindAddress = [string]$currentPreferences['BindAddr']
    }

    if ($PSCmdlet.ShouldProcess($resolvedPreferencesPath, ("Set BindAddr to '{0}'" -f $resolvedBindAddress))) {
        Set-IniKeyValue -PreferencesPath $resolvedPreferencesPath -SectionName 'eMule' -Key 'BindAddr' -Value $resolvedBindAddress
        Write-Host "Updated BindAddr to '$resolvedBindAddress' in '$resolvedPreferencesPath'."
        if (-not [string]::IsNullOrWhiteSpace($previousBindAddress)) {
            Write-Host "Previous BindAddr: '$previousBindAddress'."
        }
    }
} catch {
    Write-Error $_
    exit 1
}
