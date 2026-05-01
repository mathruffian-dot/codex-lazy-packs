# Codex 懶人包 #03：連接 Obsidian 第二大腦

> 版本：v0.3（Codex 版）
> 更新日期：2026-05-01

---

## 這個懶人包會幫你做什麼？

把 Codex 連到你的 Obsidian 筆記本，讓 Codex 可以在不同專案中協助你：

- 找到你的 Obsidian vault 實際位置
- 讀取、搜尋、整理 `.md` 筆記
- 建立或修改筆記
- 建立全域設定，讓 Codex 記得「我的筆記本在哪裡」
- 確認跨專案讀寫是否可用，並帶你完成必要設定

> [!important]
> 這份懶人包分成兩層：
>
> 1. **全域記憶設定**：讓 Codex 知道你的 Obsidian vault 路徑。
> 2. **讀寫權限 / MCP 設定**：讓 Codex 真的能跨專案讀寫那個資料夾。
>
> 只寫 AGENTS.md 只能解決「知道在哪裡」，不一定等於「任何專案都能直接寫入」。
> 跨專案讀寫不一定非要 MCP；如果 Codex App 已授權那個資料夾，檔案系統也能直接讀寫。MCP 的價值是讓 vault 成為穩定工具來源，並提供搜尋、讀寫、frontmatter、批次讀取等專門能力。

---

## 先備條件

- [ ] 已安裝 Codex Desktop、Codex CLI，或支援 Codex 的 IDE 外掛
- [ ] 已安裝 Obsidian，或準備新建一個 Obsidian vault
- [ ] 電腦有網路連線
- [ ] 若要安裝 MCP：需要 Node.js 與 npm

---

## 先做選擇：你是哪一種使用者？

| 狀況 | 建議流程 |
|------|----------|
| 已經有 Obsidian 筆記本 | 走「階段一：找到現有 vault」 |
| 還沒有 Obsidian 筆記本 | 走「階段二：建立新 vault」 |
| 想在任何專案都讀寫筆記 | 完成「階段四：跨專案讀寫設定」與「階段五：跨專案驗證」 |
| 只想讓 Codex 記得路徑 | 完成「階段三：全域 AGENTS.md」即可 |

---

## 階段一：找到現有 Obsidian vault

### 1-1. 先問使用者

請先問使用者：

> 你的 Obsidian 筆記本現在放在哪裡？如果不知道，我可以幫你找。

常見位置：

| 同步方式 | 常見路徑 |
|----------|----------|
| OneDrive | `C:\Users\<使用者>\OneDrive\文件\<vault名稱>` |
| Google Drive | `G:\我的雲端硬碟\<vault名稱>` |
| iCloud | `C:\Users\<使用者>\iCloudDrive\<vault名稱>` |
| 本機文件 | `C:\Users\<使用者>\Documents\<vault名稱>` |
| macOS iCloud | `/Users/<使用者>/Library/Mobile Documents/iCloud~md~obsidian/Documents/<vault名稱>` |
| macOS Google Drive | `/Users/<使用者>/Library/CloudStorage/GoogleDrive-<帳號>/My Drive/<vault名稱>` |

### 1-2. Windows 自動搜尋候選 vault

請 Codex 在 PowerShell 執行：

```powershell
$roots = @(
  "$env:USERPROFILE\OneDrive",
  "$env:USERPROFILE\Documents",
  "$env:USERPROFILE\Desktop",
  "G:\我的雲端硬碟",
  "G:\My Drive"
)

$roots |
  Where-Object { Test-Path $_ } |
  ForEach-Object {
    Get-ChildItem -Path $_ -Recurse -Directory -Force -ErrorAction SilentlyContinue |
      Where-Object { Test-Path (Join-Path $_.FullName ".obsidian") } |
      Select-Object FullName
  }
```

如果找到多個候選路徑，請列出來讓使用者選，不要自行猜。

### 1-3. 如果常見位置找不到，讀 Obsidian 記錄

