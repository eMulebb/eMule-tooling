#Requires -Version 5.1

<#
.SYNOPSIS
Provides shared helper functions for release-facing eMule scripts.

.DESCRIPTION
This file centralizes path discovery, preferences.ini editing, network adapter
resolution, and config backup helpers used by the scripts shipped alongside
eMule releases.
#>

Set-StrictMode -Version Latest

<#
.SYNOPSIS
Returns the normalized full path for an existing file.

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
Returns the normalized full path for a directory.

.PARAMETER Path
Directory path to validate and normalize.

.PARAMETER MustExist
Requires the directory to exist.
#>
function Get-NormalizedDirectoryPath {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path,

        [switch]$MustExist
    )

    if ([string]::IsNullOrWhiteSpace($Path)) {
        throw 'Directory path must not be empty.'
    }

    if ($MustExist) {
        $resolvedPath = Resolve-Path -LiteralPath $Path -ErrorAction Stop
        $fullPath = [System.IO.Path]::GetFullPath($resolvedPath.ProviderPath)
        if (-not (Test-Path -LiteralPath $fullPath -PathType Container)) {
            throw "Directory path '$fullPath' does not exist."
        }

        return $fullPath
    }

    if (Test-Path -LiteralPath $Path) {
        $resolvedPath = Resolve-Path -LiteralPath $Path -ErrorAction Stop
        $fullPath = [System.IO.Path]::GetFullPath($resolvedPath.ProviderPath)
        if (-not (Test-Path -LiteralPath $fullPath -PathType Container)) {
            throw "Directory path '$fullPath' is not a directory."
        }

        return $fullPath
    }

    return [System.IO.Path]::GetFullPath($Path)
}

<#
.SYNOPSIS
Returns the default release root for a script in the scripts directory.

.PARAMETER ScriptRoot
Directory that contains the current script.
#>
function Get-EmuleReleaseRootPath {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ScriptRoot
    )

    return [System.IO.Path]::GetFullPath((Join-Path $ScriptRoot '..'))
}

<#
.SYNOPSIS
Returns the default emule.exe path for a release package.

.PARAMETER ScriptRoot
Directory that contains the current script.
#>
function Get-DefaultEmuleExecutablePath {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ScriptRoot
    )

    $candidatePath = Join-Path (Get-EmuleReleaseRootPath -ScriptRoot $ScriptRoot) 'emule.exe'
    if (Test-Path -LiteralPath $candidatePath -PathType Leaf) {
        return (Get-NormalizedExistingLeafPath -Path $candidatePath)
    }

    return $null
}

<#
.SYNOPSIS
Resolves emule.exe from an explicit path or the release layout.

.PARAMETER ScriptRoot
Directory that contains the current script.

.PARAMETER CandidatePath
Optional explicit emule.exe path.
#>
function Resolve-EmuleExecutablePath {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ScriptRoot,

        [Parameter(Mandatory = $false)]
        [string]$CandidatePath
    )

    if (-not [string]::IsNullOrWhiteSpace($CandidatePath)) {
        return (Get-NormalizedExistingLeafPath -Path $CandidatePath)
    }

    $defaultPath = Get-DefaultEmuleExecutablePath -ScriptRoot $ScriptRoot
    if (-not [string]::IsNullOrWhiteSpace($defaultPath)) {
        return $defaultPath
    }

    return $null
}

<#
.SYNOPSIS
Returns default candidate config directories for the current machine.

.PARAMETER ScriptRoot
Directory that contains the current script.
#>
function Get-DefaultEmuleConfigDirectoryCandidates {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ScriptRoot
    )

    $releaseRoot = Get-EmuleReleaseRootPath -ScriptRoot $ScriptRoot
    $candidates = @()

    if (-not [string]::IsNullOrWhiteSpace($env:LOCALAPPDATA)) {
        $candidates += (Join-Path $env:LOCALAPPDATA 'eMule\config')
    }

    $candidates += (Join-Path $releaseRoot 'config')

    return @($candidates | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | ForEach-Object {
        [System.IO.Path]::GetFullPath($_)
    } | Select-Object -Unique)
}

<#
.SYNOPSIS
Resolves the eMule config directory from an explicit path or release defaults.

.PARAMETER ScriptRoot
Directory that contains the current script.

