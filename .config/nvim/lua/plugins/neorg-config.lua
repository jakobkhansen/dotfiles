vimscript = vim.api.nvim_exec
command = vim.api.nvim_command

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
		["core.norg.concealer"] = {}, -- Allows for use of icons
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
                workspace = "gtd"
            }
        },
	},
})

local neorg_leader = "<Leader>"

local neorg_callbacks = require("neorg.callbacks")

neorg_callbacks.on_event("core.keybinds.events.enable_keybinds", function(_, keybinds)
	-- Map all the below keybinds only when the "norg" mode is active
	keybinds.map_event_to_mode("norg", {
		n = { -- Bind keys in normal mode
			{ "<Leader>of", "core.integrations.telescope.find_linkable" },
		},

		i = { -- Bind in insert mode
			{ "<C-l>", "core.integrations.telescope.insert_link" },
		},
	}, {
		silent = true,
		noremap = true,
	})
end)

vimscript("au FileType norg set spell", false)
vimscript("au FileType norg map <buffer> <Leader> <Leader>", false)
--vimscript("autocmd VimEnter * NeorgStart", false)
command("silent! NeorgStart silent=true")
