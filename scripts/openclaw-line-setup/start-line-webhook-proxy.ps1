param(
  [int]$ProxyPort = 18790,
  [int]$OpenClawGatewayPort = 18789,
  [string]$LogDir = "C:\Temp"
)

$ErrorActionPreference = "Stop"

$scriptPath = Join-Path $PSScriptRoot "line-webhook-proxy.mjs"
if (-not (Test-Path $scriptPath)) {
  throw "Missing proxy script: $scriptPath"
}

if (-not (Test-Path $LogDir)) {
  New-Item -ItemType Directory -Path $LogDir -Force | Out-Null
}

$env:LINE_PROXY_PORT = [string]$ProxyPort
$env:OPENCLAW_GATEWAY_PORT = [string]$OpenClawGatewayPort

Start-Process `
  -FilePath "C:\Program Files\nodejs\node.exe" `
  -ArgumentList "`"$scriptPath`"" `
  -WindowStyle Hidden `
  -RedirectStandardOutput (Join-Path $LogDir "line-webhook-proxy.out.log") `
  -RedirectStandardError (Join-Path $LogDir "line-webhook-proxy.err.log")

Write-Host "Started LINE webhook proxy on http://127.0.0.1:$ProxyPort/line/webhook"
