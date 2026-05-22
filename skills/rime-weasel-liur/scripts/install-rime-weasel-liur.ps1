param(
  [string]$WeaselVersion = "0.17.4",
  [string]$WeaselInstallerUrl = "",
  [string]$LiurArchiveUrl = "https://github.com/hsuanyi-chou/rime-liur/archive/refs/heads/master.zip",
  [switch]$SkipWeaselInstall,
  [switch]$KeepTemp
)

$ErrorActionPreference = "Stop"

function Write-Step {
  param([string]$Message)
  Write-Host "[rime-weasel-liur] $Message"
}

function Ensure-Directory {
  param([string]$Path)
  New-Item -ItemType Directory -Force -Path $Path | Out-Null
}

function Get-WeaselInstallRoot {
  $roots = @(
    "C:\Program Files (x86)\Rime",
    "C:\Program Files\Rime"
  )
  foreach ($root in $roots) {
    if (Test-Path $root) {
      return $root
    }
  }
  return "C:\Program Files (x86)\Rime"
}

function Get-WeaselDeployer {
  param([string]$InstallRoot)
  $candidate = Join-Path $InstallRoot "weasel-$WeaselVersion\WeaselDeployer.exe"
  if (Test-Path $candidate) {
    return $candidate
  }

  $found = Get-ChildItem -Path $InstallRoot -Filter WeaselDeployer.exe -Recurse -ErrorAction SilentlyContinue |
    Sort-Object FullName -Descending |
    Select-Object -First 1
  if ($found) {
    return $found.FullName
  }

  return $null
}

function Get-RimeTargets {
  $targets = New-Object System.Collections.Generic.List[string]

  if ($env:APPDATA) {
    $targets.Add((Join-Path $env:APPDATA "Rime"))
  }

  if ($env:USERNAME) {
    $targets.Add("C:\Users\$env:USERNAME\AppData\Roaming\Rime")
  }

  if ($env:USERPROFILE) {
    $targets.Add((Join-Path $env:USERPROFILE "AppData\Roaming\Rime"))
  }

  return $targets | Sort-Object -Unique
}

if (-not $WeaselInstallerUrl) {
  $WeaselInstallerUrl = "https://github.com/rime/weasel/releases/download/$WeaselVersion/weasel-$WeaselVersion.0-installer.exe"
}

$tempRoot = Join-Path $env:TEMP ("rime-weasel-liur-" + (Get-Date -Format "yyyyMMdd-HHmmss"))
$backupRoot = Join-Path $tempRoot "backups"
Ensure-Directory $tempRoot
Ensure-Directory $backupRoot

try {
  Write-Step "working folder: $tempRoot"

  if (-not $SkipWeaselInstall) {
    $installer = Join-Path $tempRoot "weasel-installer.exe"
    Write-Step "downloading Weasel $WeaselVersion from GitHub"
    Invoke-WebRequest -Uri $WeaselInstallerUrl -OutFile $installer
    $installerHash = (Get-FileHash $installer -Algorithm SHA256).Hash
    Write-Step "Weasel installer SHA256: $installerHash"

    Write-Step "running Weasel installer"
    $process = Start-Process -FilePath $installer -ArgumentList "/S" -Wait -PassThru
    Write-Step "installer exit code: $($process.ExitCode)"
  } else {
    Write-Step "skipping Weasel installer"
  }

  $liurZip = Join-Path $tempRoot "rime-liur.zip"
  $liurExtract = Join-Path $tempRoot "rime-liur"
  Write-Step "downloading rime-liur from GitHub"
  Invoke-WebRequest -Uri $LiurArchiveUrl -OutFile $liurZip
  $liurHash = (Get-FileHash $liurZip -Algorithm SHA256).Hash
  Write-Step "rime-liur archive SHA256: $liurHash"

  Expand-Archive -Path $liurZip -DestinationPath $liurExtract -Force
  $rimeSource = Get-ChildItem -Path $liurExtract -Directory |
    Where-Object { Test-Path (Join-Path $_.FullName "Rime\liur.schema.yaml") } |
    Select-Object -First 1

  if (-not $rimeSource) {
    throw "Could not find rime-liur Rime folder after extracting archive."
  }

  $liurRimeFolder = Join-Path $rimeSource.FullName "Rime"
  $targets = Get-RimeTargets

  foreach ($target in $targets) {
    Write-Step "installing Liur schema to $target"
    Ensure-Directory $target

    $safeName = ($target -replace "[:\\]", "_").Trim("_")
    $backup = Join-Path $backupRoot $safeName
    Copy-Item -Path $target -Destination $backup -Recurse -Force -ErrorAction SilentlyContinue

    Copy-Item -Path (Join-Path $liurRimeFolder "*") -Destination $target -Recurse -Force
  }

  $installRoot = Get-WeaselInstallRoot
  $deployer = Get-WeaselDeployer -InstallRoot $installRoot
  if (-not $deployer) {
    throw "Could not find WeaselDeployer.exe under $installRoot."
  }

  Write-Step "deploying Rime with $deployer"
  & $deployer /deploy
  Start-Sleep -Seconds 3

  Write-Step "verification"
  foreach ($target in $targets) {
    $defaultCustom = Join-Path $target "default.custom.yaml"
    $buildLiur = Join-Path $target "build\liur.schema.yaml"
    $hasLiurInDefault = $false

    if (Test-Path $defaultCustom) {
      $hasLiurInDefault = Select-String -Path $defaultCustom -Pattern "schema:\s*liur" -Quiet
    }

    Write-Host "Target: $target"
    Write-Host "  default.custom.yaml has liur: $hasLiurInDefault"
    Write-Host "  build liur.schema.yaml exists: $(Test-Path $buildLiur)"
  }

  $installYaml = Get-RimeTargets |
    ForEach-Object { Join-Path $_ "installation.yaml" } |
    Where-Object { Test-Path $_ } |
    Select-Object -First 1

  if ($installYaml) {
    Write-Host "Installation:"
    Get-Content $installYaml | Where-Object { $_ -match "distribution_|rime_version|update_time" }
  }

  $server = Get-Process -Name WeaselServer -ErrorAction SilentlyContinue
  Write-Host "WeaselServer running: $([bool]$server)"
  Write-Step "done"
} finally {
  if ($KeepTemp) {
    Write-Step "kept working folder: $tempRoot"
  } else {
    if (Test-Path $tempRoot) {
      Remove-Item -LiteralPath $tempRoot -Recurse -Force -ErrorAction SilentlyContinue
    }
  }
}
