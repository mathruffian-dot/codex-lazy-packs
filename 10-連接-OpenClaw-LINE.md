# OpenClaw + Codex + LINE 設定懶人包

目標：在一台新的 Windows 電腦上，讓 Codex 透過 OpenClaw 接上 LINE，並把你的 LINE 帳號設為 Command Owner。完成後可以從 LINE 對 OpenClaw 下指令，例如做每日生活計畫、讀書安排、Email/行事曆整理。

本文件整理自 2026-05-08 實際設定過程。敏感資訊請一律使用你自己的值，不要把 API key、LINE token、Channel secret 寫進文件或聊天紀錄。

## 最終架構

- Codex 使用 MCP 連到 OpenClaw：`openclaw mcp serve`
- OpenClaw Gateway 跑在本機：`127.0.0.1:18789`
- LINE webhook 不直接公開 Gateway，而是：
  - Cloudflare quick tunnel -> `127.0.0.1:18790`
  - 本機 proxy 只允許 `/line/webhook`
  - proxy 再轉發到 OpenClaw Gateway 的 `/line/webhook`

這樣避免把 OpenClaw 整個 write-capable Gateway 暴露到公開網路。

## 需要準備

1. Windows + PowerShell
2. Node.js 已安裝
3. Codex Desktop 已安裝
4. LINE Developers 帳號
5. OpenAI API key，且該 Project 已啟用 Billing / 有可用額度

## 1. 安裝 OpenClaw

PowerShell 執行：

```powershell
iwr -useb https://openclaw.ai/install.ps1 | iex
```

檢查版本：

```powershell
& "$env:APPDATA\npm\openclaw.cmd" --version
```

如果 `openclaw` 指令找不到，直接用完整路徑：

```powershell
& "$env:APPDATA\npm\openclaw.cmd" doctor
```

## 2. 設定並啟動 Gateway

```powershell
& "$env:APPDATA\npm\openclaw.cmd" config set gateway.mode local
& "$env:APPDATA\npm\openclaw.cmd" config set gateway.bind loopback
& "$env:APPDATA\npm\openclaw.cmd" gateway install
& "$env:APPDATA\npm\openclaw.cmd" gateway start
& "$env:APPDATA\npm\openclaw.cmd" gateway status
```

成功訊號：

- `Connectivity probe: ok`
- `Listening: 127.0.0.1:18789`

## 3. 讓 Codex 載入 OpenClaw MCP

編輯：

`%USERPROFILE%\.codex\config.toml`

加入：

```toml
[mcp_servers.openclaw]
command = "C:\\Users\\User\\AppData\\Roaming\\npm\\openclaw.cmd"
args = ["mcp", "serve"]
startup_timeout_sec = 20
tool_timeout_sec = 60
```

注意：

- 路徑中的 `User` 要改成實際 Windows 使用者名稱。
- Codex Desktop 要完整重啟後才會載入新的 MCP server。

## 4. 安裝 OpenClaw LINE 外掛

```powershell
& "$env:APPDATA\npm\openclaw.cmd" plugins install @openclaw/line
& "$env:APPDATA\npm\openclaw.cmd" gateway restart
```

## 5. 建立 LINE Messaging API Channel

到 LINE Developers Console：

`https://developers.line.biz/console/`

操作：

1. 建立或選擇 Provider。
2. 建立 `Messaging API channel`。
3. Channel name 可用：`OpenClaw Daily Assistant`
4. 建立後取得：
   - `Channel ID`
   - `Channel secret`
   - `Channel access token`

## 6. 寫入 LINE Channel 設定

不要把 token 寫進文件。用 PowerShell 變數暫存：

```powershell
$lineToken = "<LINE_CHANNEL_ACCESS_TOKEN>"
$lineSecret = "<LINE_CHANNEL_SECRET>"

& "$env:APPDATA\npm\openclaw.cmd" config set channels.line.enabled true --strict-json
& "$env:APPDATA\npm\openclaw.cmd" config set channels.line.dmPolicy pairing
& "$env:APPDATA\npm\openclaw.cmd" config set channels.line.channelAccessToken $lineToken
& "$env:APPDATA\npm\openclaw.cmd" config set channels.line.channelSecret $lineSecret
& "$env:APPDATA\npm\openclaw.cmd" gateway restart
```

驗證：

```powershell
& "$env:APPDATA\npm\openclaw.cmd" channels status --deep
```

成功訊號：

`LINE default: enabled, configured, running, mode:webhook`

