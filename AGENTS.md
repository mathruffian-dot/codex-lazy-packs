# AGENTS.md — codex-lazy-packs

## 這個資料夾是什麼

這是公開發布到 GitHub 的 **Codex 懶人包**倉庫，對應 repo：
**mathruffian-dot/codex-lazy-packs**

本資料夾與 `Codex-lazy-packs/` 是**平行版本**：同樣的教學流程，分別給 Codex 與 OpenAI Codex（**Desktop / IDE / CLI 三者通用**）使用。

## 主要敘事視角

懶人包以 **Codex Desktop app**（macOS / Windows）為主軸寫作，因為這是大多數老師的入口。但因為 Desktop / IDE 擴充 / CLI 三者**共用 `~/.codex/config.toml` 與 `AGENTS.md`**，每個 MCP 章節都同時提供三條路：
1. Desktop GUI（Integrations & MCP 面板）
2. 手動編輯 `~/.codex/config.toml`
3. CLI 指令

## 雙倉同步原則

- **不要**把 Codex 版直接 copy 過來；MCP 指令、設定檔格式、Skill 機制都不同
- 修改主流程（例如某 MCP 換新版指令）時，兩個資料夾都要更新
- 改完 push 到各自的 GitHub repo

## 提醒 Codex

- 使用者說「更新 Codex 懶人包」時 → 只動本資料夾
- 使用者說「兩邊都更新」時 → 兩個資料夾都改，commit 訊息分別寫