如果使用者明明有開過 Obsidian，但常見位置沒有搜到 `.obsidian`，Windows 可讀 Obsidian 自己的設定檔：

```powershell
Get-Content -Path "$env:APPDATA\obsidian\obsidian.json" -Raw
```

常見內容會像：

```json
{
  "vaults": {
    "xxxx": {
      "path": "G:\\我的雲端硬碟\\2026 Codex\\2ndbrain",
      "open": true
    }
  }
}
```

處理原則：

- 優先看 `open: true` 的 vault。
- 若有多個 vault，列出路徑讓使用者選，不要只憑資料夾名稱猜。
- 取得候選路徑後，仍要確認該資料夾底下有 `.obsidian`。

### 1-4. macOS / Linux 自動搜尋候選 vault

```bash
find "$HOME" -type d -name ".obsidian" -prune 2>/dev/null | sed 's#/.obsidian$##'
```

### 1-4. 驗證這真的是 Obsidian vault

一個資料夾可以視為 Obsidian vault，至少要符合：

- 裡面有 `.obsidian/` 資料夾
- 裡面有 `.md` 筆記，或是使用者確認這是新 vault
- 使用者能在 Obsidian 裡正常開啟

把確認後的完整路徑記成：

```text
<VAULT_PATH>
```

---

## 階段二：建立新 vault（沒有現成筆記本才做）

如果使用者還沒有 Obsidian vault：

1. 請使用者先安裝 Obsidian：`https://obsidian.md`
2. 詢問要放在哪個同步位置：
   - OneDrive
   - Google Drive
   - Obsidian Sync
   - 本機資料夾
3. 如果使用 Google Drive，先確認使用者要放在「本機同步路徑」的哪一層，不要只看網頁連結。
4. 建立資料夾，例如：

```text
Secondbrain/
├── 每日筆記/
├── 知識庫/
├── 創作庫/
├── Templates/
└── Clippings/
```

如果使用者要放在既有 Google Drive 資料夾底下，例如 `2026 Codex`，路徑應明確寫完整：

```text
G:\我的雲端硬碟\2026 Codex\2ndbrain
```

5. 請使用者用 Obsidian 開啟這個資料夾。
6. 記下 vault 完整路徑 `<VAULT_PATH>`。

> [!note]
> 不必強制使用 Google Drive。OneDrive、Obsidian Sync、本機資料夾都可以。重點是 Codex 要知道實際路徑，且要有讀寫權限。
> Google Drive 網頁連結只能協助確認雲端資料夾；MCP 設定仍要填本機同步路徑，例如 `G:\我的雲端硬碟\2026 Codex\2ndbrain`。

---

## 階段三：建立全域設定，讓 Codex 記得 vault 路徑

### 3-1. 寫入全域 AGENTS.md

Codex 會讀取全域與專案層級的 `AGENTS.md`。建議把 Obsidian 固定路徑寫進：

```text
C:\Users\<使用者>\.codex\AGENTS.md
```

macOS / Linux：

```text
~/.codex/AGENTS.md
```

建議加入：

```markdown
## Obsidian 筆記本固定路徑

主要 Obsidian Vault：

`<VAULT_PATH>`

當我說「Obsidian」、「Secondbrain」、「我的筆記本」、「第二大腦」時，預設指這個資料夾。

若任務涉及筆記、教學素材、專案駕駛艙、工作流程、索引整理，請優先參考：

- `<VAULT_PATH>\AGENTS.md`
- `<VAULT_PATH>\第二大腦\專案工作流程.md`
- `<VAULT_PATH>\第二大腦\邏輯專案模型 SOP.md`

可協助讀取、整理、建立、修改 `.md` 筆記；但實際寫入權限以 Codex App 當次工作區授權與 MCP 設定為準。
```

### 3-2. 在 vault 根目錄建立 AGENTS.md

在 `<VAULT_PATH>\AGENTS.md` 建立你的筆記本規則。

範例：

