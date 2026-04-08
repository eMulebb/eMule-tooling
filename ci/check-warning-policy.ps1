#Requires -Version 7.2
[CmdletBinding()]
param(
    [string]$EmuleWorkspaceRoot
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($EmuleWorkspaceRoot)) {
    if (-not [string]::IsNullOrWhiteSpace($env:EMULE_WORKSPACE_ROOT)) {
        $EmuleWorkspaceRoot = $env:EMULE_WORKSPACE_ROOT
    } else {
        throw 'EMULE_WORKSPACE_ROOT or -EmuleWorkspaceRoot is required.'
    }
}

$EmuleWorkspaceRoot = [System.IO.Path]::GetFullPath($EmuleWorkspaceRoot)

function Resolve-WorkspacePath([string]$RelativePath) {
    [System.IO.Path]::GetFullPath((Join-Path $EmuleWorkspaceRoot $RelativePath))
}

function Get-ProjectText([string]$RelativePath) {
    $path = Resolve-WorkspacePath $RelativePath
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        throw "Required project file not found: $path"
    }

    [pscustomobject]@{
        Path = $path
        Text = Get-Content -Raw -LiteralPath $path
    }
}

function Assert-Contains([string]$Path, [string]$Text, [string]$Pattern, [string]$Reason) {
    if ($Text -notmatch $Pattern) {
        throw "${Path}: $Reason"
    }
}

function Assert-NotContains([string]$Path, [string]$Text, [string]$Pattern, [string]$Reason) {
    if ($Text -match $Pattern) {
        throw "${Path}: $Reason"
    }
}

$cryptoppProject = Get-ProjectText 'repos\third_party\eMule-cryptopp\cryptlib.vcxproj'
Assert-Contains $cryptoppProject.Path $cryptoppProject.Text '_SILENCE_STDEXT_ARR_ITERS_DEPRECATION_WARNING' 'Crypto++ must keep the narrow checked-iterator suppression.'
Assert-NotContains $cryptoppProject.Path $cryptoppProject.Text '(?i)DisableSpecificWarnings[^<]*4996' 'Do not blanket-disable C4996 in Crypto++ project settings.'
Assert-NotContains $cryptoppProject.Path $cryptoppProject.Text '(?i)/wd4996' 'Do not inject /wd4996 into Crypto++ build flags.'

$miniupnpProject = Get-ProjectText 'repos\third_party\eMule-miniupnp\miniupnpc\msvc\miniupnpc.vcxproj'
Assert-Contains $miniupnpProject.Path $miniupnpProject.Text '_WINSOCK_DEPRECATED_NO_WARNINGS' 'miniupnp must keep the Winsock-specific deprecation suppression.'
Assert-NotContains $miniupnpProject.Path $miniupnpProject.Text '(?i)DisableSpecificWarnings[^<]*4996' 'Do not blanket-disable C4996 in miniupnp project settings.'
Assert-NotContains $miniupnpProject.Path $miniupnpProject.Text '(?i)/wd4996' 'Do not inject /wd4996 into miniupnp build flags.'

foreach ($relativeProject in @(
    'workspaces\v0.72a\app\eMule-main\srchybrid\emule.vcxproj',
    'repos\eMule-build-tests\emule-tests.vcxproj',
    'repos\third_party\eMule-id3lib\libprj\id3lib.vcxproj',
    'repos\third_party\eMule-ResizableLib\ResizableLib\ResizableLib.vcxproj'
)) {
    $project = Get-ProjectText $relativeProject
    Assert-NotContains $project.Path $project.Text '(?i)DisableSpecificWarnings[^<]*4996' 'Do not blanket-disable C4996 in active project settings.'
    Assert-NotContains $project.Path $project.Text '(?i)/wd4996' 'Do not inject /wd4996 into active build flags.'
}

Write-Host 'Warning policy audit passed.'
