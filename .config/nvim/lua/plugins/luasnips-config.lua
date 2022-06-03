local ls = require("luasnip")
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Every unspecified option will be set to the default.
ls.config.set_config({
	history = true,
	-- Update more often, :h events for more info.
	updateevents = "TextChanged,TextChangedI",
})

ls.add_snippets("all", {
	ls.parser.parse_snippet({ trig = "rarr" }, "→"),
})
ls.add_snippets("markdown", {
	ls.parser.parse_snippet({ trig = "math" }, "\\$$0\\$"),
	ls.parser.parse_snippet({ trig = "checkempty" }, "[ ]"),
	ls.parser.parse_snippet({ trig = "checkfull" }, "[x]"),
})

keymap("s", "<C-k>", '<CMD>lua require("luasnip").jump(1)<CR>', opts)
keymap("s", "<C-j>", '<CMD>lua require("luasnip").jump(-1)<CR>', opts)
keymap("i", "<C-j>", '<CMD>lua require("luasnip").jump(-1)<CR>', opts)
keymap("i", "<C-k>", '<CMD>lua require("luasnip").jump(1)<CR>', opts)

require("luasnip/loaders/from_vscode").lazy_load()

require("luasnip").filetype_extend("javascript", { "javascriptreact" })
require("luasnip").filetype_extend("typescript", { "typescriptreact" })
