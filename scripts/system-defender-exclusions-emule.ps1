#Requires -Version 5.1
#Requires -RunAsAdministrator

<#
.SYNOPSIS
Creates curated Microsoft Defender exclusions for eMule.

.DESCRIPTION
This script is intended to ship inside a release package under `scripts\`.
It adds only missing exclusions for:
- the selected `emule.exe` process
- the active eMule config directory
- incoming and temp directories from `preferences.ini`
- optional manually supplied shared-root directories

When paths are not supplied explicitly, the script uses release-safe defaults:
- `..\emule.exe` relative to the script location
- `%LOCALAPPDATA%\eMule\config\preferences.ini`
- `..\config\preferences.ini`
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory = $false)]
    [string]$ExePath,

    [Parameter(Mandatory = $false)]
    [string]$ConfigDirectory,

    [Parameter(Mandatory = $false)]
    [string]$PreferencesIniPath,

    [Parameter(Mandatory = $false)]
    [string[]]$SharedRoot = @(),

    [switch]$ListOnly
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

. (Join-Path $PSScriptRoot 'app-emule-support.ps1')

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
Adds a normalized path to the exclusion set if it is not empty.

.PARAMETER Target
Path string to normalize and add.

.PARAMETER Bucket
Hashtable used as a case-insensitive set.
#>
function Add-PathToSet {
    param(
        [Parameter(Mandatory = $false)]
        [string]$Target,

        [Parameter(Mandatory = $true)]
        [hashtable]$Bucket
    )

    if ([string]::IsNullOrWhiteSpace($Target)) {
        return
    }

    $normalized = Get-NormalizedDirectoryPath -Path $Target
    if (-not $Bucket.ContainsKey($normalized)) {
        $Bucket[$normalized] = $true
    }
}

<#
.SYNOPSIS
Builds the curated directory exclusion set from preferences.ini and parameters.

.PARAMETER ResolvedPreferencesPath
Full path to preferences.ini, or $null when not available.

.PARAMETER SharedRoots
Optional manually supplied shared roots.
#>
function Get-CuratedDirectoryExclusions {
    param(
        [Parameter(Mandatory = $false)]
        [AllowNull()]
        [string]$ResolvedPreferencesPath,

        [Parameter(Mandatory = $true)]
        [string[]]$SharedRoots
    )

    $directorySet = @{}

    if (-not [string]::IsNullOrWhiteSpace($ResolvedPreferencesPath)) {
        Add-PathToSet -Target (Split-Path -Path $ResolvedPreferencesPath -Parent) -Bucket $directorySet

        $preferences = Read-EmulePreferencesMap -PreferencesPath $ResolvedPreferencesPath
        foreach ($name in @('IncomingDir', 'TempDir')) {
            if ($preferences.ContainsKey($name)) {
                Add-PathToSet -Target $preferences[$name] -Bucket $directorySet
            }
        }

        if ($preferences.ContainsKey('TempDirs') -and -not [string]::IsNullOrWhiteSpace($preferences['TempDirs'])) {
            foreach ($tempDir in ($preferences['TempDirs'] -split '\|')) {
                Add-PathToSet -Target $tempDir -Bucket $directorySet
            }
        }
    }

    foreach ($sharedRoot in $SharedRoots) {
        Add-PathToSet -Target $sharedRoot -Bucket $directorySet
    }

    return @($directorySet.Keys | Sort-Object)
}

<#
.SYNOPSIS
Returns the current Microsoft Defender preference object.
#>
function Get-DefenderPreference {
    return Get-MpPreference -ErrorAction Stop
}

<#
.SYNOPSIS
Returns the desired exclusion model for the current invocation.
#>
function Get-DesiredExclusionState {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ResolvedExePath,

        [Parameter(Mandatory = $false)]
        [AllowNull()]
        [string]$ResolvedPreferencesPath,

        [Parameter(Mandatory = $true)]
        [string[]]$SharedRoots
    )

    return [pscustomobject]@{
        Processes = @($ResolvedExePath)
        Paths = Get-CuratedDirectoryExclusions -ResolvedPreferencesPath $ResolvedPreferencesPath -SharedRoots $SharedRoots
        PreferencesPath = $ResolvedPreferencesPath
    }
}

try {
    $resolvedExePath = Resolve-RequestedExecutablePath -CandidatePath $ExePath
    $resolvedConfigDirectory = Resolve-EmuleConfigDirectoryPath -ScriptRoot $PSScriptRoot -CandidatePath $ConfigDirectory
    $resolvedPreferencesPath = Resolve-EmulePreferencesIniPath `
        -ScriptRoot $PSScriptRoot `
        -CandidatePath $PreferencesIniPath `
        -ConfigDirectory $resolvedConfigDirectory

    if ([string]::IsNullOrWhiteSpace($resolvedPreferencesPath)) {
        Write-Warning 'No preferences.ini was found. The script will only exclude emule.exe and any manually supplied shared roots.'
    } else {
        Write-Host "Using preferences.ini '$resolvedPreferencesPath'."
    }

    $desired = Get-DesiredExclusionState -ResolvedExePath $resolvedExePath -ResolvedPreferencesPath $resolvedPreferencesPath -SharedRoots $SharedRoot
    $currentPreference = Get-DefenderPreference

    $currentProcesses = @($currentPreference.ExclusionProcess | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
    $currentPaths = @($currentPreference.ExclusionPath | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })

    $missingProcesses = @($desired.Processes | Where-Object { $currentProcesses -notcontains $_ })
    $missingPaths = @($desired.Paths | Where-Object { $currentPaths -notcontains $_ })

    Write-Host 'Planned Microsoft Defender exclusions for eMule:'
    foreach ($processPath in $desired.Processes) {
        Write-Host "  process: $processPath"
    }
    foreach ($directoryPath in $desired.Paths) {
        Write-Host "  path:    $directoryPath"
    }

    if ($ListOnly) {
        exit 0
    }

    foreach ($processPath in $missingProcesses) {
        if ($PSCmdlet.ShouldProcess($processPath, 'Add Microsoft Defender process exclusion')) {
            Add-MpPreference -ExclusionProcess $processPath
            Write-Host "Added process exclusion '$processPath'."
        }
    }

    foreach ($directoryPath in $missingPaths) {
        if ($PSCmdlet.ShouldProcess($directoryPath, 'Add Microsoft Defender path exclusion')) {
            Add-MpPreference -ExclusionPath $directoryPath
            Write-Host "Added path exclusion '$directoryPath'."
        }
    }

    if ($missingProcesses.Count -eq 0 -and $missingPaths.Count -eq 0) {
        Write-Host 'All curated Defender exclusions are already present.'
    }
} catch {
    Write-Error $_
    exit 1
}
