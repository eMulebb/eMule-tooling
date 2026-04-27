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
    }
}

$scanScopes = @(
    @{
        RepoRoot = Resolve-WorkspacePath 'repos\eMule-tooling'
        Paths = @('README.md', 'AGENTS.md', 'docs\WORKSPACE_POLICY.md')
    }
    @{
        RepoRoot = Resolve-WorkspacePath 'repos\eMule-tooling'
        Paths = @('docs-clean\*.md')
    }
    @{
        RepoRoot = Resolve-WorkspacePath 'repos\eMule-build'
        Paths = @('README.md')
    }
    @{
        RepoRoot = Resolve-WorkspacePath 'workspaces\v0.72a\app\eMule-main'
        Paths = @('AGENTS.md')
    }
    @{
        RepoRoot = Resolve-WorkspacePath 'workspaces\v0.72a\app\eMule-v0.72a-community'
        Paths = @('AGENTS.md')
    }
    @{
        RepoRoot = Resolve-WorkspacePath 'workspaces\v0.72a\app\eMule-v0.72a-broadband'
        Paths = @('AGENTS.md')
    }
    @{
        RepoRoot = Resolve-WorkspacePath 'workspaces\v0.72a\app\eMule-v0.72a-tracing-harness-community'
        Paths = @('AGENTS.md')
    }
)

$issues = New-Object System.Collections.Generic.List[string]
$absolutePathRegex = '(?im)\b[a-z]:\\'

foreach ($scope in $scanScopes) {
    $repoRoot = [System.IO.Path]::GetFullPath($scope.RepoRoot)
    if (-not (Test-Path -LiteralPath $repoRoot)) {
        throw "Documentation scan root is missing: $repoRoot"
    }

    $lsFiles = Invoke-Git $repoRoot @('ls-files', '--', $scope.Paths)
    if ($lsFiles.ExitCode -ne 0) {
        throw "git ls-files failed for '$repoRoot'."
    }

    foreach ($relativePath in @($lsFiles.Output | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })) {
        $fullPath = Join-Path $repoRoot $relativePath
        if (-not (Test-Path -LiteralPath $fullPath -PathType Leaf)) {
            continue
        }

        $lineNumber = 0
        foreach ($line in Get-Content -LiteralPath $fullPath) {
            $lineNumber++
            if ($line -match $absolutePathRegex) {
                $issues.Add(("{0}:{1}: hardcoded absolute path in markdown: {2}" -f $fullPath, $lineNumber, $line.Trim())) | Out-Null
            }
        }
    }
}

if ($issues.Count -gt 0) {
    throw ($issues -join [Environment]::NewLine)
}

Write-Host 'Active documentation path audit passed.'
