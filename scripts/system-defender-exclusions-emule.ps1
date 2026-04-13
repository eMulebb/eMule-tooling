#Requires -Version 5.1
#Requires -RunAsAdministrator

<#
.SYNOPSIS
Creates curated Microsoft Defender exclusions for eMule.

.DESCRIPTION
This script must remain compatible with Windows built-in PowerShell.exe
(Windows PowerShell 5.1) on Windows 10 and Windows 11.

It adds only missing exclusions for:
- the detected emule.exe process
- the active eMule config directory
- incoming and temp directories from preferences.ini
- optional manually supplied shared-root directories

The script is intentionally stateless. It does not remove exclusions and it
does not write a manifest of managed items.
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory = $false)]
    [string]$ExePath,

    [Parameter(Mandatory = $false)]
    [string]$PreferencesIniPath,

    [Parameter(Mandatory = $false)]
    [string[]]$SharedRoot = @(),

    [switch]$ListOnly
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

<#
.SYNOPSIS
Returns the repository root relative to the scripts directory.
#>
function Get-WorkspaceRoot {
    $workspaceRoot = Join-Path $PSScriptRoot '..'
    return [System.IO.Path]::GetFullPath($workspaceRoot)
}

<#
.SYNOPSIS
Returns the normalized full path for an existing file.
.
.PARAMETER Path
Path to validate and normalize.
#>
function Get-NormalizedExistingLeafPath {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    if ([string]::IsNullOrWhiteSpace($Path)) {
        throw 'Path must not be empty.'
    }

    $resolvedPath = Resolve-Path -LiteralPath $Path -ErrorAction Stop
    $fullPath = [System.IO.Path]::GetFullPath($resolvedPath.ProviderPath)
    if (-not (Test-Path -LiteralPath $fullPath -PathType Leaf)) {
        throw "File path '$fullPath' does not exist."
    }

    return $fullPath
}

<#
.SYNOPSIS
Normalizes a directory path whether or not it currently exists.
.
.PARAMETER Path
Directory-like path to normalize.
#>
function Get-NormalizedDirectoryPath {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    if ([string]::IsNullOrWhiteSpace($Path)) {
        throw 'Directory path must not be empty.'
    }

    if (Test-Path -LiteralPath $Path) {
        $resolvedPath = Resolve-Path -LiteralPath $Path -ErrorAction Stop
        return [System.IO.Path]::GetFullPath($resolvedPath.ProviderPath)
    }

    return [System.IO.Path]::GetFullPath($Path)
}

<#
.SYNOPSIS
Finds the preferred emule.exe under the workspace root.
.
.PARAMETER WorkspaceRoot
Repository root used for recursive search.
#>
function Get-DefaultEmuleExecutable {
    param(
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceRoot
    )

    $candidatePaths = @(
        Get-ChildItem -LiteralPath $WorkspaceRoot -Filter 'emule.exe' -File -Recurse -ErrorAction SilentlyContinue |
            Select-Object -ExpandProperty FullName
    ) | ForEach-Object {
        [System.IO.Path]::GetFullPath($_)
    } | Sort-Object -Unique

    if ($candidatePaths.Count -eq 0) {
        return $null
    }

    $preferredPaths = @(
        [System.IO.Path]::GetFullPath((Join-Path $WorkspaceRoot 'workspaces\v0.72a\app\eMule-main\srchybrid\x64\Release\emule.exe')),
        [System.IO.Path]::GetFullPath((Join-Path $WorkspaceRoot 'workspaces\v0.72a\app\eMule-main\srchybrid\x64\Debug\emule.exe'))
    )

    foreach ($preferredPath in $preferredPaths) {
        if ($candidatePaths -contains $preferredPath) {
            return $preferredPath
        }
    }

    return ($candidatePaths | Sort-Object | Select-Object -First 1)
}

