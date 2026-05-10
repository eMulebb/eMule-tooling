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

function Get-PythonCommand {
    $python = Get-Command 'python' -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($null -ne $python) {
        return @($python.Source)
    }

    $py = Get-Command 'py' -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($null -ne $py) {
        return @($py.Source, '-3')
    }

    throw 'Python 3 is required to read eMule-build topology.'
}

$buildRepoRoot = Resolve-WorkspacePath 'repos\eMule-build'
$pythonCommand = @(Get-PythonCommand)
$pythonExe = $pythonCommand[0]
$pythonArgs = @($pythonCommand | Select-Object -Skip 1)
$topologyScript = @'
import json
from emule_workspace.topology import canonical_topology

print(json.dumps([
    {"relative_path": repo.relative_path, "branch": repo.branch}
    for repo in canonical_topology().third_party_repos
]))
'@
$previousPythonPath = $env:PYTHONPATH
try {
    $env:PYTHONPATH = if ([string]::IsNullOrWhiteSpace($previousPythonPath)) {
        $buildRepoRoot
    } else {
        '{0};{1}' -f $buildRepoRoot, $previousPythonPath
    }
    $thirdPartyReposJson = & $pythonExe @pythonArgs -c $topologyScript
    if ($LASTEXITCODE -ne 0) {
        throw 'Unable to read third-party pins from eMule-build topology.'
    }
} finally {
    $env:PYTHONPATH = $previousPythonPath
}

$thirdPartyRepos = @($thirdPartyReposJson | ConvertFrom-Json)

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

    $entry = @($thirdPartyRepos | Where-Object { $_.relative_path -eq $relativePath } | Select-Object -First 1)[0]
    if ($null -eq $entry) {
        throw "Python topology is missing third-party repo path '$relativePath'."
    }
    if ($entry.branch -ne $expectedBranch) {
        throw "Python topology pin for '$repoName' is '$($entry.branch)', expected '$expectedBranch'."
    }
}

Write-Host 'Dependency pin audit passed.'
