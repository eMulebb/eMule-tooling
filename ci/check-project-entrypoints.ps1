#Requires -Version 7.6
[CmdletBinding()]
param(
    [string]$EmuleWorkspaceRoot
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $false

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

function Assert-PathMissing([string]$PathToCheck) {
    if (Test-Path -LiteralPath $PathToCheck) {
        throw "Obsolete project entrypoint still exists: $PathToCheck"
    }
}

function Assert-FileContains([string]$PathToCheck, [string]$Pattern, [string]$Reason) {
    if (-not (Test-Path -LiteralPath $PathToCheck -PathType Leaf)) {
        throw "Required file is missing: $PathToCheck"
    }

    if (-not (Select-String -LiteralPath $PathToCheck -Pattern $Pattern -Quiet)) {
        throw $Reason
    }
}

function Assert-FileNotContains([string]$PathToCheck, [string]$Pattern, [string]$Reason) {
    if (-not (Test-Path -LiteralPath $PathToCheck -PathType Leaf)) {
        throw "Required file is missing: $PathToCheck"
    }

    if (Select-String -LiteralPath $PathToCheck -Pattern $Pattern -Quiet) {
        throw $Reason
    }
}

foreach ($variantRelativeRoot in @(
    'workspaces\v0.72a\app\eMule-main',
    'workspaces\v0.72a\app\eMule-v0.72a-community',
    'workspaces\v0.72a\app\eMule-v0.72a-broadband',
    'workspaces\v0.72a\app\eMule-v0.72a-tracing-harness-community'
)) {
    $appRoot = Resolve-WorkspacePath $variantRelativeRoot
    Assert-PathMissing (Join-Path $appRoot 'srchybrid\emule.sln')
    Assert-PathMissing (Join-Path $appRoot 'srchybrid\emule.slnx')
}

$buildPythonProject = Resolve-WorkspacePath 'repos\eMule-build\pyproject.toml'
$buildPythonCli = Resolve-WorkspacePath 'repos\eMule-build\emule_workspace\cli.py'
$buildPythonBuild = Resolve-WorkspacePath 'repos\eMule-build\emule_workspace\build.py'
Assert-FileContains $buildPythonProject 'emule-workspace' 'eMule-build must expose the Python-first emule_workspace orchestration package.'
Assert-FileContains $buildPythonCli 'test python' 'emule_workspace CLI must include the migrated Python test command surface.'
Assert-FileContains $buildPythonCli 'package-release' 'emule_workspace CLI must include the migrated release package command surface.'
Assert-FileContains $buildPythonBuild 'srchybrid.*emule\.vcxproj' 'emule_workspace must build the app through srchybrid\emule.vcxproj.'
Assert-FileNotContains $buildPythonBuild 'emule\.slnx?' 'emule_workspace must not rely on emule.sln or emule.slnx.'
Assert-PathMissing (Resolve-WorkspacePath ('repos\eMule-build\' + 'workspace' + '.ps1'))

foreach ($activeDocPath in @(
    (Resolve-WorkspacePath 'repos\eMule-build\README.md'),
    (Resolve-WorkspacePath 'repos\eMule-build-tests\README.md'),
    (Resolve-WorkspacePath 'repos\eMule-tooling\README.md'),
    (Resolve-WorkspacePath 'repos\eMule-tooling\AGENTS.md'),
    (Resolve-WorkspacePath 'repos\eMule-tooling\docs\WORKSPACE_POLICY.md')
)) {
    Assert-FileNotContains $activeDocPath 'emule\.slnx?' "$activeDocPath must not describe emule.sln or emule.slnx as active build entrypoints."
    Assert-FileNotContains `
        $activeDocPath `
        '(?i)(^|\s|`|&)(?:&\s*)?msbuild(?:\.exe)?\s+(?:[./\\\w:-]+\.vcxproj|[./\\\w:-]+\.slnx?|/t:|/p:|-t:|-p:)' `
        "$activeDocPath must not document direct MSBuild command lines as active build entrypoints; use repos\eMule-build orchestration."
}

Write-Host 'Project entrypoint audit passed.'