## 7. 啟動只允許 /line/webhook 的本機 proxy

懶人包附了 `line-webhook-proxy.mjs`。用途：

- `GET /` -> 404
- `GET /line/webhook` -> 200 OK
- `POST /line/webhook` -> 原封不動轉發到 OpenClaw Gateway

啟動：

```powershell
Start-Process -FilePath "C:\Program Files\nodejs\node.exe" `
  -ArgumentList '"C:\path\to\OpenClaw-LINE-Setup-Pack\line-webhook-proxy.mjs"' `
  -WindowStyle Hidden `
  -RedirectStandardOutput "C:\Temp\line-webhook-proxy.out.log" `
  -RedirectStandardError "C:\Temp\line-webhook-proxy.err.log"
```

驗證：

```powershell
Invoke-WebRequest -Uri "http://127.0.0.1:18790/" -UseBasicParsing
Invoke-WebRequest -Uri "http://127.0.0.1:18790/line/webhook" -UseBasicParsing
```

預期：

- `/` 回 404
- `/line/webhook` 回 200 OK

## 8. 建立 Cloudflare quick tunnel

下載 cloudflared：

```powershell
Invoke-WebRequest `
  -Uri "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-windows-amd64.exe" `
  -OutFile ".\cloudflared.exe"
```

啟動 tunnel，只指向受限 proxy：

```powershell
Start-Process -FilePath ".\cloudflared.exe" `
  -ArgumentList @("tunnel","--url","http://127.0.0.1:18790") `
  -WindowStyle Hidden `
  -RedirectStandardOutput ".\cloudflared-line.out.log" `
  -RedirectStandardError ".\cloudflared-line.err.log"
```

在 log 中找：

```text
https://xxxxx.trycloudflare.com
```

Webhook URL 會是：

```text
https://xxxxx.trycloudflare.com/line/webhook
```

## 9. 設定 LINE Webhook URL

可在 LINE Console 貼上，也可用 LINE API：

```powershell
$lineToken = "<LINE_CHANNEL_ACCESS_TOKEN>"
$endpoint = "https://xxxxx.trycloudflare.com/line/webhook"
$headers = @{ Authorization = "Bearer $lineToken" }
$body = @{ endpoint = $endpoint } | ConvertTo-Json -Compress

Invoke-RestMethod `
  -Method Put `
  -Uri "https://api.line.me/v2/bot/channel/webhook/endpoint" `
  -Headers $headers `
  -ContentType "application/json" `
  -Body $body

Invoke-RestMethod `
  -Method Get `
  -Uri "https://api.line.me/v2/bot/channel/webhook/endpoint" `
  -Headers $headers
```

成功訊號：

```text
endpoint = https://xxxxx.trycloudflare.com/line/webhook
active   = True
```

## 10. Pair LINE 帳號並設定 Command Owner

1. 在 LINE Developers Console 確認 `Use webhook` 開啟。
2. 用你的 LINE 帳號加 bot 好友。
3. 傳一則訊息，例如 `hello`。
4. 查看 pairing request：

```powershell
& "$env:APPDATA\npm\openclaw.cmd" pairing list line
```

會看到：

```text
Code     userId
ABCDEFGH Uxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

核准：

```powershell
& "$env:APPDATA\npm\openclaw.cmd" pairing approve line <CODE>
& "$env:APPDATA\npm\openclaw.cmd" gateway restart
```

成功時 OpenClaw 會自動設定：

```text
commands.ownerAllowFrom = ["line:Uxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"]
```

驗證：

```powershell
& "$env:APPDATA\npm\openclaw.cmd" pairing list line
& "$env:APPDATA\npm\openclaw.cmd" doctor
```

## 11. 設定 OpenAI API Key

不要用 `models auth paste-token`，它在這次實測中會把 token 回顯到終端輸出。

使用懶人包附的 `set-openclaw-openai-key.ps1`：

```powershell
.\set-openclaw-openai-key.ps1 -ApiKey "<OPENAI_API_KEY>"
& "$env:APPDATA\npm\openclaw.cmd" gateway restart
```

驗證：

```powershell
& "$env:APPDATA\npm\openclaw.cmd" models auth list
& "$env:APPDATA\npm\openclaw.cmd" models status --probe --probe-provider openai --probe-max-tokens 16
```

成功訊號：

```text
openai:manual [openai/token]
openai/gpt-5.5 ... ok
```

如果出現：

```text
You exceeded your current quota
```

代表本機設定已讀到 key，但 OpenAI Project 的 Billing / Limits / quota 有問題。

## 12. 測試 LINE 指令

在 LINE bot 裡傳：

```text
/diagnostics
```

或：

```text
幫我做明天的生活計畫
```

## 這次踩過的坑與修法

### 1. 安裝後 `openclaw` 找不到

現象：

```text
openclaw : 無法辨識 'openclaw'
```

修法：用完整路徑：

```powershell
& "$env:APPDATA\npm\openclaw.cmd" --version
```

### 2. Gateway 未設定

現象：

```text
gateway.mode is unset; gateway start will be blocked.
Gateway service not installed.
```

修法：

```powershell
& "$env:APPDATA\npm\openclaw.cmd" config set gateway.mode local
& "$env:APPDATA\npm\openclaw.cmd" config set gateway.bind loopback
& "$env:APPDATA\npm\openclaw.cmd" gateway install
& "$env:APPDATA\npm\openclaw.cmd" gateway start
```

### 3. LINE 不能用電話或 email 設 Command Owner

LINE owner id 必須是 LINE webhook 收到的 userId，格式像：

```text
Uxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

