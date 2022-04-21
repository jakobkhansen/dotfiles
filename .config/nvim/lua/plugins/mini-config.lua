require("mini.bufremove").setup()

require("mini.comment").setup()

require("mini.pairs").setup()


require("mini.surround").setup({
	n_lines = 20,

	-- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
	highlight_duration = 500,

	-- Pattern to match function name in 'function call' surrounding
	-- By default it is a string of letters, '_' or '.'

	-- Module mappings. Use `''` (empty string) to disable one.
	mappings = {
		add = "ss", -- Add surrounding
		delete = "ds", -- Delete surrounding
		find = "sf", -- Find surrounding (to the right)
		find_left = "sF", -- Find surrounding (to the left)
		highlight = "sh", -- Highlight surrounding
		replace = "cs", -- Replace surrounding
		update_n_lines = '', -- Update `n_lines`
	},
})
