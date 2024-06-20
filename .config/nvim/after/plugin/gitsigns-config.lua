require("gitsigns").setup({
    debug_mode = true,
    signs = {
        -- add          = { hl = "GitSignsAdd", text = "│", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
        -- change       = { hl = "GitSignsAdd", text = "│", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
        -- delete       = { hl = "GitSignsDelete", text = "│", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
        -- topdelete    = { hl = "GitSignsDelete", text = "│", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
        -- changedelete = { hl = "GitSignsDelete", text = "│", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
        -- untracked    = { hl = "GitSignsAdd", text = "│", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
        add          = { text = '┃' },
        change       = { text = '┃' },
        delete       = { text = '┃' },
        topdelete    = { text = '┃' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
    },
})
