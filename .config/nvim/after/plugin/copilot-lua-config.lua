require('copilot').setup({
    suggestion = {
        enabled = false,
        auto_trigger = true,
        debounce = 50,
        keymap = {
            accept = "<Right>",
            accept_word = false,
            accept_line = false,
            next = "<Down>",
            prev = "<Up>",
            dismiss = "<C-]>",
        },
    },
})
