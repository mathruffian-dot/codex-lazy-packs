---
name: codex-supabase
description: Codex 連接 Supabase MCP。說「連接 Supabase」時載入。
---

# 連接 Supabase（Codex 版）

1. `npm install -g @supabase/mcp-server-supabase`
2. 取得 project ref + API key
3. `codex mcp add supabase -- npx @supabase/mcp-server-supabase --project-ref <ref> --access-token <personal-access-token>`
   或手動編輯 `~/.codex/config.toml`
4. 重啟後驗證資料庫查詢

⚠️ API key 不寫進 AGENTS.md 或 repo。
