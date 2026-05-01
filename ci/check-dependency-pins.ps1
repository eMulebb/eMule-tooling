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

function Resolve-WorkspacePath([string]$RelativePath) {
    [System.IO.Path]::GetFullPath((Join-Path $EmuleWorkspaceRoot $RelativePath))
}

function Invoke-Git([string]$RepoRoot, [string[]]$Arguments) {
    $output = & git -C $RepoRoot @Arguments 2>$null
    $exitCode = $LASTEXITCODE
    [pscustomobject]@{
        ExitCode = $exitCode
        Text = (@($output) -join "`n").Trim()
    }
}

$defaultSiblingSetupRoot = Join-Path (Split-Path -Parent $EmuleWorkspaceRoot) 'eMulebb-setup'
if ([string]::IsNullOrWhiteSpace($SetupRepoRoot) -and (Test-Path -LiteralPath $defaultSiblingSetupRoot)) {
    $SetupRepoRoot = $defaultSiblingSetupRoot
}

if (-not [string]::IsNullOrWhiteSpace($SetupRepoRoot)) {
    $SetupRepoRoot = [System.IO.Path]::GetFullPath($SetupRepoRoot)
}

$thirdPartyRepos = $null
if (-not [string]::IsNullOrWhiteSpace($SetupRepoRoot)) {
    $reposManifestPath = Join-Path $SetupRepoRoot 'repos.psd1'
    if (-not (Test-Path -LiteralPath $reposManifestPath)) {
        throw "Setup repo root does not contain repos.psd1: $SetupRepoRoot"
    }

    $reposManifest = Import-PowerShellDataFile -LiteralPath $reposManifestPath
    $thirdPartyRepos = @($reposManifest.ThirdPartyRepos)
}

foreach ($relativePath in @(
    'repos\third_party\eMule-cryptopp',
    'repos\third_party\eMule-id3lib',
    'repos\third_party\eMule-mbedtls',
    'repos\third_party\eMule-miniupnp',
    'repos\third_party\eMule-nlohmann-json',
    'repos\third_party\eMule-ResizableLib',
    'repos\third_party\eMule-zlib'
)) {
    $repoRoot = Resolve-WorkspacePath $relativePath
    if (-not (Test-Path -LiteralPath $repoRoot)) {
        throw "Pinned third-party repo path is missing: $repoRoot"
    }

    $repoName = Split-Path -Leaf $repoRoot
    $currentBranchResult = Invoke-Git $repoRoot @('symbolic-ref', '--quiet', '--short', 'HEAD')
    if ($currentBranchResult.ExitCode -ne 0 -or [string]::IsNullOrWhiteSpace($currentBranchResult.Text)) {
        throw "Dependency repo '$repoName' must stay on a named branch; it is detached."
    }

    $originHead = Invoke-Git $repoRoot @('symbolic-ref', '--quiet', 'refs/remotes/origin/HEAD')
    if ($originHead.ExitCode -ne 0) {
        throw "Unable to resolve local origin/HEAD for '$repoName' in '$repoRoot'."
    }

    $expectedBranch = Split-Path -Leaf $originHead.Text
    if ($currentBranchResult.Text -ne $expectedBranch) {
        throw "Dependency repo '$repoName' is on '$($currentBranchResult.Text)', expected active branch '$expectedBranch' from local origin/HEAD."
    }

    if ($null -ne $thirdPartyRepos) {
        $entry = @($thirdPartyRepos | Where-Object { $_.RelativePath -eq $relativePath } | Select-Object -First 1)[0]
        if ($null -eq $entry) {
            throw "Setup pin manifest is missing third-party repo path '$relativePath'."
        }
        if ($entry.Branch -ne $expectedBranch) {
            throw "Setup pin for '$repoName' is '$($entry.Branch)', expected '$expectedBranch'."
        }
    }
}

Write-Host 'Dependency pin audit passed.'
