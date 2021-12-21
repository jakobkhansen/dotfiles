local command = vim.api.nvim_command

require("fm-nvim").setup({
	-- Border around floating window
	border = "rounded", -- opts: 'rounded'; 'double'; 'single'; 'solid'; 'shawdow'

	-- Percentage (0.8 = 80%)
	height = 0.6,
	width = 1,

	-- Command used to open files
	edit_cmd = "edit", -- opts: 'tabedit'; 'split'; 'pedit'; etc...

	-- Terminal commands used w/ file manager
	ranger_cmd = "ranger",

	mappings = {
		vert_split = "<C-v>",
		horz_split = "<C-h>",
		tabedit = "<C-h>",
		edit = "<C-e>",
	},

	on_close = {
		function()
            local file = io.open("/tmp/ranger_dir", "r")

            io.input(file)


            local dir = io.read()
            command('cd ' .. dir)
		end,
	},
})
