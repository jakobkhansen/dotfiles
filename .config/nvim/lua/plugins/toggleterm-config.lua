local terms = require("toggleterm.terminal")
local fmt = string.format
local command = vim.api.nvim_command
local autocmd = vim.api.nvim_create_autocmd
local Terminal = terms.Terminal

require("toggleterm").setup({
	-- size can be a number or function which is passed the current terminal
	size = function(term)
		if term.direction == "horizontal" then
			return 15
		elseif term.direction == "vertical" then
			return vim.o.columns * 0.4
		end
	end,
	open_mapping = [[<C-\>]],
	hide_numbers = false, -- hide the number column in toggleterm buffers
	shade_filetypes = {},
	shade_terminals = false,
	shading_factor = 3, -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
	start_in_insert = false,
	insert_mappings = true, -- whether or not the open mapping applies in insert mode
	persist_size = true,
	direction = "horizontal",
	close_on_exit = true, -- close the terminal window when the process exits
	shell = vim.o.shell, -- change the default shell
	-- This field is only relevant if direction is set to 'float'
	float_opts = {
		-- The border key is *almost* the same as 'nvim_open_win'
		-- see :h nvim_open_win for details on borders however
		-- the 'curved' border is a custom border type
		-- not natively supported but implemented in this plugin.
		border = "single",
		--width = <value>,
		--height = <value>,
		winblend = 3,
		highlights = {
			border = "Normal",
			background = "Normal",
		},
	},
})

local fullTerm = Terminal:new({})

autocmd("FileType", {
	pattern = "toggleterm",
	command = "map <buffer> <Tab> <Nop>",
})

autocmd("FileType", {
	pattern = "toggleterm",
	command = "map <buffer> <Leader>pc <CMD>lua updateTermDirectory()<CR>",
})

function _G.updateTermDirectory()
	local dir = vim.fn.fnamemodify(vim.fn.getcwd(), ":p")
	local num = 1
	local is_open = terms.get(num) ~= nil and terms.get(num):is_open() or false

	if is_open and terms.get(num).dir ~= dir then
		terms.get(num):send({ fmt(" chdir '%s'", dir) })
		terms.get(num):send({ fmt(" ", dir) })
		command("cd " .. dir)
	end
end
