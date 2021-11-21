local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local command = vim.api.nvim_command

require("telescope").setup({
	extensions = {
		fzf = {
			fuzzy = true, -- false will only do exact matching
			override_generic_sorter = true, -- override the generic sorter
			override_file_sorter = true, -- override the file sorter
			case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			-- the default case_mode is "smart_case"
		},
	},
	defaults = {
		file_ignore_patterns = { "%.class", "%.pdf" },
	},
})

require('telescope').load_extension('fzf')
require('telescope').load_extension("termfinder")

function _G.telescope_find_dir(opts)
    opts = opts or {}
	pickers.new(opts, {
		prompt_title = "Find Directory",
		finder = finders.new_oneshot_job({ "fd", "-t", "d" }),
		sorter = conf.generic_sorter(opts),
		attach_mappings = function(prompt_bufnr, map)
			actions.select_default:replace(function()
				local selection = action_state.get_selected_entry()
                if selection ~= nil then
				    actions.close(prompt_bufnr)
				    command("cd " .. selection[1])
                end
			end)
			return true
		end,
	}):find()
end

function _G.telescope_find_dir_home(opts)
	pickers.new(opts, {
		prompt_title = "Find Directory",
		finder = finders.new_oneshot_job({ "fd", ".", vim.fn.expand("$HOME") }, { "-t", "d", "-a" }),
		sorter = conf.generic_sorter(opts),
		attach_mappings = function(prompt_bufnr, map)
			actions.select_default:replace(function()
				local selection = action_state.get_selected_entry()
                if selection ~= nil then
				    actions.close(prompt_bufnr)
				    command("cd " .. selection[1])
                end
				return
			end)
			return true
		end,
	}):find()
end

