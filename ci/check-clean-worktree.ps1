#Requires -Version 7.6
[CmdletBinding()]
param(
    [string]$EmuleWorkspaceRoot,

    [string]$SetupRepoRoot = ''
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

if (-not [string]::IsNullOrWhiteSpace($SetupRepoRoot)) {
    $SetupRepoRoot = [System.IO.Path]::GetFullPath($SetupRepoRoot)
}

function Resolve-WorkspacePath([string]$RelativePath) {
    [System.IO.Path]::GetFullPath((Join-Path $EmuleWorkspaceRoot $RelativePath))
}

function Get-TrackedStatus([string]$RepoRoot) {
    $output = & git -C $RepoRoot status --short --untracked-files=no --ignore-submodules=all
    if ($LASTEXITCODE -ne 0) {
        throw "git status failed for '$RepoRoot'."
    }

    @($output | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
}

$reposToCheck = @(
    (Resolve-WorkspacePath 'repos\eMule'),
    (Resolve-WorkspacePath 'repos\eMule-build'),
    (Resolve-WorkspacePath 'repos\eMule-build-tests'),
    (Resolve-WorkspacePath 'repos\eMule-tooling'),
    (Resolve-WorkspacePath 'repos\third_party\eMule-cryptopp'),
    (Resolve-WorkspacePath 'repos\third_party\eMule-id3lib'),
    (Resolve-WorkspacePath 'repos\third_party\eMule-mbedtls'),
    (Resolve-WorkspacePath 'repos\third_party\eMule-miniupnp'),
    (Resolve-WorkspacePath 'repos\third_party\eMule-ResizableLib'),
    (Resolve-WorkspacePath 'repos\third_party\eMule-zlib'),
    (Resolve-WorkspacePath 'workspaces\v0.72a\app\eMule-main'),
    (Resolve-WorkspacePath 'workspaces\v0.72a\app\eMule-v0.72a-community'),
    (Resolve-WorkspacePath 'workspaces\v0.72a\app\eMule-v0.72a-broadband'),
    (Resolve-WorkspacePath 'workspaces\v0.72a\app\eMule-v0.72a-tracing-harness-community')
)
if (-not [string]::IsNullOrWhiteSpace($SetupRepoRoot)) {
    $reposToCheck = @($SetupRepoRoot) + $reposToCheck
}

$issues = New-Object System.Collections.Generic.List[string]
foreach ($repoRoot in $reposToCheck) {
    if (-not (Test-Path -LiteralPath $repoRoot)) {
        continue
    }

    $statusLines = @(Get-TrackedStatus $repoRoot)
    if ($statusLines.Count -gt 0) {
        $issues.Add(("Tracked changes present in {0}:{1}{2}" -f $repoRoot, [Environment]::NewLine, ($statusLines -join [Environment]::NewLine))) | Out-Null
    }
}

if ($issues.Count -gt 0) {
    throw ($issues -join ([Environment]::NewLine + [Environment]::NewLine))
}

Write-Host 'Tracked worktree cleanliness audit passed.'