.PARAMETER CandidatePath
Optional explicit config directory path.

.PARAMETER MustExist
Requires the config directory to exist.
#>
function Resolve-EmuleConfigDirectoryPath {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ScriptRoot,

        [Parameter(Mandatory = $false)]
        [string]$CandidatePath,

        [switch]$MustExist
    )

    if (-not [string]::IsNullOrWhiteSpace($CandidatePath)) {
        return (Get-NormalizedDirectoryPath -Path $CandidatePath -MustExist:$MustExist)
    }

    foreach ($candidate in (Get-DefaultEmuleConfigDirectoryCandidates -ScriptRoot $ScriptRoot)) {
        if (Test-Path -LiteralPath $candidate -PathType Container) {
            return (Get-NormalizedDirectoryPath -Path $candidate -MustExist)
        }
    }

    if ($MustExist) {
        throw 'Could not find an existing eMule config directory. Pass -ConfigDirectory explicitly.'
    }

    return $null
}

<#
.SYNOPSIS
Resolves preferences.ini from an explicit path, config directory, or defaults.

.PARAMETER ScriptRoot
Directory that contains the current script.

.PARAMETER CandidatePath
Optional explicit preferences.ini path.

.PARAMETER ConfigDirectory
Optional resolved config directory.

.PARAMETER MustExist
Requires preferences.ini to exist.
#>
function Resolve-EmulePreferencesIniPath {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ScriptRoot,

        [Parameter(Mandatory = $false)]
        [string]$CandidatePath,

        [Parameter(Mandatory = $false)]
        [string]$ConfigDirectory,

        [switch]$MustExist
    )

    if (-not [string]::IsNullOrWhiteSpace($CandidatePath)) {
        return (Get-NormalizedExistingLeafPath -Path $CandidatePath)
    }

    $candidateDirectories = @()
    if (-not [string]::IsNullOrWhiteSpace($ConfigDirectory)) {
        $candidateDirectories += $ConfigDirectory
    } else {
        $candidateDirectories += (Get-DefaultEmuleConfigDirectoryCandidates -ScriptRoot $ScriptRoot)
    }

    foreach ($candidateDirectory in $candidateDirectories) {
        $candidatePathFromDirectory = Join-Path $candidateDirectory 'preferences.ini'
        if (Test-Path -LiteralPath $candidatePathFromDirectory -PathType Leaf) {
            return (Get-NormalizedExistingLeafPath -Path $candidatePathFromDirectory)
        }
    }

    if ($MustExist) {
        throw 'Could not find preferences.ini. Pass -PreferencesIniPath or -ConfigDirectory explicitly.'
    }

    return $null
}

<#
.SYNOPSIS
Reads preferences.ini using its current encoding.

.PARAMETER Path
Full path to preferences.ini.
#>
function Get-TextFileState {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    $fullPath = Get-NormalizedExistingLeafPath -Path $Path
    $bytes = [System.IO.File]::ReadAllBytes($fullPath)

    $encoding = $null
    $offset = 0
    if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
        $encoding = [System.Text.UTF8Encoding]::new($true)
        $offset = 3
    } elseif ($bytes.Length -ge 2 -and $bytes[0] -eq 0xFF -and $bytes[1] -eq 0xFE) {
        $encoding = [System.Text.UnicodeEncoding]::new($false, $true)
        $offset = 2
    } elseif ($bytes.Length -ge 2 -and $bytes[0] -eq 0xFE -and $bytes[1] -eq 0xFF) {
        $encoding = [System.Text.UnicodeEncoding]::new($true, $true)
        $offset = 2
    } else {
        $encoding = [System.Text.Encoding]::Default
    }

    $text = $encoding.GetString($bytes, $offset, $bytes.Length - $offset)
    $newLine = "`r`n"
    if ($text.Contains("`r`n")) {
        $newLine = "`r`n"
    } elseif ($text.Contains("`n")) {
        $newLine = "`n"
    } elseif ($text.Contains("`r")) {
        $newLine = "`r"
    }

    return [pscustomobject]@{
        Path = $fullPath
        Text = $text
        Encoding = $encoding
        NewLine = $newLine
        HasTrailingNewLine = ($text.Length -gt 0 -and ($text.EndsWith("`r`n") -or $text.EndsWith("`n") -or $text.EndsWith("`r")))
    }
}

