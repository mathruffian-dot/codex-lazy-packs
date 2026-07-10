param(
  [Parameter(Mandatory = $true)]
  [string]$ApiKey
)

$ErrorActionPreference = "Stop"

$agentDir = Join-Path $env:USERPROFILE ".openclaw\agents\main\agent"
$authPath = Join-Path $agentDir "auth-profiles.json"
$statePath = Join-Path $agentDir "auth-state.json"

if (-not (Test-Path $agentDir)) {
  New-Item -ItemType Directory -Path $agentDir -Force | Out-Null
}

$auth = [ordered]@{
  version = 1
  profiles = [ordered]@{
    "openai:manual" = [ordered]@{
      type = "token"
      provider = "openai"
      token = $ApiKey
    }
  }
}

$state = [ordered]@{
  version = 1
  usageStats = [ordered]@{}
}

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($authPath, ($auth | ConvertTo-Json -Depth 20 -Compress), $utf8NoBom)
[System.IO.File]::WriteAllText($statePath, ($state | ConvertTo-Json -Depth 20 -Compress), $utf8NoBom)

Write-Host "Updated OpenClaw openai:manual auth profile and cleared auth cooldown."
