---
name: rime-weasel-liur
description: Install or repair Rime Weasel 小狼毫 on Windows and add the rime-liur 嘸蝦米/無蝦米 input schema. Use when the user asks to install 小狼毫, Weasel, Rime, 嘸蝦米, 無蝦米, Boshiamy-like Rime setup, or to redeploy/check this Windows input method.
---

# Rime Weasel Liur

Use this skill to install or repair 小狼毫 Weasel on Windows and add the `rime-liur` 嘸蝦米 schema.

## Defaults

- Weasel source: `https://github.com/rime/weasel/releases`
- Default Weasel version: `0.17.4`
- Default installer URL: `https://github.com/rime/weasel/releases/download/0.17.4/weasel-0.17.4.0-installer.exe`
- Liur source: `https://github.com/hsuanyi-chou/rime-liur`
- Default Liur archive URL: `https://github.com/hsuanyi-chou/rime-liur/archive/refs/heads/master.zip`
- Expected Weasel install root: `C:\Program Files (x86)\Rime`
- Rime user data folders to consider:
  - `$env:APPDATA\Rime`
  - `C:\Users\<active Windows username>\AppData\Roaming\Rime`

## Workflow

1. Confirm the task is Windows local setup for Rime/Weasel/Liur.
2. Check whether Weasel is already installed and whether `WeaselServer` is running.
3. Download only from the official Weasel GitHub release and the `rime-liur` GitHub repository.
4. Install Weasel if missing or if the requested version differs.
5. Back up target Rime user data folders before copying any schema files.
6. Copy the contents of `rime-liur-master\Rime` into each target Rime user data folder.
7. Run `WeaselDeployer.exe /deploy`.
8. Verify:
   - `installation.yaml` reports `distribution_version: 0.17.4` or the requested version.
   - `default.custom.yaml` contains `schema: liur`.
   - `build\liur.schema.yaml` and `build\liur.extended.*.bin` exist.
   - `WeaselServer` is running.
9. Tell the user how to switch input methods:
   - Windows input method: select `小狼毫`.
   - Rime schema menu: `Ctrl+grave` or `Ctrl+Shift+grave`, then choose `liur`.

## Scripted Install

Prefer using the bundled script:

```powershell
.\scripts\install-rime-weasel-liur.ps1
```

Useful parameters:

```powershell
.\scripts\install-rime-weasel-liur.ps1 -WeaselVersion 0.17.4
.\scripts\install-rime-weasel-liur.ps1 -SkipWeaselInstall
.\scripts\install-rime-weasel-liur.ps1 -KeepTemp
```

The script downloads files, installs Weasel, copies Liur files, redeploys, and prints a verification summary.

## Permissions

Installing Weasel and writing Rime user data may require elevated permissions. If download, install, or user profile access fails because of sandboxing or Windows permissions, request approval before retrying.

## Safety

- Never download installers or schema files from unofficial mirrors unless the user explicitly requests it.
- Never delete existing Rime user data. Back it up first.
- Do not commit downloaded installers, zip files, build output, or user dictionaries.
- If `C:\Users\<username>` and `$env:USERPROFILE` differ, install Liur into both likely Rime data folders.
