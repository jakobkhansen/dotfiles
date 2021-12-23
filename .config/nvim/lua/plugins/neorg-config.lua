vimscript = vim.api.nvim_exec
command = vim.api.nvim_command
local vimp = require("vimp")
local map = vimp.map

require("neorg").setup({
	-- Tell Neorg what modules to load
	load = {
		["core.defaults"] = {}, -- Load all the default modules
		["core.norg.dirman"] = { -- Manage your directories with Neorg
			config = {
				workspaces = {
					gtd = "~/Documents/gtd",
				},
			},
		},
		["core.norg.completion"] = {
			config = {
				engine = "nvim-cmp", -- We current support nvim-compe and nvim-cmp only
			},
		},
		["core.norg.concealer"] = {
		},
		["core.keybinds"] = { -- Configure core.keybinds
			config = {
				default_keybinds = true, -- Generate the default keybinds
				neorg_leader = "<Leader>o", -- This is the default if unspecified
			},
		},
		["core.integrations.telescope"] = {},
		["core.gtd.ui"] = {},
		["core.gtd.queries"] = {},
		["core.gtd.base"] = {
			config = {
				workspace = "gtd",
				default_lists = {
					inbox = "inbox.norg",
				},
			},
		},
		["core.norg.journal"] = {
			config = {
				workspace = "gtd",
			},
		},
	},
})

local function getFirstDayOfCurrentMonth()
	print(os.date("%Y") .. "-" .. os.date("%m") .. "-01")
	return os.date("%Y") .. "-" .. os.date("%m") .. "-01"
end

map({ "silent" }, "<leader>oh", "<CMD>Neorg journal custom " .. getFirstDayOfCurrentMonth() .. "<CR>")

vimscript("au FileType norg set spell", false)
command("silent! NeorgStart silent=true")
