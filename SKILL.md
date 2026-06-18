---
name: codex-lazy-packs
description: Codex 懶人包全集 — 環境建置、MCP 串接、技能安裝、設定同步。說「Codex 懶人包」「安裝 Codex 懶人包」時載入。
---

# Codex 懶人包 — AI Agent 自動安裝入口

當使用者給你這個 repo 網址並說要安裝時：

## 先判斷需求

- 如果使用者問「從哪裡開始」「怎麼整合」「所有懶人包怎麼跑」「我想建立教學工具專案」，先讀 `懶人包總入口.md`，再依情境建議路線。
- 如果使用者已經指定要裝哪些懶人包，直接照下面流程列出與安裝。

## 步驟一：列出可用懶人包

| 編號 | Skill 名稱 | 說明 |
|------|-----------|------|
| 00 | `codex-env-setup` | Codex Desktop、Node.js LTS、uv；CLI 選用，不處理 GitHub |
| 01 | `codex-notebooklm` | 連接 NotebookLM MCP |
| 02 | `codex-essentials` | 初學者必裝 Skills 與 Plugins |
| 03 | `codex-github` | 連接 GitHub CLI |
| 04 | `codex-github-obsidian` | GitHub + Obsidian 整合 |
| 05 | `codex-obsidian` | 連接 Obsidian（資料夾授權 / MCPVault） |
| 06 | `codex-second-brain` | 第二大腦三層結構 |
| 07 | `codex-supabase` | 連接 Supabase |
| 08 | `codex-firebase` | 連接 Firebase |
| 09 | `codex-ollama` | 本地 AI Ollama |
| 10 | `codex-gemini` | Gemini 免費 API |
| 11 | `codex-workspace` | 專案初始化工作模式 |
| 12 | `codex-draw` | 生圖指引（內建 + API） |
| 13 | `codex-chezmoi` | 跨電腦同步 Codex 設定 |
| 14 | `codex-install-all` | 一次安裝全部 |

## 步驟二：讓使用者選擇

問：「你要安裝哪些？輸入全部或編號組合（例如 00, 01, 03, 05）。」

將編號轉成上表的完整 Skill 名稱。若使用者只選 00，不得順便執行 GitHub 安裝或帳號檢查。

## 步驟三：依序安裝

```bash
npx skills add mathruffian-dot/codex-lazy-packs --skill <完整 Skill 名稱> --full-depth -g -y
```

例如只安裝環境建置：

```powershell
npx skills add mathruffian-dot/codex-lazy-packs --skill codex-env-setup --full-depth -g -y
```

`--full-depth` 不可省略；repo 根目錄已有入口 `SKILL.md`，省略時安裝器只會看到入口 Skill。

若無法使用 `npx skills add`，改手動讀取 `skills/00-env-setup/SKILL.md` 等對應檔案執行。

## 步驟四：回報

每項回報 ✅/⚠️/❌，最後列總表。