```markdown
# 我的 Obsidian 筆記本

## 關於我
- 我是國中老師
- 這個 vault 是我的教學第二大腦

## 語言偏好
- 所有回應請使用繁體中文

## 筆記規則
- 新增筆記時保留 Obsidian 雙向連結
- 新增正式筆記時加 frontmatter
- 不要未經確認改寫個人聲音強烈的文章

## 固定路徑
- 主要 vault：`<VAULT_PATH>`
```

> [!important]
> 這一步只讓 Codex「知道」筆記本位置。要跨專案直接讀寫，還要完成下一階段。

---

## 階段四：跨專案讀寫設定

跨專案讀寫有兩條路線：

| 路線 | 適合情境 | 優點 | 限制 |
|------|----------|------|------|
| A. Codex 工作區 / 資料夾授權 | 使用 Codex Desktop，且可把 vault 加入可寫範圍 | 不需要 MCP，直接改檔 | 受當次工作區與 sandbox 權限限制 |
| B. MCP / mcpvault | 想讓 vault 在任何專案都像工具一樣可搜尋、可讀寫 | 跨專案穩定，搜尋與筆記操作較完整 | 需要 Node.js 與 MCP 設定 |

如果只是要跨專案「知道 vault 在哪」，階段三已足夠。
如果要跨專案「穩定搜尋、讀寫、整理筆記」，建議走 MCP。

### 4A. 使用 Codex 工作區 / 資料夾授權

1. 在 Codex App 開啟工作區時，直接選 `<VAULT_PATH>`；或
2. 在 Codex App 的資料夾授權 / 可寫範圍中加入 `<VAULT_PATH>`；或
3. 讓當前工作區本身就是 `<VAULT_PATH>` 的上層或同一資料夾。

測試方式：

```powershell
Test-Path "<VAULT_PATH>"
New-Item -ItemType Directory -Force -Path "<VAULT_PATH>\Codex 測試"
Set-Content -Encoding UTF8 -Path "<VAULT_PATH>\Codex 測試\檔案系統寫入測試.md" -Value "# 檔案系統寫入測試"
```

若成功，代表不靠 MCP 也能直接寫入。

### 4B-1. 安裝 Node.js

先檢查：

```powershell
node --version
npm.cmd --version
```

如果沒有 Node.js，Windows 可用：

```powershell
winget install --id OpenJS.NodeJS
```

安裝後重開終端機，再檢查一次。

### 4B-2. 安裝 mcpvault

```powershell
npm.cmd install -g @bitbonsai/mcpvault
```

確認 mcpvault 路徑：

```powershell
where.exe mcpvault
```

常見結果：

```text
C:\Users\<使用者>\AppData\Roaming\npm\mcpvault.cmd
```

### 4B-3. 註冊 MCP 到 Codex

Codex 的 MCP 設定通常在：

```text
C:\Users\<使用者>\.codex\config.toml
```

macOS / Linux：

```text
~/.codex/config.toml
```

加入：

```toml
[mcp_servers.obsidian]
command = "C:\\Users\\<使用者>\\AppData\\Roaming\\npm\\mcpvault.cmd"
args = ["<VAULT_PATH>"]
```

Windows 範例：

```toml
[mcp_servers.obsidian]
command = "C:\\Users\\mathr\\AppData\\Roaming\\npm\\mcpvault.cmd"
args = ["C:\\Users\\mathr\\OneDrive\\文件\\Secondbrain"]
```

macOS / Linux 範例：

```toml
[mcp_servers.obsidian]
command = "mcpvault"
args = ["/Users/<使用者>/Library/CloudStorage/GoogleDrive-xxx/My Drive/Secondbrain"]
```

> [!warning]
> Windows 的 TOML 路徑要用 `\\`，不能只寫單一反斜線。
> Section 名稱要是 `[mcp_servers.obsidian]`。

### 4B-4. 先手動測 MCP server

Windows PowerShell：

```powershell
'{"jsonrpc":"2.0","id":1,"method":"tools/list"}' |
  & "C:\Users\<使用者>\AppData\Roaming\npm\mcpvault.cmd" "<VAULT_PATH>"
```

