require("agentic").setup({
    -- Any ACP-compatible provider works. Built-in: "claude-agent-acp" | "gemini-acp" | "codex-acp" | "opencode-acp" | "cursor-acp" | "copilot-acp" | "auggie-acp" | "mistral-vibe-acp" | "cline-acp" | "goose-acp" | "kiro-acp" | "pi-acp"
    provider = "copilot-acp", -- setting the name here is all you need to get started
    keymaps = {
        prompt = {
            submit = {
                "<CR>",
                {
                    "<CR>",
                    mode = { "i", "n", "v" },
                },
            },
            accept_completion = {
                "<S-CR>",
            },
        }
    },
    diff_preview = {
        enabled = true,
        layout = "inline", -- "split" or "inline"
        center_on_navigate_hunks = true,
    },
    settings = {
        move_cursor_to_chat_on_submit = false,
    },
})
