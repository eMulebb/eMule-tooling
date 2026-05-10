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

function Invoke-Git([string]$RepoRoot, [string[]]$Arguments) {
    $output = & git -C $RepoRoot @Arguments 2>$null
    $exitCode = $LASTEXITCODE
    [pscustomobject]@{
        ExitCode = $exitCode
        Output = @($output)
        Text = (@($output) -join "`n").Trim()
    }
}

function Get-CurrentBranch([string]$RepoRoot) {
    $result = Invoke-Git $RepoRoot @('symbolic-ref', '--quiet', '--short', 'HEAD')
    if ($result.ExitCode -eq 0) {
        return $result.Text
    }

    return '(detached)'
}

function Get-HeadCommit([string]$RepoRoot, [string]$Revision = 'HEAD') {
    $result = Invoke-Git $RepoRoot @('rev-parse', $Revision)
    if ($result.ExitCode -ne 0 -or [string]::IsNullOrWhiteSpace($result.Text)) {
        throw "Unable to resolve git revision '$Revision' in '$RepoRoot'."
    }

    $result.Text
}

function Assert-BranchAllowed([string]$RepoLabel, [string]$ExpectedBranch, [string]$CurrentBranch) {
    if ($CurrentBranch -eq $ExpectedBranch) {
        return
    }

    if ($ExpectedBranch -eq 'main' -and $CurrentBranch -match '^(feature|fix|chore)/') {
        return
    }

    throw "$RepoLabel is on branch '$CurrentBranch', expected '$ExpectedBranch'."
}

$buildDepsPath = Resolve-WorkspacePath 'repos\eMule-build\deps.json'
if (-not (Test-Path -LiteralPath $buildDepsPath)) {
    throw "Missing build dependency manifest: $buildDepsPath"
}

$buildDeps = Get-Content -Raw -LiteralPath $buildDepsPath | ConvertFrom-Json
$workspaceName = if ($null -ne $buildDeps.workspace -and -not [string]::IsNullOrWhiteSpace($buildDeps.workspace.name)) {
    [string]$buildDeps.workspace.name
} else {
    'v0.72a'
}

$workspaceRootPath = Resolve-WorkspacePath ("workspaces\{0}" -f $workspaceName)
$workspaceManifestPath = Join-Path $workspaceRootPath 'deps.json'
if (-not (Test-Path -LiteralPath $workspaceManifestPath)) {
    throw "Missing generated workspace manifest: $workspaceManifestPath"
}

$workspaceManifest = Get-Content -Raw -LiteralPath $workspaceManifestPath | ConvertFrom-Json
if ($null -eq $workspaceManifest.workspace -or $null -eq $workspaceManifest.workspace.app_repo) {
    throw "Generated workspace manifest '$workspaceManifestPath' is missing workspace.app_repo."
}

$convertWorkspaceRelativePathToRootRelative = {
    param([string]$RelativePath)

    if ([string]::IsNullOrWhiteSpace($RelativePath)) {
        return $RelativePath
    }

    $absolutePath = [System.IO.Path]::GetFullPath((Join-Path $workspaceRootPath $RelativePath))
    [System.IO.Path]::GetRelativePath($EmuleWorkspaceRoot, $absolutePath)
}

$appRepo = $workspaceManifest.workspace.app_repo
$seedRepo = $appRepo.seed_repo
if ($null -ne $seedRepo -and -not [string]::IsNullOrWhiteSpace($seedRepo.path)) {
    $seedRepo.path = & $convertWorkspaceRelativePathToRootRelative $seedRepo.path
}

$normalizedVariants = [System.Collections.Generic.List[hashtable]]::new()
foreach ($variant in @($appRepo.variants)) {
    $normalizedVariant = @{
        name = [string]$variant.name
        path = [string]$variant.path
        branch = [string]$variant.branch
    }
    if (-not [string]::IsNullOrWhiteSpace($normalizedVariant.path)) {
        $normalizedVariant.path = & $convertWorkspaceRelativePathToRootRelative $normalizedVariant.path
    }
    $normalizedVariants.Add($normalizedVariant) | Out-Null
}

$canonicalRepoPath = Resolve-WorkspacePath $seedRepo.path
if (-not (Test-Path -LiteralPath $canonicalRepoPath)) {
    throw "Canonical app repo is missing: $canonicalRepoPath"
}

$canonicalBranch = Get-CurrentBranch $canonicalRepoPath
if ($canonicalBranch -ne '(detached)') {
    throw "Canonical app repo must be detached; found branch '$canonicalBranch'."
}

$expectedAnchorRevision = "origin/$($seedRepo.branch)"
$canonicalHead = Get-HeadCommit $canonicalRepoPath
$expectedAnchorHead = Get-HeadCommit $canonicalRepoPath $expectedAnchorRevision
if ($canonicalHead -ne $expectedAnchorHead) {
    throw "Canonical app repo HEAD is $canonicalHead, expected detached $expectedAnchorRevision at $expectedAnchorHead."
}

foreach ($variant in @($normalizedVariants)) {
    $variantPath = Resolve-WorkspacePath $variant.path
    if (-not (Test-Path -LiteralPath $variantPath)) {
        throw "Managed app worktree is missing: $variantPath"
    }

    $currentBranch = Get-CurrentBranch $variantPath
    if ($currentBranch -eq '(detached)') {
        throw "Managed app worktree '$($variant.name)' must stay on a named branch, but is detached."
    }
    if ($currentBranch -like 'stale/*') {
        throw "Managed app worktree '$($variant.name)' must not use stale history branch '$currentBranch'."
    }

    Assert-BranchAllowed -RepoLabel $variantPath -ExpectedBranch $variant.branch -CurrentBranch $currentBranch
}

Write-Host 'Branch policy audit passed.'