如果成功，會看到 `read_note`、`write_note`、`search_notes`、`get_vault_stats` 等工具。

### 4B-5. 重啟 Codex

- Codex Desktop：完全關閉後重開
- Codex CLI：結束後重新進入
- IDE：Reload Window 或重開 IDE

---

## 階段五：跨專案讀寫驗證

### 5-1. 在 vault 工作區內測試

請先把 Codex 工作區開在 `<VAULT_PATH>`，對 Codex 說：

> 請列出這個 Obsidian vault 根目錄的資料夾。

接著說：

> 請在 `Codex 測試/` 建立一篇 `連線測試.md`，內容寫「Codex 可以寫入 Obsidian」。

如果成功，代表目前工作區有直接寫入權限。

### 5-2. 在其他專案測試

把 Codex 工作區切到另一個專案資料夾，對 Codex 說：

> 請讀取我的 Obsidian 筆記本根目錄，確認能不能看到資料夾。

再說：

> 請在我的 Obsidian 筆記本建立 `Codex 測試/跨專案測試.md`，寫入目前日期與所在專案名稱。

判斷結果：

| 結果 | 意義 |
|------|------|
| 成功讀寫 | MCP 或工作區授權已可跨專案操作 |
| 能讀不能寫 | 需要檢查 MCP 權限、Codex 工作區可寫範圍，或用 Obsidian vault 作為工作區 |
| 找不到 vault | 全域 AGENTS.md 未生效，或 MCP 沒成功連線 |
| 要求授權 | 依 Codex App 提示授權該資料夾 |

> [!important]
> 跨專案修改有兩種路徑：
>
> - **透過檔案系統直接修改**：不需要 MCP，但會受 Codex App 當次工作區與可寫資料夾限制。
> - **透過 MCP 修改**：需要安裝與設定 MCP，但跨專案比較穩定，也有搜尋與筆記工具。
>
> 所以最穩的做法是：全域 AGENTS.md 記路徑 + 至少一種跨專案讀寫路線 + 實測跨專案建立測試筆記。

---

## 階段六：完成後可以怎麼用

| 你說的話 | Codex 會做的事 |
|----------|----------------|
| 「搜尋我的 Obsidian 裡有沒有 XXX」 | 到 vault 搜尋相關筆記 |
| 「幫我新增一篇今天教學反思」 | 建立新的 `.md` 筆記 |
| 「整理這篇筆記成 YouTube 腳本」 | 讀取筆記並改寫成腳本 |
| 「這個專案上次做到哪？」 | 讀取對應的專案駕駛艙 |
| 「把這個專案的進度寫回第二大腦」 | 更新 Obsidian 內的工作流程筆記 |

---

## 如果失敗，照這個順序檢查

1. `<VAULT_PATH>` 是否正確
2. `<VAULT_PATH>` 裡是否有 `.obsidian/`
3. `C:\Users\<使用者>\.codex\AGENTS.md` 是否有寫入固定路徑
4. `C:\Users\<使用者>\.codex\config.toml` 是否有 `[mcp_servers.obsidian]`
5. `mcpvault.cmd` 路徑是否正確
6. Codex 是否已完全重啟
7. 是否在其他專案中實測過讀寫
8. 若是直接檔案寫入失敗，確認 Codex App 是否授權該資料夾

---

## 實測紀錄與踩坑筆記

### 2026-04-26 三師爸 Secondbrain 實測

實測環境：

| 項目 | 結果 |
|------|------|
| Vault | `C:\Users\mathr\OneDrive\文件\Secondbrain` |
| Node.js | `v24.14.0` |
| npm / npx | `11.9.0` |
| mcpvault | `@bitbonsai/mcpvault@0.11.0` |
| Codex 設定檔 | `C:\Users\mathr\.codex\config.toml` |
| MCP 設定名稱 | `obsidian` |
| 測試筆記 | `Codex-test/MCP-test.md` |

最後採用的 Codex MCP 設定：

