# 10-安裝小狼毫無蝦米 Skill 懶人包

## 目的

把「安裝小狼毫 0.17.4 + 加入 rime-liur 嘸蝦米/無蝦米方案 + 重新部署」整理成 Codex 可重用的 Skill。

適用情境：

- 新 Windows 電腦要安裝小狼毫與無蝦米輸入法。
- 小狼毫已安裝，但方案選單沒有 `liur`。
- Rime 設定資料夾跑到暫存 profile，需要同時寫入 `$env:APPDATA\Rime` 與 `C:\Users\<帳號>\AppData\Roaming\Rime`。
- 需要讓 Codex 之後能自動檢查、備份、下載、部署與驗證。

## Skill 位置

本懶人包已附 Skill：

```text
codex-lazy-packs/skills/rime-weasel-liur/
```

主要檔案：

```text
codex-lazy-packs/skills/rime-weasel-liur/SKILL.md
codex-lazy-packs/skills/rime-weasel-liur/scripts/install-rime-weasel-liur.ps1
```

## 安裝到 Codex Skills

把整個 Skill 資料夾複製到 Codex Skills 目錄：

```powershell
New-Item -ItemType Directory -Force -Path "$env:CODEX_HOME\skills" | Out-Null
Copy-Item -Path ".\codex-lazy-packs\skills\rime-weasel-liur" -Destination "$env:CODEX_HOME\skills\" -Recurse -Force
```

如果 `$env:CODEX_HOME` 沒有設定，可先用：

```powershell
$env:CODEX_HOME = "$env:USERPROFILE\.codex"
```

## 使用方式

之後可以直接對 Codex 說：

```text
用 rime-weasel-liur skill 安裝小狼毫無蝦米輸入法
```

或：

```text
修復小狼毫，讓 liur 無蝦米方案出現在方案選單
```

Skill 會指示 Codex：

1. 從官方 GitHub 下載小狼毫 Weasel。
2. 從 `hsuanyi-chou/rime-liur` 下載無蝦米方案。
3. 安裝或修復 Weasel。
4. 備份 Rime 使用者資料夾。
5. 複製 `liur` schema 與字典檔。
6. 執行 `WeaselDeployer.exe /deploy`。
7. 驗證 `liur` 編譯檔與小狼毫版本。

## 手動執行腳本

在專案根目錄可手動執行：

```powershell
.\codex-lazy-packs\skills\rime-weasel-liur\scripts\install-rime-weasel-liur.ps1
```

只重新部署無蝦米方案、不重裝小狼毫：

```powershell
.\codex-lazy-packs\skills\rime-weasel-liur\scripts\install-rime-weasel-liur.ps1 -SkipWeaselInstall
```

保留暫存下載與備份資料夾方便除錯：

```powershell
.\codex-lazy-packs\skills\rime-weasel-liur\scripts\install-rime-weasel-liur.ps1 -KeepTemp
```

## 官方來源

- 小狼毫 Weasel：<https://github.com/rime/weasel/releases>
- Weasel 0.17.4：<https://github.com/rime/weasel/releases/tag/0.17.4>
- rime-liur：<https://github.com/hsuanyi-chou/rime-liur>

## 驗證標準

完成後應確認：

- `C:\Program Files (x86)\Rime\weasel-0.17.4` 存在。
- `WeaselServer` 正在執行。
- `C:\Users\<帳號>\AppData\Roaming\Rime\default.custom.yaml` 包含 `schema: liur`。
- `C:\Users\<帳號>\AppData\Roaming\Rime\build\liur.schema.yaml` 存在。
- `installation.yaml` 顯示 `distribution_version: 0.17.4`。

使用時切到 Windows 輸入法「小狼毫」，再按 `Ctrl + ~` 或 `Ctrl + Shift + ~` 開啟方案選單，選 `liur`。

## 注意事項

- 安裝輸入法與寫入其他 Windows profile 可能需要管理員權限。
- 不要把下載的 `.exe`、`.zip`、Rime `build` 產物或個人 userdb 放進 Git。
- 若 `$env:USERPROFILE` 是暫存 profile，仍要同時檢查 `C:\Users\<帳號>\AppData\Roaming\Rime`。