<#
.SYNOPSIS
Writes text back to a file using the preserved encoding.

.PARAMETER FileState
Object returned by Get-TextFileState.

.PARAMETER Text
Updated text content.
#>
function Set-TextFileState {
    param(
        [Parameter(Mandatory = $true)]
        [pscustomobject]$FileState,

        [Parameter(Mandatory = $true)]
        [string]$Text
    )

    $encoding = $FileState.Encoding
    $bytes = $encoding.GetBytes($Text)
    if ($encoding -is [System.Text.UTF8Encoding] -and $encoding.GetPreamble().Length -gt 0) {
        $bytes = $encoding.GetPreamble() + $bytes
    } elseif ($encoding -is [System.Text.UnicodeEncoding] -and $encoding.GetPreamble().Length -gt 0) {
        $bytes = $encoding.GetPreamble() + $bytes
    }

    [System.IO.File]::WriteAllBytes($FileState.Path, $bytes)
}

<#
.SYNOPSIS
Reads simple key=value pairs from preferences.ini.

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
Sets or adds a key=value entry in an INI section while preserving surrounding text.

.PARAMETER PreferencesPath
Full path to preferences.ini.

.PARAMETER SectionName
INI section name.

.PARAMETER Key
Key to update or insert.

.PARAMETER Value
Value to write.
#>
function Set-IniKeyValue {
    param(
        [Parameter(Mandatory = $true)]
        [string]$PreferencesPath,

        [Parameter(Mandatory = $true)]
        [string]$SectionName,

        [Parameter(Mandatory = $true)]
        [string]$Key,

        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [string]$Value
    )

    $fileState = Get-TextFileState -Path $PreferencesPath
    $lines = @()
    if ($fileState.Text.Length -gt 0) {
        $lines = @($fileState.Text -split '\r\n|\n|\r', 0)
    }

    $sectionHeader = "[$SectionName]"
    $sectionIndex = -1
    $sectionEndIndex = $lines.Count
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i].Trim() -eq $sectionHeader) {
            $sectionIndex = $i
            for ($j = $i + 1; $j -lt $lines.Count; $j++) {
                if ($lines[$j].Trim().StartsWith('[')) {
                    $sectionEndIndex = $j
                    break
                }
            }

            break
        }
    }

    if ($sectionIndex -lt 0) {
        if ($lines.Count -gt 0 -and -not [string]::IsNullOrWhiteSpace($lines[$lines.Count - 1])) {
            $lines += ''
        }

        $lines += $sectionHeader
        $lines += ('{0}={1}' -f $Key, $Value)
    } else {
        $updated = $false
        for ($i = $sectionIndex + 1; $i -lt $sectionEndIndex; $i++) {
            $currentLine = $lines[$i]
            $separatorIndex = $currentLine.IndexOf('=')
            if ($separatorIndex -lt 1) {
                continue
            }

            $currentName = $currentLine.Substring(0, $separatorIndex).Trim()
            if ($currentName -ceq $Key) {
                $lines[$i] = ('{0}={1}' -f $Key, $Value)
                $updated = $true
                break
            }
        }

        if (-not $updated) {
            $before = @()
            $after = @()
            if ($sectionEndIndex -gt 0) {
                $before = @($lines[0..($sectionEndIndex - 1)])
            }
            if ($sectionEndIndex -lt $lines.Count) {
                $after = @($lines[$sectionEndIndex..($lines.Count - 1)])
            }

            $lines = @($before + ('{0}={1}' -f $Key, $Value) + $after)
        }
    }

    $text = [string]::Join($fileState.NewLine, $lines)
    if ($fileState.HasTrailingNewLine -or $lines.Count -gt 0) {
        $text += $fileState.NewLine
    }

    Set-TextFileState -FileState $fileState -Text $text
}

<#
.SYNOPSIS
Returns the first adapter that matches a supplied interface name.

