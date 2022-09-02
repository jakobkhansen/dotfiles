local cmp = require("cmp")
local lspkind = require("lspkind")

cmp.setup({
	-- You can set mappings if you want
	mapping = {
		["<S-Tab>"] = cmp.mapping.select_prev_item(),
		["<Tab>"] = cmp.mapping.select_next_item(),
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Insert,
		}),
	},

	-- You should specify your *installed* sources.
	sources = {
		{ name = "luasnip" },
		{ name = "nvim_lsp" },
		{ name = "treesitter" },
		{ name = "path" },
		{ name = "buffer" },
		{ name = "latex_symbols", keyword_length = 2 },
		-- { name = "nvim_lsp_signature_help" },
	},
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	formatting = {
		format = lspkind.cmp_format({ with_text = false, maxwidth = 50 }),
	},
})

require("cmp").setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "cmdline" },
	},
})
