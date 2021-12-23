local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }


keymap("", "#", ':call nerdcommenter#Comment(0, "toggle")<CR>', opts)

vim.g.NERDCreateDefaultMappings = 0