```toml
[mcp_servers.obsidian]
command = "C:\\Users\\mathr\\AppData\\Roaming\\npm\\mcpvault.cmd"
args = ["C:\\Users\\mathr\\OneDrive\\文件\\Secondbrain"]
startup_timeout_sec = 20
tool_timeout_sec = 60
```

已完成驗證：

- `tools/list` 成功回傳 mcpvault 工具清單。
- `list_directory` 成功列出 vault 根目錄。
- `write_note` 成功建立 `Codex-test/MCP-test.md`。
- `read_note` 成功讀回測試筆記與 frontmatter。
- 重新啟動 Codex 後，`mcp__obsidian__` 工具正式載入。
- 透過 MCP 成功建立 `Codex-test/MCP-loaded-test.md`，確認重啟後可直接寫入 vault。

### 踩坑 1：PowerShell 直接跑 `npm` / `npx` 被執行原則擋住

症狀：

```text
因為這個系統上已停用指令碼執行，所以無法載入 C:\Program Files\nodejs\npm.ps1
```

原因：

PowerShell 會優先叫到 `npm.ps1` / `npx.ps1`，但系統執行原則不允許 `.ps1`。

解法：

```powershell
npm.cmd --version
npx.cmd --version
npm.cmd install -g @bitbonsai/mcpvault
```

不要急著改 Windows Execution Policy；先用 `.cmd` 通常就能解。

### 踩坑 2：`npx` 在 sandbox 內寫 npm cache 失敗

症狀：

```text
npm error code EPERM
npm error syscall mkdir
npm error path C:\Users\<使用者>\AppData\Local\npm-cache\_cacache\tmp
```

原因：

`npx` 需要下載與快取套件，會寫到使用者 npm cache。若 Codex 當下 sandbox 沒有該資料夾寫入權限，就會失敗。

解法：

1. 測試時授權 Codex 執行該命令；或
2. 改成先全域安裝：

```powershell
npm.cmd install -g @bitbonsai/mcpvault
```

然後在 `config.toml` 使用完整路徑：

```toml
command = "C:\\Users\\<使用者>\\AppData\\Roaming\\npm\\mcpvault.cmd"
```

### 踩坑 3：中文路徑經 PowerShell 管線送 JSON 時變成 `??`

症狀：

```text
Failed to write file: Codex ??/MCP??.md
```

原因：

這次是手動用 PowerShell 管線送 JSON 給 MCP server，中文 JSON 內容在管線編碼中被破壞。

解法：

- 手動命令列測試時，先用 ASCII 路徑確認 MCP 寫入能力，例如 `Codex-test/MCP-test.md`。
- 正式在 Codex MCP 工具中操作時，通常不需要手動經過 PowerShell JSON 管線。

### 踩坑 4：全域 npm 安裝成功，但 sandbox 內找不到 `mcpvault`

症狀：

```text
where.exe mcpvault
INFO: Could not find files for the given pattern(s).
```

原因：

`mcpvault.cmd` 安裝在使用者全域 npm 目錄：

```text
C:\Users\<使用者>\AppData\Roaming\npm\mcpvault.cmd
```

但該目錄不一定在目前 shell / sandbox 的 PATH 裡。

解法：

在 `config.toml` 直接寫完整路徑，不依賴 PATH。

### 踩坑 5：PowerShell 管線後執行字串路徑要用 `&`

錯誤寫法：

```powershell
'{"jsonrpc":"2.0","id":1,"method":"tools/list"}' | "C:\Users\<使用者>\AppData\Roaming\npm\mcpvault.cmd" "<VAULT_PATH>"
```

正確寫法：

```powershell
'{"jsonrpc":"2.0","id":1,"method":"tools/list"}' |
  & "C:\Users\<使用者>\AppData\Roaming\npm\mcpvault.cmd" "<VAULT_PATH>"
```

### 踩坑 6：改完 `config.toml` 後，當前 Codex 對話不會立刻出現新 MCP 工具

原因：

Codex 通常在啟動時讀取 MCP 設定。已開啟的對話不一定會即時載入新 server。