.PARAMETER InterfaceName
Display name or alias to match.
#>
function Resolve-EmuleNetworkAdapter {
    param(
        [Parameter(Mandatory = $true)]
        [string]$InterfaceName
    )

    if ([string]::IsNullOrWhiteSpace($InterfaceName)) {
        throw 'Interface name must not be empty.'
    }

    $adapters = @(Get-NetAdapter -ErrorAction Stop)
    $matches = @($adapters | Where-Object {
        ($_.InterfaceAlias -eq $InterfaceName) -or ($_.Name -eq $InterfaceName)
    })

    if ($matches.Count -eq 0) {
        throw "No network adapter matched interface name '$InterfaceName'."
    }

    if ($matches.Count -gt 1) {
        $names = @($matches | ForEach-Object {
            if (-not [string]::IsNullOrWhiteSpace($_.InterfaceAlias)) {
                return $_.InterfaceAlias
            }

            return $_.Name
        })
        throw ("Interface name '{0}' matched multiple adapters: {1}" -f $InterfaceName, ($names -join ', '))
    }

    return $matches[0]
}

<#
.SYNOPSIS
Returns the preferred IPv4 address for a resolved network adapter.

.PARAMETER Adapter
Adapter returned by Resolve-EmuleNetworkAdapter.
#>
function Get-PreferredAdapterIPv4Address {
    param(
        [Parameter(Mandatory = $true)]
        [object]$Adapter
    )

    $ipAddresses = @(Get-NetIPAddress -InterfaceIndex $Adapter.ifIndex -AddressFamily IPv4 -ErrorAction Stop | Where-Object {
        (-not [string]::IsNullOrWhiteSpace($_.IPAddress)) -and
        ($_.IPAddress -ne '0.0.0.0') -and
        (-not $_.IPAddress.StartsWith('169.254.'))
    })

    if ($ipAddresses.Count -eq 0) {
        throw "Network adapter '$($Adapter.InterfaceAlias)' has no usable IPv4 address."
    }

    $selectedAddress = $ipAddresses |
        Sort-Object `
            @{ Expression = { if ($_.SkipAsSource) { 1 } else { 0 } } }, `
            @{ Expression = { if ($_.AddressState -eq 'Preferred') { 0 } else { 1 } } }, `
            @{ Expression = { $_.IPAddress } } |
        Select-Object -First 1

    return $selectedAddress.IPAddress
}

<#
.SYNOPSIS
Creates or replaces a dated zip archive of a directory.

.PARAMETER SourceDirectory
Directory to archive.

.PARAMETER DestinationDirectory
Directory that will receive the zip archive.

.PARAMETER ArchiveName
Zip file name to create.
#>
function New-ZipArchiveFromDirectory {
    param(
        [Parameter(Mandatory = $true)]
        [string]$SourceDirectory,

        [Parameter(Mandatory = $true)]
        [string]$DestinationDirectory,

        [Parameter(Mandatory = $true)]
        [string]$ArchiveName
    )

    Add-Type -AssemblyName System.IO.Compression.FileSystem

    $resolvedSourceDirectory = Get-NormalizedDirectoryPath -Path $SourceDirectory -MustExist
    $resolvedDestinationDirectory = Get-NormalizedDirectoryPath -Path $DestinationDirectory

    if (-not (Test-Path -LiteralPath $resolvedDestinationDirectory -PathType Container)) {
        New-Item -ItemType Directory -Path $resolvedDestinationDirectory -Force | Out-Null
    }

    $archivePath = Join-Path $resolvedDestinationDirectory $ArchiveName
    $temporaryArchivePath = Join-Path $resolvedDestinationDirectory ('{0}.tmp' -f [System.Guid]::NewGuid().ToString('N'))

    try {
        [System.IO.Compression.ZipFile]::CreateFromDirectory(
            $resolvedSourceDirectory,
            $temporaryArchivePath,
            [System.IO.Compression.CompressionLevel]::Optimal,
            $true
        )

        if (Test-Path -LiteralPath $archivePath -PathType Leaf) {
            Remove-Item -LiteralPath $archivePath -Force
        }

        Move-Item -LiteralPath $temporaryArchivePath -Destination $archivePath -Force
    } catch {
        if (Test-Path -LiteralPath $temporaryArchivePath) {
            Remove-Item -LiteralPath $temporaryArchivePath -Force -ErrorAction SilentlyContinue
        }

        throw
    }

    return (Get-NormalizedExistingLeafPath -Path $archivePath)
}
