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
        { name = "orgmode" },
		{
			name = "dictionary",
			keyword_length = 2,
		},
		{ name = "calc" },
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

require("cmp_dictionary").setup({
	dic = {
		["norg,markdown,tex"] = { "/usr/share/dict/words" },
	},
	-- The following are default values, so you don't need to write them if you don't want to change them
	exact = 2,
	first_case_insensitive = false,
	async = false,
	capacity = 5,
	debug = false,
})
