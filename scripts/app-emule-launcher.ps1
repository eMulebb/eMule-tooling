#Requires -Version 5.1

<#
.SYNOPSIS
Creates a dated config backup archive and launches eMule with an explicit config root.

.DESCRIPTION
This script is intended to ship inside a release package under `scripts\`.
It resolves `emule.exe`, backs up the chosen config directory into
`config-YYYY-MM-DD.zip`, and launches `emule.exe -c <configDir>`.

Defaults:
- `emule.exe`: `..\emule.exe`
- config directory: `%LOCALAPPDATA%\eMule\config`, then `..\config`
- backup destination: the parent directory of the resolved config directory
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$ExePath,

    [Parameter(Mandatory = $false)]
    [string]$ConfigDirectory,

    [Parameter(Mandatory = $false)]
    [string]$BackupDestinationDirectory,

    [Parameter(Mandatory = $false, ValueFromRemainingArguments = $true)]
    [string[]]$EmuleArgument = @()
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

. (Join-Path $PSScriptRoot 'app-emule-support.ps1')

try {
    $resolvedExePath = Resolve-EmuleExecutablePath -ScriptRoot $PSScriptRoot -CandidatePath $ExePath
    if ([string]::IsNullOrWhiteSpace($resolvedExePath)) {
        throw 'Could not find emule.exe. Pass -ExePath explicitly or place the launcher in a scripts directory below emule.exe.'
    }

    $resolvedConfigDirectory = Resolve-EmuleConfigDirectoryPath -ScriptRoot $PSScriptRoot -CandidatePath $ConfigDirectory -MustExist
    $resolvedBackupDestinationDirectory = $null
    if (-not [string]::IsNullOrWhiteSpace($BackupDestinationDirectory)) {
        $resolvedBackupDestinationDirectory = Get-NormalizedDirectoryPath -Path $BackupDestinationDirectory
    } else {
        $resolvedBackupDestinationDirectory = Get-NormalizedDirectoryPath -Path (Split-Path -Path $resolvedConfigDirectory -Parent) -MustExist
    }

    $archiveName = 'config-{0}.zip' -f (Get-Date -Format 'yyyy-MM-dd')
    $archivePath = New-ZipArchiveFromDirectory `
        -SourceDirectory $resolvedConfigDirectory `
        -DestinationDirectory $resolvedBackupDestinationDirectory `
        -ArchiveName $archiveName

    $argumentList = @('-c', $resolvedConfigDirectory)
    if ($EmuleArgument.Count -gt 0) {
        $argumentList += $EmuleArgument
    }

    Write-Host "Created config backup '$archivePath'."
    Write-Host "Launching '$resolvedExePath' with config directory '$resolvedConfigDirectory'."
    Start-Process -FilePath $resolvedExePath -ArgumentList $argumentList | Out-Null
} catch {
    Write-Error $_
    exit 1
}