<#
.SYNOPSIS
Resolves the executable path from parameter, search result, or prompt.
#>
function Resolve-EmuleExecutablePath {
    param(
        [Parameter(Mandatory = $false)]
        [string]$CandidatePath
    )

    if (-not [string]::IsNullOrWhiteSpace($CandidatePath)) {
        return Get-NormalizedExistingLeafPath -Path $CandidatePath
    }

    $workspaceRoot = Get-WorkspaceRoot
    $defaultExePath = Get-DefaultEmuleExecutable -WorkspaceRoot $workspaceRoot
    if (-not [string]::IsNullOrWhiteSpace($defaultExePath)) {
        Write-Host "Using detected eMule executable '$defaultExePath'."
        return $defaultExePath
    }

    $promptedPath = Read-Host 'Enter the full path to emule.exe'
    if ([string]::IsNullOrWhiteSpace($promptedPath)) {
        throw 'No executable path was provided.'
    }

    return Get-NormalizedExistingLeafPath -Path $promptedPath
}

<#
.SYNOPSIS
Returns candidate preferences.ini paths for the current machine and build layout.
.
.PARAMETER ResolvedExePath
Detected eMule executable path.
#>
function Get-DefaultPreferencesIniCandidates {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ResolvedExePath
    )

    $exeDirectory = Split-Path -Path $ResolvedExePath -Parent
    return @(
        (Join-Path $env:LOCALAPPDATA 'eMule\config\preferences.ini'),
        (Join-Path $env:ProgramData 'eMule\config\preferences.ini'),
        (Join-Path $exeDirectory 'config\preferences.ini')
    ) | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | ForEach-Object {
        [System.IO.Path]::GetFullPath($_)
    } | Select-Object -Unique
}

<#
.SYNOPSIS
Resolves the active preferences.ini path when available.
.
.PARAMETER CandidatePath
Optional explicit preferences.ini path.
.
.PARAMETER ResolvedExePath
Detected eMule executable path.
#>
function Resolve-PreferencesIniPath {
    param(
        [Parameter(Mandatory = $false)]
        [string]$CandidatePath,

        [Parameter(Mandatory = $true)]
        [string]$ResolvedExePath
    )

    if (-not [string]::IsNullOrWhiteSpace($CandidatePath)) {
        return Get-NormalizedExistingLeafPath -Path $CandidatePath
    }

    foreach ($preferencesPath in (Get-DefaultPreferencesIniCandidates -ResolvedExePath $ResolvedExePath)) {
        if (Test-Path -LiteralPath $preferencesPath -PathType Leaf) {
            Write-Host "Using detected preferences.ini '$preferencesPath'."
            return (Get-NormalizedExistingLeafPath -Path $preferencesPath)
        }
    }

    return $null
}

<#
.SYNOPSIS
Reads simple eMule key=value pairs from preferences.ini.
.
.PARAMETER PreferencesPath
Full path to preferences.ini.
#>
function Read-EmulePreferencesMap {
    param(
        [Parameter(Mandatory = $true)]
        [string]$PreferencesPath
    )

    $values = @{}
    foreach ($line in (Get-Content -LiteralPath $PreferencesPath -ErrorAction Stop)) {
        if ([string]::IsNullOrWhiteSpace($line)) {
            continue
        }

        if ($line.StartsWith('[')) {
            continue
        }

        $separatorIndex = $line.IndexOf('=')
        if ($separatorIndex -lt 1) {
            continue
        }

        $name = $line.Substring(0, $separatorIndex).Trim()
        $value = $line.Substring($separatorIndex + 1)
        if (-not [string]::IsNullOrWhiteSpace($name)) {
            $values[$name] = $value
        }
    }

    return $values
}

<#
.SYNOPSIS
Adds a normalized path to the exclusion set if it is not empty.
.
.PARAMETER Target
Path string to normalize and add.
.
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
.
.PARAMETER ResolvedPreferencesPath
Full path to preferences.ini, or $null when not available.
.
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
    $resolvedExePath = Resolve-EmuleExecutablePath -CandidatePath $ExePath
    $resolvedPreferencesPath = Resolve-PreferencesIniPath -CandidatePath $PreferencesIniPath -ResolvedExePath $resolvedExePath
    if ([string]::IsNullOrWhiteSpace($resolvedPreferencesPath)) {
        Write-Warning 'No preferences.ini was found. The script will only exclude emule.exe and any manually supplied shared roots.'
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
