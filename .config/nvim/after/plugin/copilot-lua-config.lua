require('copilot').setup({
    suggestion = {
        enabled = true,
        auto_trigger = false,
        debounce = 50,
        keymap = {
            accept = "<M-l>",
            accept_word = false,
            accept_line = false,
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
        },
    },
})