設定值格式：

```text
line:Uxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

### 4. LINE Console 顯示的 Webhook URL 可能沒刷新

這次 LINE Console 截圖仍顯示舊 URL，但 LINE API 查詢顯示正確 endpoint 且 `active=True`。

以 LINE API 查詢為準：

```powershell
Invoke-RestMethod -Method Get -Uri "https://api.line.me/v2/bot/channel/webhook/endpoint" -Headers $headers
```

### 5. 不要直接公開 OpenClaw Gateway

OpenClaw Gateway 是 write-capable，直接把 `127.0.0.1:18789` 暴露到 Cloudflare Tunnel 風險過高。

修法：只公開本機 proxy 的 `127.0.0.1:18790`，proxy 只允許 `/line/webhook`。

### 6. `GET /line/webhook` 會卡住

本機直接打 OpenClaw 的 `/line/webhook` GET 會等待不回。

修法：proxy 自己處理 GET：

- `GET /line/webhook` 回 `200 OK`
- `POST /line/webhook` 才轉給 OpenClaw

### 7. `models auth paste-token` 會回顯 API key

這次實測中，CLI 把貼入的 OpenAI key 回顯在終端輸出。

修法：用 `set-openclaw-openai-key.ps1` 直接寫入 `auth-profiles.json`。

### 8. PowerShell 寫 JSON 可能造成 OpenClaw 讀不到 profile

現象：

```text
Profiles: (none)
missingProvidersInUse: ["openai"]
```

原因：`Set-Content -Encoding UTF8` 在某些 Windows PowerShell 環境會寫出 OpenClaw 不接受的 UTF-8 BOM。

修法：用 `.NET UTF8Encoding($false)` 寫無 BOM UTF-8。

### 9. 舊 key 的 rate-limit cooldown 會留在 auth-state

現象：換 key 後仍可能看到舊 cooldown。

修法：重寫：

```text
%USERPROFILE%\.openclaw\agents\main\agent\auth-state.json
```

清成：

```json
{"version":1,"usageStats":{}}
```

### 10. Live probe 是最終判斷

只有 `models auth list` 成功還不夠。要跑：

```powershell
& "$env:APPDATA\npm\openclaw.cmd" models status --probe --probe-provider openai --probe-max-tokens 16
```

看到 `ok` 才代表 OpenClaw 能真正呼叫 OpenAI。

## 常用檢查命令

```powershell
& "$env:APPDATA\npm\openclaw.cmd" status --deep
& "$env:APPDATA\npm\openclaw.cmd" doctor
& "$env:APPDATA\npm\openclaw.cmd" channels status --deep
& "$env:APPDATA\npm\openclaw.cmd" pairing list line
& "$env:APPDATA\npm\openclaw.cmd" models auth list
& "$env:APPDATA\npm\openclaw.cmd" models status --probe --probe-provider openai --probe-max-tokens 16
```

## 安全收尾

1. 不要把 API keys 貼到聊天或文件。
2. 如果 key 曾經貼出，測試完請到 OpenAI 後台撤銷並重建。
3. quick tunnel 沒 uptime 保證，只適合測試；長期使用建議改 Cloudflare named tunnel 或固定 VPS。
4. 建議把 `plugins.allow` pin 到可信外掛，避免非 bundled plugin 自動載入。

