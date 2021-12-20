vimscript = vim.api.nvim_exec

require("neorg").setup({
	-- Tell Neorg what modules to load
	load = {
		["core.defaults"] = {}, -- Load all the default modules
		["core.norg.dirman"] = { -- Manage your directories with Neorg
			config = {
				workspaces = {
					gtd = "~/Documents/GTD",
				},
			},
		},
		["core.norg.completion"] = {
			config = {
				engine = "nvim-cmp", -- We current support nvim-compe and nvim-cmp only
			},
		},
		["core.norg.concealer"] = {}, -- Allows for use of icons
		["core.keybinds"] = { -- Configure core.keybinds
			config = {
				default_keybinds = true, -- Generate the default keybinds
				neorg_leader = "<Leader>o", -- This is the default if unspecified
			},
		},
		["core.gtd.ui"] = {},
		["core.gtd.queries"] = {},
		["core.gtd.base"] = { config = {
			workspace = "gtd",
		} },
	},
})

vimscript("au FileType norg set spell", false)
vimscript("au FileType norg set spell", false)
