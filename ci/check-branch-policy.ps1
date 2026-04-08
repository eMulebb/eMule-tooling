#Requires -Version 7.2
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

$depsPath = Resolve-WorkspacePath 'repos\eMule-build\deps.psd1'
if (-not (Test-Path -LiteralPath $depsPath)) {
    throw "Missing workspace dependency manifest: $depsPath"
}

$deps = Import-PowerShellDataFile -LiteralPath $depsPath
$appRepo = $deps.Workspace.AppRepo

$canonicalRepoPath = Resolve-WorkspacePath $appRepo.SeedRepo.Path
if (-not (Test-Path -LiteralPath $canonicalRepoPath)) {
    throw "Canonical app repo is missing: $canonicalRepoPath"
}

$canonicalBranch = Get-CurrentBranch $canonicalRepoPath
if ($canonicalBranch -ne '(detached)') {
    throw "Canonical app repo must be detached; found branch '$canonicalBranch'."
}

$expectedAnchorRevision = "origin/$($appRepo.SeedRepo.Branch)"
$canonicalHead = Get-HeadCommit $canonicalRepoPath
$expectedAnchorHead = Get-HeadCommit $canonicalRepoPath $expectedAnchorRevision
if ($canonicalHead -ne $expectedAnchorHead) {
    throw "Canonical app repo HEAD is $canonicalHead, expected detached $expectedAnchorRevision at $expectedAnchorHead."
}

foreach ($variant in @($appRepo.Variants)) {
    $variantPath = Resolve-WorkspacePath $variant.Path
    if (-not (Test-Path -LiteralPath $variantPath)) {
        throw "Managed app worktree is missing: $variantPath"
    }

    $currentBranch = Get-CurrentBranch $variantPath
    if ($currentBranch -eq '(detached)') {
        throw "Managed app worktree '$($variant.Name)' must stay on a named branch, but is detached."
    }
    if ($currentBranch -like 'stale/*') {
        throw "Managed app worktree '$($variant.Name)' must not use stale history branch '$currentBranch'."
    }

    Assert-BranchAllowed -RepoLabel $variantPath -ExpectedBranch $variant.Branch -CurrentBranch $currentBranch
}

Write-Host 'Branch policy audit passed.'