解法：

- 完全關閉並重開 Codex Desktop。
- 或在 Codex CLI / IDE 重新啟動 session。
- 重啟後再檢查 MCP 工具是否出現。

### 踩坑 7：WindowsApps 裡的 `codex.exe` 可能無法從 sandbox shell 執行

症狀：

```text
Program 'codex.exe' failed to run: Access is denied
```

影響：

這代表本次無法用 `codex mcp list` 在 shell 中驗證 Codex 是否讀到 MCP 設定。

替代驗證：

1. 直接用 `mcpvault.cmd` 測 `tools/list`。
2. 重啟 Codex 後，在對話中測試是否能列出 Obsidian vault。

### 踩坑 8：常見位置找不到 vault，但 Obsidian 其實有開啟

原因：

vault 可能放在 Google Drive、外接磁碟、或使用者自訂同步資料夾，不一定在 OneDrive / Documents / Desktop。

解法：

讀取 Obsidian 設定檔：

```powershell
Get-Content -Path "$env:APPDATA\obsidian\obsidian.json" -Raw
```

從 `vaults` 中找 `open: true` 或最近開啟的 `path`，再用 `Test-Path "<路徑>\.obsidian"` 確認。

### 踩坑 9：Google Drive 網頁連結和本機同步路徑不是同一件事

原因：

Google Drive 網頁連結會顯示雲端資料夾 ID，但 MCPVault 需要的是本機檔案系統路徑。

解法：

先確認雲端資料夾名稱與父資料夾，再對照本機同步路徑。例如使用者要放在 `2026 Codex` 底下，MCP 設定應使用：

```text
G:\我的雲端硬碟\2026 Codex\2ndbrain
```

不要只把網頁 URL 當成 vault 路徑。

### 踩坑 10：搬移 vault 後，MCP 還連到舊位置

原因：

`config.toml` 的 `[mcp_servers.obsidian] args` 是固定路徑，不會自動追蹤資料夾搬移。

解法：

1. 先確認新路徑存在且有 `.obsidian`。
2. 備份 `C:\Users\<使用者>\.codex\config.toml`。
3. 更新 `[mcp_servers.obsidian] args`。
4. 用 `mcpvault.cmd` 對新路徑讀回測試筆記。
5. 完全重啟 Codex。

## 常見問題

| 問題 | 解法 |
|------|------|
| 我不知道 vault 在哪 | 用階段一的搜尋指令找 `.obsidian/` |
| 我有多個 vault | 列出候選路徑，請使用者選主要 vault |
| 我用 OneDrive 可以嗎 | 可以，路徑正確即可 |
| 我用 Google Drive 可以嗎 | 可以，路徑正確即可 |
| Google Drive 連結可以直接填進 MCP 嗎 | 不行，MCP 要填本機同步路徑，不是網頁 URL |
| 我用 Obsidian Sync 可以嗎 | 可以，MCP 看的是本機資料夾 |
| 全域 AGENTS.md 寫了還不能改 | AGENTS.md 只提供記憶與規則，不保證檔案權限 |
| 跨專案要怎麼穩定修改 | 建議使用 MCP，並完成跨專案測試 |
| Windows TOML 路徑一直失敗 | 確認用 `\\`，例如 `C:\\Users\\...\\Secondbrain` |
| 我搬了 vault 位置 | 重新更新 `config.toml` 的 MCP 路徑，並重啟 Codex |

---

## 本懶人包不做的事

- 不強迫使用 Google Drive
- 不強迫新建 vault
- 不假設每個人路徑都一樣
- 不宣稱 MCP 是唯一跨專案路線
- 不承諾只靠 AGENTS.md 就能跨專案寫檔
- 不在未確認前改寫使用者既有筆記

---

## 相關連結

- [mcpvault GitHub](https://github.com/bitbonsai/mcpvault)
- [Obsidian 官網](https://obsidian.md)
- [Codex MCP 官方文件](https://developers.openai.com/codex/mcp)
