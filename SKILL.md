---
name: codex-lazy-packs
description: Codex 懶人包全集 — 環境建置、MCP 串接、技能安裝、設定同步。說「Codex 懶人包」「安裝 Codex 懶人包」時載入。
---

# Codex 懶人包 — AI Agent 自動安裝入口

當使用者給你這個 repo 網址並說要安裝時：

## 步驟一：列出可用懶人包

| 編號 | Skill 名稱 | 說明 |
|------|-----------|------|
| 00 | `00-env-setup` | 安裝 Codex CLI、uv |
| 01 | `01-notebooklm` | 連接 NotebookLM MCP |
| 02 | `02-essentials` | 初學者必裝 Skills 與 Plugins |
| 03 | `03-github` | 連接 GitHub CLI |
| 04 | `04-github-obsidian` | GitHub + Obsidian 整合 |
| 05 | `05-obsidian` | 連接 Obsidian（資料夾授權 / MCPVault） |
| 06 | `06-second-brain` | 第二大腦三層結構 |
| 07 | `07-supabase` | 連接 Supabase |
| 08 | `08-firebase` | 連接 Firebase |
| 09 | `09-ollama` | 本地 AI Ollama |
| 10 | `10-gemini` | Gemini 免費 API |
| 11 | `11-workspace` | 專案初始化工作模式 |
| 12 | `12-draw` | 生圖指引（內建 + API） |
| 13 | `13-chezmoi` | 跨電腦同步 Codex 設定 |
| 14 | `14-spreadsheets-report` | Excel 月報整合與公式維護 |
| 15 | `00-install-all` | 一次安裝全部 |

## 步驟二：讓使用者選擇

問：「你要安裝哪些？輸入全部或編號組合（例如 00, 01, 03, 05）。」

## 步驟三：依序安裝

```bash
npx skills add mathruffian-dot/codex-lazy-packs --skill <名稱> -g -y
```

若無法使用 `npx skills add`，改手動讀取 `skills/<名稱>/SKILL.md` 執行。

## 步驟四：回報

每項回報 ✅/⚠️/❌，最後列總表。
